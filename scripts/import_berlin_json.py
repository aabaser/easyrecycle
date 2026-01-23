"""
Import Berlin waste data from data/berlin_abfall.json into city-scoped tables.

Mapping (best-effort):
- synonymTitle            -> item title (de)
- fractionTitle           -> category (city=berlin)
- synonymDisposalPositive -> disposals (city=berlin)
- widgetsText             -> description (concatenated HTML/text, de)

Notes:
- Creates/updates canonical items (slug of synonymTitle) with external_document_id = json id.
- Only "de" translations are written (others empty by design).
- City fallback is not used; this writes only Berlin city rows.

Usage:
  python scripts/import_berlin_json.py data/berlin_abfall.json
"""
from __future__ import annotations

import argparse
import json
import os
import re
from typing import Any, Dict, List, Optional

from sqlalchemy import create_engine, text
from sqlalchemy.engine import Connection

LANG = "de"
CITY_CODE = "berlin"


def slug(value: str) -> str:
  value = (value or "").strip().lower()
  value = re.sub(r"[^a-z0-9]+", "_", value).strip("_")
  return value or "item"


def upsert_translation(conn: Connection, key: str, text_value: str) -> None:
  conn.execute(
    text(
      """
      INSERT INTO core.i18n_translation(key, lang, text)
      VALUES (:key, :lang, :text)
      ON CONFLICT (key, lang)
      DO UPDATE SET text = EXCLUDED.text, updated_at = now()
      """
    ),
    {"key": key, "lang": LANG, "text": text_value},
  )


def ensure_city(conn: Connection, code: str) -> str:
  name_key = f"city.{code}.name"
  upsert_translation(conn, name_key, code.capitalize())
  res = conn.execute(
    text(
      """
      INSERT INTO core.city(code, name_key)
      VALUES (:code, :name_key)
      ON CONFLICT (code)
      DO UPDATE SET name_key = EXCLUDED.name_key,
                    updated_at = now()
      RETURNING city_id::text
      """
    ),
    {"code": code, "name_key": name_key},
  )
  return res.scalar_one()


def ensure_category(conn: Connection, label: str) -> str:
  code = slug(label)
  name_key = f"category.{code}.name"
  upsert_translation(conn, name_key, label)
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
  upsert_translation(conn, name_key, label)
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


def upsert_item(conn: Connection, canonical_key: str, title_key: str, desc_key: Optional[str], source_id: Optional[str]) -> str:
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
      "source": "berlin_json",
      "external_document_id": source_id,
    },
  )
  return res.scalar_one()


def upsert_city_category(conn: Connection, city_id: str, item_id: str, category_id: str, priority: int) -> None:
  conn.execute(
    text(
      """
      INSERT INTO core.item_city_category (city_id, item_id, category_id, priority)
      VALUES (:city_id, :item_id, :category_id, :priority)
      ON CONFLICT (city_id, item_id, category_id)
      DO UPDATE SET priority = EXCLUDED.priority
      """
    ),
    {"city_id": city_id, "item_id": item_id, "category_id": category_id, "priority": priority},
  )


def upsert_city_disposal(conn: Connection, city_id: str, item_id: str, disposal_id: str, priority: int) -> None:
  conn.execute(
    text(
      """
      INSERT INTO core.item_city_disposal (city_id, item_id, disposal_id, priority)
      VALUES (:city_id, :item_id, :disposal_id, :priority)
      ON CONFLICT (city_id, item_id, disposal_id)
      DO UPDATE SET priority = EXCLUDED.priority
      """
    ),
    {"city_id": city_id, "item_id": item_id, "disposal_id": disposal_id, "priority": priority},
  )


def upsert_text_override(conn: Connection, city_id: str, item_id: str, desc_key: Optional[str]) -> None:
  if not desc_key:
    return
  conn.execute(
    text(
      """
      INSERT INTO core.item_city_text_override (city_id, item_id, desc_key)
      VALUES (:city_id, :item_id, :desc_key)
      ON CONFLICT (city_id, item_id)
      DO UPDATE SET desc_key = EXCLUDED.desc_key
      """
    ),
    {"city_id": city_id, "item_id": item_id, "desc_key": desc_key},
  )


def build_desc(entry: Dict[str, Any]) -> Optional[str]:
  parts = []
  for section in entry.get("widgetsText", []):
    if isinstance(section, list) and len(section) == 2:
      label = str(section[0] or "").strip()
      body = str(section[1] or "").strip()
      if not body:
        continue
      if label:
        parts.append(f"{label}: {body}")
      else:
        parts.append(body)
  text_val = "\n\n".join(parts).strip()
  if text_val.startswith(":"):
    text_val = text_val.lstrip(": ").strip()
  return text_val or None


def main() -> None:
  parser = argparse.ArgumentParser()
  parser.add_argument("json_path", help="Path to berlin_abfall.json")
  parser.add_argument("--database-url", default=os.getenv("DATABASE_URL"))
  parser.add_argument("--dry-run", action="store_true", help="Preview only")
  args = parser.parse_args()

  if not args.database_url and not args.dry_run:
    raise SystemExit("DATABASE_URL not set. Example: postgresql+psycopg://postgres:postgres@localhost:5432/easy_recycle")

  with open(args.json_path, "r", encoding="utf-8") as f:
    data = json.load(f)
  if not isinstance(data, list):
    raise SystemExit("Expected a JSON array")

  print(f"Loaded {len(data)} records from {args.json_path}")
  if args.dry_run:
    print(json.dumps(data[:3], ensure_ascii=False, indent=2))
    return

  engine = create_engine(args.database_url)
  with engine.begin() as conn:
    city_id = ensure_city(conn, CITY_CODE)
    items = 0
    for entry in data:
      title = entry.get("synonymTitle")
      if not title:
        continue
      canonical_key = slug(title)
      title_key = f"item.{canonical_key}.title"
      desc_val = build_desc(entry)
      desc_key = f"item.{canonical_key}.desc.berlin" if desc_val else None

      upsert_translation(conn, title_key, title)
      if desc_key and desc_val:
        upsert_translation(conn, desc_key, desc_val)

      item_id = upsert_item(conn, canonical_key, title_key, desc_key, entry.get("id"))

      # category
      cat_label = entry.get("fractionTitle") or "unbekannt"
      cat_id = ensure_category(conn, cat_label)
      upsert_city_category(conn, city_id, item_id, cat_id, priority=1)

      # disposals
      disposals = entry.get("synonymDisposalPositive") or []
      for priority, disp_label in enumerate(disposals, start=1):
        disp_id = ensure_disposal(conn, disp_label)
        upsert_city_disposal(conn, city_id, item_id, disp_id, priority)

      # city desc override
      upsert_text_override(conn, city_id, item_id, desc_key)
      items += 1

    print(f"Imported/updated items: {items}")


if __name__ == "__main__":
  main()
