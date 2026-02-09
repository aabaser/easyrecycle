"""
Import recycle centers CSV into Postgres.

Usage:
  python scripts/import_recycle_centers.py --city hannover --csv data/aha_locations.csv
  python scripts/import_recycle_centers.py --city hannover --csv data/aha_locations.csv --replace
"""
from __future__ import annotations

import argparse
import os
from typing import Any

import pandas as pd
from sqlalchemy import create_engine, text


def _get_database_url(value: str | None) -> str:
    url = value or os.getenv("DATABASE_URL")
    if not url:
        raise SystemExit("DATABASE_URL is required (or pass --database-url)")
    return url


def _to_int(value: Any) -> int | None:
    if value is None or (isinstance(value, float) and pd.isna(value)):
        return None
    try:
        return int(float(value))
    except (TypeError, ValueError):
        return None


def _to_float(value: Any) -> float | None:
    if value is None or (isinstance(value, float) and pd.isna(value)):
        return None
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def _to_bool(value: Any) -> bool | None:
    if value is None or (isinstance(value, float) and pd.isna(value)):
        return None
    if isinstance(value, str):
        lowered = value.strip().lower()
        if lowered in {"true", "1", "yes", "y"}:
            return True
        if lowered in {"false", "0", "no", "n", ""}:
            return False
    return bool(value)


def _get_city_id(conn, code: str) -> str:
    row = conn.execute(
        text("SELECT city_id::text FROM core.city WHERE code = :code"),
        {"code": code},
    ).fetchone()
    if not row:
        raise SystemExit(f"Unknown city code: {code}")
    return row[0]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--city", required=True, help="City code, e.g. hannover")
    parser.add_argument("--csv", required=True, help="CSV path, e.g. data/aha_locations.csv")
    parser.add_argument("--database-url", help="Database URL (defaults to DATABASE_URL env)")
    parser.add_argument("--replace", action="store_true", help="Delete existing centers for city")
    parser.add_argument("--source", default="import", help="Source label for rows")
    args = parser.parse_args()

    database_url = _get_database_url(args.database_url)
    df = pd.read_csv(args.csv)

    typ_col = "typ_code" if "typ_code" in df.columns else "typ"
    external_id_col = "external_id" if "external_id" in df.columns else None

    rows: list[dict[str, Any]] = []
    for _, row in df.iterrows():
        lat = _to_float(row.get("lat"))
        lng = _to_float(row.get("lng"))
        if lat is None or lng is None:
            continue
        rows.append(
            {
                "city_id": None,  # fill later
                "source": args.source,
                "external_id": row.get(external_id_col) if external_id_col else None,
                "name": str(row.get("name") or "").strip(),
                "address": str(row.get("address") or "").strip(),
                "lat": lat,
                "lng": lng,
                "typ_code": _to_int(row.get(typ_col)),
                "typ_label": str(row.get("typ_label") or "").strip() or None,
                "has_glas": _to_bool(row.get("wertstoffinsel_glas")),
                "has_kleider": _to_bool(row.get("wertstoffinsel_kleider")),
                "has_papier": _to_bool(row.get("wertstoffinsel_papier")),
            }
        )

    if not rows:
        raise SystemExit("No rows to import (check CSV contents).")

    engine = create_engine(database_url)
    with engine.begin() as conn:
        city_id = _get_city_id(conn, args.city)
        for row in rows:
            row["city_id"] = city_id

        if args.replace:
            conn.execute(
                text("DELETE FROM core.recycle_center WHERE city_id = :city_id"),
                {"city_id": city_id},
            )

        conn.execute(
            text(
                """
                INSERT INTO core.recycle_center (
                  city_id,
                  source,
                  external_id,
                  name,
                  address,
                  lat,
                  lng,
                  typ_code,
                  typ_label,
                  has_glas,
                  has_kleider,
                  has_papier
                )
                VALUES (
                  :city_id,
                  :source,
                  :external_id,
                  :name,
                  :address,
                  :lat,
                  :lng,
                  :typ_code,
                  :typ_label,
                  :has_glas,
                  :has_kleider,
                  :has_papier
                )
                """
            ),
            rows,
        )

    print(f"Imported {len(rows)} recycle centers for city={args.city}")


if __name__ == "__main__":
    main()
