"""
CSV -> Postgres import for Easy Recycle.

Implements the rules from docs/40_import-pipeline.md:
- Unpivot *_de/_en/_tr into core.i18n_translation
- Cities: hannover is base, berlin inherits (berlin.base_city_id = hannover)
- Berlin rows only persist overrides; fallback is handled by the city chain in resolve

Usage:
  python scripts/import_csv.py data/aha_abc_new_05_01_2026_12.csv
  python scripts/import_csv.py ... --dry-run   # preview only
"""
from __future__ import annotations

import argparse
import os
import re
from dataclasses import dataclass
from typing import Dict, Iterable, List, Optional, Sequence, Tuple

import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.engine import Connection

DEFAULT_LANGS: Tuple[str, ...] = ("de", "en", "tr")
ACTIVE_LANGS: Tuple[str, ...] = DEFAULT_LANGS


def slug(value: str) -> str:
  """Create a stable code identifier."""
  value = (value or "").strip().lower()
  # German transliteration before stripping non-ascii chars
  value = (
    value.replace("ä", "ae")
    .replace("ö", "oe")
    .replace("ü", "ue")
    .replace("ß", "ss")
  )
  value = re.sub(r"[^a-z0-9]+", "_", value).strip("_")
  return value or "item"


def split_multi(value: object) -> List[str]:
  """Split comma/semicolon/newline separated strings while preserving order."""
  if value is None or (isinstance(value, float) and pd.isna(value)):
    return []
  parts = re.split(r"[;,\n]+", str(value))
  return [p.strip() for p in parts if p.strip()]


def make_unique_slugs(values: Iterable[str]) -> List[str]:
  """Ensure slugs are unique by appending -2, -3, ... on collisions."""
  counts: Dict[str, int] = {}
  result: List[str] = []
  for val in values:
    base = val or "item"
    counts[base] = counts.get(base, 0) + 1
    if counts[base] == 1:
      result.append(base)
    else:
      result.append(f"{base}-{counts[base]}")
  return result


def upsert_translation(conn: Connection, key: str, lang: str, text_value: str) -> None:
  conn.execute(
    text(
      """
      INSERT INTO core.i18n_translation(key, lang, text)
      VALUES (:key, :lang, :text)
      ON CONFLICT (key, lang)
      DO UPDATE SET text = EXCLUDED.text, updated_at = now()
      """
    ),
    {"key": key, "lang": lang, "text": text_value},
  )


def ensure_city(conn: Connection, code: str, base_city_id: Optional[str] = None) -> str:
  name_key = f"city.{code}.name"
  for lang in ACTIVE_LANGS:
    upsert_translation(conn, name_key, lang, code.capitalize())

  res = conn.execute(
    text(
      """
      INSERT INTO core.city(code, name_key, base_city_id)
      VALUES (:code, :name_key, :base_city_id)
      ON CONFLICT (code)
      DO UPDATE SET name_key = EXCLUDED.name_key,
                    base_city_id = EXCLUDED.base_city_id,
                    updated_at = now()
      RETURNING city_id::text
      """
    ),
    {"code": code, "name_key": name_key, "base_city_id": base_city_id},
  )
  return res.scalar_one()


def ensure_category(conn: Connection, label: str) -> str:
  code = slug(label)
  name_key = f"category.{code}.name"
  for lang in ACTIVE_LANGS:
    upsert_translation(conn, name_key, lang, label)
  res = conn.execute(
    text(
      """
      INSERT INTO core.category(code, name_key)
      VALUES (:code, :name_key)
      ON CONFLICT (code)
      DO UPDATE SET name_key = EXCLUDED.name_key,
                    updated_at = now()
      RETURNING category_id::text
      """
    ),
    {"code": code, "name_key": name_key},
  )
  return res.scalar_one()


def ensure_disposal(conn: Connection, label: str) -> str:
  code = slug(label)
  name_key = f"disposal.{code}.name"
  for lang in ACTIVE_LANGS:
    upsert_translation(conn, name_key, lang, label)
  res = conn.execute(
    text(
      """
      INSERT INTO core.disposal_method(code, name_key)
      VALUES (:code, :name_key)
      ON CONFLICT (code)
      DO UPDATE SET name_key = EXCLUDED.name_key,
                    updated_at = now()
      RETURNING disposal_id::text
      """
    ),
    {"code": code, "name_key": name_key},
  )
  return res.scalar_one()


def ensure_warning(conn: Connection, label: str) -> str:
  code = slug(label)
  title_key = f"warning.{code}.title"
  body_key = f"warning.{code}.body"
  for lang in ACTIVE_LANGS:
    upsert_translation(conn, title_key, lang, label)
    upsert_translation(conn, body_key, lang, label)
  res = conn.execute(
    text(
      """
      INSERT INTO core.warning(code, title_key, body_key)
      VALUES (:code, :title_key, :body_key)
      ON CONFLICT (code)
      DO UPDATE SET title_key = EXCLUDED.title_key,
                    body_key = EXCLUDED.body_key,
                    updated_at = now()
      RETURNING warning_id::text
      """
    ),
    {"code": code, "title_key": title_key, "body_key": body_key},
  )
  return res.scalar_one()


def upsert_item(
  conn: Connection,
  canonical_key: str,
  title_key: str,
  desc_key: Optional[str],
  source: Optional[str],
  external_document_id: Optional[str],
) -> str:
  res = conn.execute(
    text(
      """
      INSERT INTO core.item (canonical_key, title_key, desc_key, source, external_document_id)
      VALUES (:canonical_key, :title_key, :desc_key, :source, :external_document_id)
      ON CONFLICT (canonical_key)
      DO UPDATE SET title_key = EXCLUDED.title_key,
                    desc_key = COALESCE(EXCLUDED.desc_key, core.item.desc_key),
                    source = COALESCE(EXCLUDED.source, core.item.source),
                    external_document_id = COALESCE(EXCLUDED.external_document_id, core.item.external_document_id),
                    updated_at = now()
      RETURNING item_id::text
      """
    ),
    {
      "canonical_key": canonical_key,
      "title_key": title_key,
      "desc_key": desc_key,
      "source": source,
      "external_document_id": external_document_id,
    },
  )
  return res.scalar_one()


def upsert_text_override(
  conn: Connection,
  city_id: str,
  item_id: str,
  title_key: Optional[str],
  desc_key: Optional[str],
) -> None:
  if not title_key and not desc_key:
    return
  conn.execute(
    text(
      """
      INSERT INTO core.item_city_text_override (city_id, item_id, title_key, desc_key)
      VALUES (:city_id, :item_id, :title_key, :desc_key)
      ON CONFLICT (city_id, item_id)
      DO UPDATE SET title_key = COALESCE(EXCLUDED.title_key, core.item_city_text_override.title_key),
                    desc_key = COALESCE(EXCLUDED.desc_key, core.item_city_text_override.desc_key)
      """
    ),
    {"city_id": city_id, "item_id": item_id, "title_key": title_key, "desc_key": desc_key},
  )


def upsert_item_city_list(
  conn: Connection,
  table: str,
  city_id: str,
  item_id: str,
  pairs: Iterable[Tuple[str, int]],
) -> None:
  for obj_id, priority in pairs:
    conn.execute(
      text(
        f"""
        INSERT INTO {table} (city_id, item_id, {table.split('_')[-1]}_id, priority)
        VALUES (:city_id, :item_id, :obj_id, :priority)
        ON CONFLICT (city_id, item_id, {table.split('_')[-1]}_id)
        DO UPDATE SET priority = EXCLUDED.priority
        """
      ),
      {"city_id": city_id, "item_id": item_id, "obj_id": obj_id, "priority": priority},
    )


def upsert_item_city_warnings(conn: Connection, city_id: str, item_id: str, warning_ids: Sequence[str]) -> None:
  for wid in warning_ids:
    conn.execute(
      text(
        """
        INSERT INTO core.item_city_warning (city_id, item_id, warning_id)
        VALUES (:city_id, :item_id, :warning_id)
        ON CONFLICT (city_id, item_id, warning_id) DO NOTHING
        """
      ),
      {"city_id": city_id, "item_id": item_id, "warning_id": wid},
    )


def coalesce_text(*values: object) -> Optional[str]:
  for v in values:
    if v is None:
      continue
    if isinstance(v, float) and pd.isna(v):
      continue
    text_val = str(v).strip()
    if text_val:
      return text_val
  return None


@dataclass
class CityData:
  city_code: str
  desc_key: Optional[str]
  desc_values: Dict[str, str]
  categories: List[str]
  disposals: List[str]
  warnings: List[str]


def extract_city_data(row: pd.Series, city: str, default_prefix: str = "default") -> CityData:
  """Pick city-specific values, falling back to defaults when city lacks data."""
  desc_values: Dict[str, str] = {}
  desc_key: Optional[str] = None
  for lang in ACTIVE_LANGS:
    city_val = row.get(f"{city}_{lang}_desc")
    default_val = row.get(f"{default_prefix}_{lang}_desc")
    val = coalesce_text(city_val, default_val)
    if val:
      desc_key = f"item.{row['_canonical_key']}.desc.{city}"
      desc_values[lang] = val

  # categories/disposals/warnings: use city column if present, else default
  cat_val = coalesce_text(row.get(f"{city}_de_categories"), row.get(f"{default_prefix}_de_categories"))
  disp_val = coalesce_text(row.get(f"{city}_de_disposals"), row.get(f"{default_prefix}_de_disposals"))
  warn_val = coalesce_text(row.get(f"{city}_de_warnings"), row.get(f"{default_prefix}_de_warnings"))

  categories = split_multi(cat_val)
  disposals = split_multi(disp_val)
  warnings = split_multi(warn_val)

  return CityData(city_code=city, desc_key=desc_key, desc_values=desc_values, categories=categories, disposals=disposals, warnings=warnings)


def build_base_desc_key(row: pd.Series) -> Optional[str]:
  has_any = any(coalesce_text(row.get(f"default_{lang}_desc")) for lang in ACTIVE_LANGS)
  return f"item.{row['_canonical_key']}.desc" if has_any else None


def detect_langs(df: pd.DataFrame) -> Tuple[str, ...]:
  langs = []
  for lang in DEFAULT_LANGS:
    cols = [c for c in df.columns if c.endswith(f"_{lang}")]
    if cols and df[cols].notna().any().any():
      langs.append(lang)
  return tuple(langs) if langs else ("de",)


def truncate_i18n(conn: Connection) -> None:
  """Clear i18n_translation so we only keep freshly imported rows."""
  conn.execute(text("TRUNCATE TABLE core.i18n_translation"))


def reset_i18n_table(conn: Connection) -> None:
  # Drop and recreate i18n_translation to ensure only freshly imported rows remain.
  conn.execute(text("DROP TABLE IF EXISTS core.i18n_translation"))
  conn.execute(
    text(
      """
      CREATE TABLE core.i18n_translation (
        key            text NOT NULL,
        lang           text NOT NULL REFERENCES core.language(lang),
        text           text NOT NULL,
        updated_at     timestamptz NOT NULL DEFAULT now(),
        PRIMARY KEY (key, lang)
      )
      """
    )
  )


def reset_core_tables(conn: Connection) -> None:
  """Wipe all core data tables except language."""
  conn.execute(
    text(
      """
      TRUNCATE TABLE
        core.item_feedback,
        core.scan_event,
        core.vision_cache,
        core.prospect,
        core.city_category_label,
        core.city_disposal_label,
        core.item_city_warning,
        core.item_city_disposal,
        core.item_city_action,
        core.item_city_category,
        core.item_city_text_override,
        core.item_alias,
        core.item,
        core.image_asset,
        core.warning,
        core.disposal_method,
        core.category,
        core.i18n_translation,
        core.city
      CASCADE
      """
    )
  )


def main() -> None:
  global ACTIVE_LANGS
  parser = argparse.ArgumentParser()
  parser.add_argument("csv", help="Path to CSV file")
  parser.add_argument("--database-url", default=os.getenv("DATABASE_URL"))
  parser.add_argument("--dry-run", action="store_true", help="Preview without writing to the database")
  parser.add_argument("--full-reset", action="store_true", help="Delete all core data before import")
  args = parser.parse_args()

  if not args.database_url and not args.dry_run:
    raise SystemExit("DATABASE_URL not set. Example: postgresql+psycopg://postgres:postgres@localhost:5432/easy_recycle")

  # CSV path is used for Hannover defaults only (no Berlin overrides yet).
  raw = pd.read_csv(args.csv)
  df = raw.copy()
  df["source"] = "hannover_csv"
  df["name"] = df["title"]
  # Build stable unique document IDs to avoid slug collisions
  base_slugs = df["title"].apply(slug)
  df["documentID"] = make_unique_slugs(base_slugs.tolist())
  df["de_title"] = df["title"]
  # Map Hannover/default columns to match importer expectations
  df["default_de_desc"] = df["description"]
  df["hannover_de_desc"] = df["description"]
  df["default_de_categories"] = df.get("categories")
  df["hannover_de_categories"] = df.get("categories")
  df["default_de_disposals"] = df.get("disposals")
  df["hannover_de_disposals"] = df.get("disposals")
  df["default_de_warnings"] = df.get("warnings")
  df["hannover_de_warnings"] = df.get("warnings")
  # Berlin columns left empty for now

  ACTIVE_LANGS = detect_langs(df)
  base_keys = df.apply(lambda r: slug(str(r.get("documentID") or r.get("name") or "item")), axis=1).tolist()
  df["_canonical_key"] = make_unique_slugs(base_keys)

  stats = {"items": 0, "categories": 0, "disposals": 0, "warnings": 0, "overrides_berlin": 0}

  if args.dry_run:
    print(f"[dry-run] Loaded {len(df)} rows from CSV")
    print(df.head(5))
    print(f"[dry-run] rows={len(df)}")
    print(f"[dry-run] languages detected: {ACTIVE_LANGS}")
    return

  engine = create_engine(args.database_url)
  with engine.begin() as conn:
    if args.full_reset:
      reset_core_tables(conn)
    else:
      truncate_i18n(conn)
    hannover_id = ensure_city(conn, "hannover")
    berlin_id = ensure_city(conn, "berlin", base_city_id=hannover_id)

    for _, row in df.iterrows():
      canonical_key = row["_canonical_key"]
      title_key = f"item.{canonical_key}.title"
      base_desc_key = build_base_desc_key(row)

      # Translations: titles (detected languages)
      for lang in ACTIVE_LANGS:
        title_val = coalesce_text(row.get(f"{lang}_title"), row.get("name"))
        if title_val:
          upsert_translation(conn, title_key, lang, title_val)

      # Base description translations
      if base_desc_key:
        for lang in ACTIVE_LANGS:
          desc_val = coalesce_text(row.get(f"default_{lang}_desc"))
          if desc_val:
            upsert_translation(conn, base_desc_key, lang, desc_val)

      item_id = upsert_item(
        conn,
        canonical_key=canonical_key,
        title_key=title_key,
        desc_key=base_desc_key,
        source=coalesce_text(row.get("source")),
        external_document_id=coalesce_text(row.get("documentID")),
      )
      stats["items"] += 1

      # City data: Hannover (base) always populated with default fallback
      hannover_data = extract_city_data(row, "hannover", default_prefix="default")
      berlin_data = extract_city_data(row, "berlin", default_prefix="hannover")

      # City text overrides
      if hannover_data.desc_key:
        for lang, txt in hannover_data.desc_values.items():
          upsert_translation(conn, hannover_data.desc_key, lang, txt)
        upsert_text_override(conn, hannover_id, item_id, title_key=None, desc_key=hannover_data.desc_key)

      if berlin_data.desc_values and berlin_data.desc_values != hannover_data.desc_values:
        for lang, txt in berlin_data.desc_values.items():
          upsert_translation(conn, berlin_data.desc_key, lang, txt)
        upsert_text_override(conn, berlin_id, item_id, title_key=None, desc_key=berlin_data.desc_key)
        stats["overrides_berlin"] += 1

      # Categories
      category_pairs = []
      for priority, cat in enumerate(hannover_data.categories, start=1):
        cat_id = ensure_category(conn, cat)
        category_pairs.append((cat_id, priority))
        stats["categories"] += 1
      upsert_item_city_list(conn, "core.item_city_category", hannover_id, item_id, category_pairs)

      if berlin_data.categories and berlin_data.categories != hannover_data.categories:
        berlin_pairs = []
        for priority, cat in enumerate(berlin_data.categories, start=1):
          cat_id = ensure_category(conn, cat)
          berlin_pairs.append((cat_id, priority))
        upsert_item_city_list(conn, "core.item_city_category", berlin_id, item_id, berlin_pairs)

      # Disposals
      disposal_pairs = []
      for priority, disp in enumerate(hannover_data.disposals, start=1):
        disp_id = ensure_disposal(conn, disp)
        disposal_pairs.append((disp_id, priority))
        stats["disposals"] += 1
      upsert_item_city_list(conn, "core.item_city_disposal", hannover_id, item_id, disposal_pairs)

      if berlin_data.disposals and berlin_data.disposals != hannover_data.disposals:
        berlin_pairs = []
        for priority, disp in enumerate(berlin_data.disposals, start=1):
          disp_id = ensure_disposal(conn, disp)
          berlin_pairs.append((disp_id, priority))
        upsert_item_city_list(conn, "core.item_city_disposal", berlin_id, item_id, berlin_pairs)

      # Warnings
      hannover_warning_ids = [ensure_warning(conn, w) for w in hannover_data.warnings]
      if hannover_warning_ids:
        stats["warnings"] += len(hannover_warning_ids)
        upsert_item_city_warnings(conn, hannover_id, item_id, hannover_warning_ids)

      if berlin_data.warnings and berlin_data.warnings != hannover_data.warnings:
        berlin_warning_ids = [ensure_warning(conn, w) for w in berlin_data.warnings]
        upsert_item_city_warnings(conn, berlin_id, item_id, berlin_warning_ids)

    print("Import completed.")
    print(f"items={stats['items']} categories={stats['categories']} disposals={stats['disposals']} warnings={stats['warnings']} berlin_overrides={stats['overrides_berlin']}")


if __name__ == "__main__":
  main()
