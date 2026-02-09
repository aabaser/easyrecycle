#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import csv
import re
import unicodedata
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Tuple

from sqlalchemy import create_engine, text

IN_REMOVE_CHARS = "®™©"


@dataclass(frozen=True)
class AliasRow:
    canonical_key: str
    lang: str
    alias_text: str
    alias_norm: str
    alias_type: str  # primary|auto
    source: str      # seed
    confidence: float


def _strip_accents(s: str) -> str:
    # Removes accents: é->e, ü->u (NOTE: different from ue/oe/ae expansion)
    nfkd = unicodedata.normalize("NFKD", s)
    return "".join(ch for ch in nfkd if not unicodedata.combining(ch))


def normalize_basic(s: str) -> str:
    """
    General normalization:
    - lower
    - remove ®™©
    - remove accents (ü->u)
    - non-alnum -> space
    - collapse spaces
    """
    if s is None:
        return ""
    s = s.strip().lower()
    for ch in IN_REMOVE_CHARS:
        s = s.replace(ch, "")
    s = _strip_accents(s)
    s = re.sub(r"[^a-z0-9]+", " ", s)
    s = re.sub(r"\s+", " ", s).strip()
    return s


def normalize_no_space(s: str) -> str:
    return normalize_basic(s).replace(" ", "")


def normalize_de_umlaut_ae(s: str) -> str:
    """
    German-friendly normalization that expands umlauts:
      ß->ss, ä->ae, ö->oe, ü->ue
    Still removes other accents too.
    """
    if s is None:
        return ""
    s = s.strip().lower()
    for ch in IN_REMOVE_CHARS:
        s = s.replace(ch, "")

    s = (s.replace("ß", "ss")
           .replace("ä", "ae")
           .replace("ö", "oe")
           .replace("ü", "ue"))

    s = _strip_accents(s)
    s = re.sub(r"[^a-z0-9]+", " ", s)
    s = re.sub(r"\s+", " ", s).strip()
    return s


def gen_alias_rows(canonical_key: str, lang: str, text: str) -> Iterable[AliasRow]:
    """
    IMPORTANT:
    - Seed aliases are generated ONLY from the i18n 'text' column.
    - No singular/plural generation.
    - canonical_key is used only as target identifier.
    """
    if not text or not text.strip():
        return

    # Primary
    nb = normalize_basic(text)
    if nb:
        yield AliasRow(canonical_key, lang, text, nb, "primary", "seed", 1.00)

    # No-space variant (good for Super-8-Filme -> super8filme)
    nn = normalize_no_space(text)
    if nn and nn != nb:
        yield AliasRow(canonical_key, lang, text, nn, "auto", "seed", 0.85)

    # German umlaut-expanded variants (Südfrüchte -> suedfruechte)
    if lang == "de":
        um = normalize_de_umlaut_ae(text)
        if um and um != nb:
            yield AliasRow(canonical_key, lang, text, um, "auto", "seed", 0.90)

        # Keep this as-is; duplicates of same canonical_key won't be reported as collisions (Fix2)
        um_ns = um.replace(" ", "") if um else ""
        if um_ns and um_ns not in (nn, nb):
            yield AliasRow(canonical_key, lang, text, um_ns, "auto", "seed", 0.80)


def _prefer(a: AliasRow, b: AliasRow) -> AliasRow:
    """
    Returns the preferred row between a and b for same (lang, alias_norm).
    Prefer higher confidence; if tie, prefer primary over auto.
    """
    rank = {"primary": 2, "auto": 1}
    if (a.confidence > b.confidence) or (
        a.confidence == b.confidence and rank.get(a.alias_type, 0) > rank.get(b.alias_type, 0)
    ):
        return a
    return b


def main(
    out_csv: Path,
    collisions_csv: Path,
    only_langs: Optional[List[str]] = None,
    database_url: Optional[str] = None,
):
    """
    Produces:
      - out_csv: deduped best alias per (lang, alias_norm)
      - collisions_csv: ONLY real collisions (different canonical_key) for same (lang, alias_norm)
    Dedup strategy:
      - keep higher confidence
      - if equal confidence: prefer primary over auto
    """
    best: Dict[Tuple[str, str], AliasRow] = {}
    collisions: List[Tuple[str, str, str, str, float, str]] = []

    def handle_row(canonical_key: str, lang: str, text_val: str) -> None:
        if not canonical_key or not lang:
            return
        if only_langs and lang not in only_langs:
            return
        for a in gen_alias_rows(canonical_key, lang, text_val):
            if not a.alias_norm:
                continue

            k = (a.lang, a.alias_norm)
            prev = best.get(k)
            if prev is None:
                best[k] = a
                continue

            # Fix2: if same canonical_key, treat as harmless duplicate (no collision report)
            if prev.canonical_key == a.canonical_key:
                best[k] = _prefer(a, prev)
                continue

            # Different canonical_key => real collision
            winner = _prefer(a, prev)
            loser = prev if winner is a else a

            collisions.append((
                winner.lang,
                winner.alias_norm,
                loser.canonical_key,
                winner.canonical_key,
                float(winner.confidence),
                winner.alias_type
            ))
            best[k] = winner

    if not database_url:
        raise SystemExit("Provide --database-url")

    engine = create_engine(database_url)
    with engine.connect() as conn:
        rows = conn.execute(
            text(
                """
                SELECT i.canonical_key, t.text, t.lang
                FROM core.item i
                JOIN core.i18n_translation t
                  ON i.title_key = t.key
                """
            )
        ).fetchall()
    for canonical_key, text_val, lang in rows:
        handle_row(str(canonical_key), str(lang), str(text_val or ""))

    # write seed CSV
    out_csv.parent.mkdir(parents=True, exist_ok=True)
    with out_csv.open("w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow(["canonical_key", "lang", "alias_text", "alias_norm", "alias_type", "source", "confidence"])
        for (_, _), a in sorted(best.items(), key=lambda kv: (kv[0][0], kv[0][1])):
            w.writerow([a.canonical_key, a.lang, a.alias_text, a.alias_norm, a.alias_type, a.source, f"{a.confidence:.2f}"])

    # write collisions report
    collisions_csv.parent.mkdir(parents=True, exist_ok=True)
    with collisions_csv.open("w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow(["lang", "alias_norm", "loser_canonical_key", "winner_canonical_key", "winner_confidence", "winner_alias_type"])
        for c in collisions:
            w.writerow(list(c))

    print(f"✅ Wrote seed aliases: {out_csv} ({len(best)} rows)")
    print(f"⚠️  Collisions report (real only): {collisions_csv} ({len(collisions)} rows)")


if __name__ == "__main__":
    import argparse

    p = argparse.ArgumentParser()
    p.add_argument("--database-url", dest="database_url", required=True, help="Read from DB (core.item + i18n)")
    p.add_argument("--out", dest="out_csv", default="data/item_alias_seed.csv")
    p.add_argument("--collisions", dest="collisions_csv", default="data/item_alias_collisions.csv")
    p.add_argument("--langs", dest="langs", default=None, help="Comma-separated langs, e.g. de,en,tr")
    args = p.parse_args()

    only = args.langs.split(",") if args.langs else None
    main(Path(args.out_csv), Path(args.collisions_csv), only_langs=only, database_url=args.database_url)
