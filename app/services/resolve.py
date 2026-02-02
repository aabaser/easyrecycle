from __future__ import annotations
from typing import Optional, Dict, Any, List
from sqlalchemy import text
from sqlalchemy.orm import Session
import re
import unicodedata

def _city_id(db: Session, city_code: str) -> Optional[str]:
  r = db.execute(
    text("SELECT city_id::text FROM core.city WHERE code = :code"),
    {"code": city_code},
  ).fetchone()
  return r[0] if r else None


def _suggest_similar(db: Session, query_text: str, lang: str, city_id: str, exclude_item_id: Optional[str], limit: int = 3) -> List[Dict[str, Any]]:
  exclude_sql = ""
  if exclude_item_id:
    exclude_sql = "WHERE i.item_id::text <> :exclude_item_id"

  base_sql = f"""
    WITH candidates AS (
      SELECT i.item_id::text AS item_id,
             COALESCE(tt.text, i.canonical_key) AS label,
             similarity(COALESCE(tt.text, i.canonical_key), :q) AS sim,
             ts_rank(
               to_tsvector('simple', concat_ws(' ', COALESCE(tt.text, ''), COALESCE(td.text, ''), i.canonical_key)),
               plainto_tsquery('simple', :q)
             ) AS rank
      FROM core.item i
      JOIN core.item_city_category icc ON icc.item_id = i.item_id AND icc.city_id = :city_id
      LEFT JOIN LATERAL (
        SELECT text FROM core.i18n_translation t
        WHERE t.key = i.title_key AND t.lang = :lang
        LIMIT 1
      ) tt ON TRUE
      LEFT JOIN LATERAL (
        SELECT text FROM core.i18n_translation t
        WHERE t.key = i.desc_key AND t.lang = :lang
        LIMIT 1
      ) td ON TRUE
      {exclude_sql}
    ),
    scored AS (
      SELECT *, (rank * 0.7 + sim * 0.3) AS score
      FROM candidates
      WHERE rank > 0 OR sim > 0.1
    ),
    best_per_item AS (
      SELECT *, ROW_NUMBER() OVER (PARTITION BY item_id ORDER BY score DESC, sim DESC) AS rn_item
      FROM scored
    ),
    best_per_label AS (
      SELECT *, ROW_NUMBER() OVER (PARTITION BY lower(label) ORDER BY sim DESC) AS rn_label
      FROM best_per_item
      WHERE rn_item = 1
    )
    SELECT item_id, label, sim
    FROM best_per_label
    WHERE rn_label = 1
    ORDER BY score DESC, sim DESC
    LIMIT :limit
  """
  params = {
    "q": query_text,
    "lang": lang,
    "city_id": city_id,
    "limit": limit,
  }
  if exclude_item_id:
    params["exclude_item_id"] = exclude_item_id
  rows = db.execute(text(base_sql), params).fetchall()
  return [{"item_id": r[0], "alias": r[1], "similarity": float(r[2])} for r in rows]


def _create_prospect(db: Session, item_id: Optional[str], city_id: str, lang: str, reason: str, search_text: Optional[str] = None) -> bool:
  res = db.execute(
    text(
      """
      INSERT INTO core.prospect (item_id, city_id, lang, reason, status, search_text)
      VALUES (:item_id, :city_id, :lang, :reason, 'pending', :search_text)
      ON CONFLICT DO NOTHING
      RETURNING prospect_id
      """
    ),
    {"item_id": item_id, "city_id": city_id, "lang": lang, "reason": reason, "search_text": search_text},
  )
  created = res.fetchone() is not None
  if created:
    db.commit()
  return created

def _t(db: Session, key: str, lang: str) -> Optional[str]:
  # Only return requested lang; no fallback when not present (en/tr may be empty)
  sql = text("""
    SELECT text FROM core.i18n_translation WHERE key=:key AND lang=:lang
  """)
  r = db.execute(sql, {"key": key, "lang": lang}).fetchone()
  if r:
    return r[0]
  return None


def _normalize_basic(s: str) -> str:
  """
  Normalize search input to match item_alias.alias_norm:
  - lower
  - strip accents
  - non-alnum -> space
  - collapse spaces
  """
  if not s:
    return ""
  s = s.strip().lower()
  nfkd = unicodedata.normalize("NFKD", s)
  s = "".join(ch for ch in nfkd if not unicodedata.combining(ch))
  s = re.sub(r"[^a-z0-9]+", " ", s)
  s = re.sub(r"\s+", " ", s).strip()
  return s


def _find_item_by_alias(db: Session, name: str, lang: str, city_id: str) -> Optional[str]:
  norm = _normalize_basic(name)
  if not norm:
    return None
  sql = text("""
    SELECT i.item_id::text
    FROM core.item_alias a
    JOIN core.item i ON i.canonical_key = a.canonical_key
    WHERE a.lang = :lang AND a.alias_norm = :norm
      AND EXISTS (
        SELECT 1 FROM core.item_city_category icc
        WHERE icc.item_id = i.item_id AND icc.city_id = :city_id
        UNION ALL
        SELECT 1 FROM core.item_city_disposal icd
        WHERE icd.item_id = i.item_id AND icd.city_id = :city_id
      )
    LIMIT 1
  """)
  r = db.execute(sql, {"lang": lang, "norm": norm, "city_id": city_id}).fetchone()
  return r[0] if r else None

def _find_item_by_name(db: Session, name: str, lang: str, city_id: str) -> Optional[str]:
  """
  Exact match search (case-insensitive) across:
  - title translations for the lang
  - canonical_key
  Prioritizes title then canonical.
  Only matches items that have city rules for the requested city (no city fallback).
  """
  sql = text("""
    WITH candidates AS (
      SELECT i.item_id::text AS item_id, 0 AS priority
      FROM core.item i
      JOIN core.i18n_translation t ON t.key = i.title_key AND t.lang = :lang
      WHERE lower(t.text) = lower(:name)
        AND EXISTS (
          SELECT 1 FROM core.item_city_category icc
          WHERE icc.item_id = i.item_id AND icc.city_id = :city_id
          UNION ALL
          SELECT 1 FROM core.item_city_disposal icd
          WHERE icd.item_id = i.item_id AND icd.city_id = :city_id
        )

      UNION ALL
      SELECT i.item_id::text AS item_id, 1 AS priority
      FROM core.item i
      WHERE lower(i.canonical_key) = lower(:name)
        AND EXISTS (
          SELECT 1 FROM core.item_city_category icc
          WHERE icc.item_id = i.item_id AND icc.city_id = :city_id
          UNION ALL
          SELECT 1 FROM core.item_city_disposal icd
          WHERE icd.item_id = i.item_id AND icd.city_id = :city_id
        )
    )
    SELECT item_id
    FROM candidates
    ORDER BY priority ASC
    LIMIT 1
  """)
  r = db.execute(sql, {"lang": lang, "name": name, "city_id": city_id}).fetchone()
  return r[0] if r else None


def _load_city_categories(db: Session, city_id: str, item_id: str, lang: str) -> List[Dict[str, Any]]:
  rows = db.execute(text("""
    SELECT cat.code, cat.name_key
    FROM core.item_city_category icc
    JOIN core.category cat ON cat.category_id = icc.category_id
    WHERE icc.city_id = :city_id AND icc.item_id::uuid = :item_id
    ORDER BY icc.priority ASC
  """), {"city_id": city_id, "item_id": item_id}).fetchall()
  return [{"code": r[0], "label": _t(db, r[1], lang)} for r in rows]


def _load_city_disposals(db: Session, city_id: str, item_id: str, lang: str) -> List[Dict[str, Any]]:
  rows = db.execute(text("""
    SELECT d.code, d.name_key
    FROM core.item_city_disposal icd
    JOIN core.disposal_method d ON d.disposal_id = icd.disposal_id
    WHERE icd.city_id = :city_id AND icd.item_id::uuid = :item_id
    ORDER BY icd.priority ASC
  """), {"city_id": city_id, "item_id": item_id}).fetchall()
  return [{"code": r[0], "label": _t(db, r[1], lang)} for r in rows]


def _enrich_suggestions(db: Session, suggestions: List[Dict[str, Any]], city_id: str, city_code: str, lang: str) -> List[Dict[str, Any]]:
  enriched = []
  for s in suggestions:
    cats = _load_city_categories(db, city_id, s["item_id"], lang)
    disps = _load_city_disposals(db, city_id, s["item_id"], lang)
    enriched.append({
      **s,
      "categories": cats,
      "disposals": disps,
      "link": f"/resolve?city={city_code}&item_id={s['item_id']}&lang={lang}"
    })
  return enriched


def _city_rules_exist(db: Session, city_id: str, item_id: str) -> bool:
  has_cat = db.execute(
    text(
      """
      SELECT 1 FROM core.item_city_category
      WHERE city_id = :city_id AND item_id::uuid = :item_id
      LIMIT 1
      """
    ),
    {"city_id": city_id, "item_id": item_id},
  ).fetchone()
  if has_cat:
    return True
  has_disp = db.execute(
    text(
      """
      SELECT 1 FROM core.item_city_disposal
      WHERE city_id = :city_id AND item_id::uuid = :item_id
      LIMIT 1
      """
    ),
    {"city_id": city_id, "item_id": item_id},
  ).fetchone()
  return bool(has_disp)


def _create_missing_city_prospects(db: Session, item_id: str, lang: str, exclude_city_id: str, exclude_city_code: str) -> List[Dict[str, Any]]:
  missing = []
  cities = db.execute(
    text("SELECT city_id::text, code FROM core.city WHERE city_id <> :cid"),
    {"cid": exclude_city_id},
  ).fetchall()
  for cid, code in cities:
    if not _city_rules_exist(db, cid, item_id):
      created = _create_prospect(db, item_id, cid, lang, reason="missing_city_rules_other_city", search_text=None)
      missing.append({"city": code, "needed": True, "created": created})
  return missing


def resolve_item(db: Session, city_code: str, item_id: Optional[str], lang: str, item_name: Optional[str] = None) -> Dict[str, Any]:
  city_id = _city_id(db, city_code)
  if not city_id:
    return {"error": f"unknown city: {city_code}"}

  if not item_id and not item_name:
    return {"error": "item_id or item_name is required"}

  # If only name is provided, try to find the closest item_id in this city (or global)
  if not item_id and item_name:
    found_id = _find_item_by_alias(db, item_name, lang, city_id)
    if not found_id:
      found_id = _find_item_by_name(db, item_name, lang, city_id)
    if not found_id:
      suggestions = _enrich_suggestions(
        db,
        _suggest_similar(db, item_name, lang, city_id, exclude_item_id=None, limit=3),
        city_id,
        city_code,
        lang,
      )
      created = _create_prospect(db, None, city_id, lang, reason="unknown_item", search_text=item_name)
      return {"not_found": True, "suggestions": suggestions, "error": "unknown item", "prospect": {"created": created, "needed": True}}
    item_id = found_id

  # get base item keys
  item = db.execute(text("""
    SELECT item_id::text, canonical_key, title_key, desc_key, primary_image_id::text
    FROM core.item
    WHERE item_id::uuid = :item_id
  """), {"item_id": item_id}).fetchone()

  if not item:
    suggestions = _suggest_similar(db, item_name or item_id, lang, city_id, exclude_item_id=None, limit=3)
    return {"not_found": True, "suggestions": suggestions}

  title_key = item[2]
  desc_key = item[3]
  image_id = item[4]

  # text override: city only
  r = db.execute(text("""
    SELECT o.title_key, o.desc_key
    FROM core.item_city_text_override o
    WHERE o.city_id = :city_id AND o.item_id::uuid = :item_id
  """), {"city_id": city_id, "item_id": item_id}).fetchone()
  if r:
    if r[0]: title_key = r[0]
    if r[1]: desc_key = r[1]

  title = _t(db, title_key, lang)
  desc = _t(db, desc_key, lang) if desc_key else None

  # disposal(s): city only, no base fallback
  rows = db.execute(text("""
    SELECT d.code, d.name_key
    FROM core.item_city_disposal icd
    JOIN core.disposal_method d ON d.disposal_id = icd.disposal_id
    WHERE icd.city_id = :city_id AND icd.item_id::uuid = :item_id
    ORDER BY icd.priority ASC
  """), {"city_id": city_id, "item_id": item_id}).fetchall()
  disposals = [{"code": r[0], "label": _t(db, r[1], lang)} for r in rows]

  # categories: city only
  rows = db.execute(text("""
    SELECT cat.code, cat.name_key
    FROM core.item_city_category icc
    JOIN core.category cat ON cat.category_id = icc.category_id
    WHERE icc.city_id = :city_id AND icc.item_id::uuid = :item_id
    ORDER BY icc.priority ASC
  """), {"city_id": city_id, "item_id": item_id}).fetchall()
  categories = [{"code": r[0], "label": _t(db, r[1], lang)} for r in rows]

  missing_rules = not categories and not disposals

  # Suggestions via trigram similarity on aliases (semantic-ish)
  suggestions = []
  prospect_created = False
  missing_other_cities: List[Dict[str, Any]] = []
  if missing_rules:
    title_text = title or item[1]
    suggestions = _enrich_suggestions(
      db,
      _suggest_similar(db, title_text, lang, city_id, exclude_item_id=item[0], limit=3),
      city_id,
      city_code,
      lang,
    )
    prospect_created = _create_prospect(
      db,
      item_id=item[0],
      city_id=city_id,
      lang=lang,
      reason="missing_city_rules",
      search_text=None,
    )
  else:
    # item exists with rules in requested city; check other cities and create prospects there if missing
    missing_other_cities = _create_missing_city_prospects(db, item_id=item[0], lang=lang, exclude_city_id=city_id, exclude_city_code=city_code)

  image_url = f"/images/{image_id}" if image_id else None
  return {
    "city": city_code,
    "item": {
      "id": item[0],
      "canonical_key": item[1],
      "title": title,
      "description": desc,
      "image_id": image_id,
      "image_url": image_url,
    },
    "categories": categories,
    "disposals": disposals,
    "suggestions": suggestions,
    "prospect": {"created": prospect_created, "needed": missing_rules, "missing_cities": missing_other_cities}
  }
