"""Build Berlin recycle-center CSV from berlin_recyclehof.json.

Usage:
  python scripts/build_berlin_recycle_center.py
  python scripts/build_berlin_recycle_center.py --json data/berlin_recyclehof.json --out data/berlin_recyclehof.csv
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

import pandas as pd


def _extract_value(payload: Any) -> Any:
    """Extract [type, value] pairs used by source JSON."""
    if isinstance(payload, list) and len(payload) >= 2:
        return payload[1]
    return payload


def _try_fix_mojibake(text: str) -> str:
    if "\u00c3" not in text and "\u00c2" not in text:
        return text
    try:
        return text.encode("cp1252").decode("utf-8")
    except UnicodeError:
        return text


def _clean_text(value: Any) -> str:
    if value is None:
        return ""
    text = str(value).replace("\r\n", " ").replace("\n", " ").strip()
    text = " ".join(text.split())
    return _try_fix_mojibake(text)


def _to_float(value: Any) -> float | None:
    if value is None:
        return None
    try:
        return float(str(value))
    except (TypeError, ValueError):
        return None


def _to_disposal_positive(values: Any) -> list[str]:
    if not isinstance(values, list):
        return []
    result: list[str] = []
    seen: set[str] = set()
    for value in values:
        label = _clean_text(value)
        if not label:
            continue
        if label in seen:
            continue
        seen.add(label)
        result.append(label)
    return result


def _derive_type_label(returnable_materials: str) -> tuple[int, str]:
    normalized = returnable_materials.lower()
    if "schadstoffe" in normalized and "gebrauchtwaren" in normalized:
        return 4, "Recyclinghof Plus (Schadstoffe + Gebrauchtwaren)"
    if "schadstoffe" in normalized:
        return 2, "Recyclinghof mit Schadstoff-Annahme"
    if "gebrauchtwaren" in normalized:
        return 3, "Recyclinghof Plus (Gebrauchtwaren)"
    return 1, "Recyclinghof"


def build_rows(payload: dict[str, Any]) -> list[dict[str, Any]]:
    objs = payload.get("objs") if isinstance(payload, dict) else None
    if not isinstance(objs, list):
        return []

    rows: list[dict[str, Any]] = []
    for obj in objs:
        if not isinstance(obj, dict):
            continue
        if _clean_text(_extract_value(obj.get("_obj_class"))) != "Recyclinghof":
            continue

        lat = _to_float(_extract_value(obj.get("geo_lat_directions")))
        if lat is None:
            lat = _to_float(_extract_value(obj.get("geo_lat")))
        lng = _to_float(_extract_value(obj.get("geo_long_directions")))
        if lng is None:
            lng = _to_float(_extract_value(obj.get("geo_long")))
        if lat is None or lng is None:
            continue

        title = _clean_text(_extract_value(obj.get("content_title")))
        if not title:
            title = _clean_text(_extract_value(obj.get("title")))
        street = _clean_text(_extract_value(obj.get("address_street")))
        zipcode = _clean_text(_extract_value(obj.get("address_zip")))
        district = _clean_text(_extract_value(obj.get("address_district")))

        address_tail = " ".join(part for part in [zipcode, district] if part)
        address = ", ".join(part for part in [street, address_tail] if part).strip(" ,")
        if not address:
            address = title

        returnable_materials = _clean_text(_extract_value(obj.get("returnable_materials")))
        typ_code, typ_label = _derive_type_label(returnable_materials)
        disposal_positive = _to_disposal_positive(
            _extract_value(obj.get("disposal_positive"))
        )

        rows.append(
            {
                "external_id": _clean_text(_extract_value(obj.get("hof_i_d"))) or None,
                "typ_code": typ_code,
                "typ_label": typ_label,
                "name": title,
                "address": address,
                "lat": lat,
                "lng": lng,
                "disposal_positive": json.dumps(disposal_positive, ensure_ascii=False),
                "wertstoffinsel_glas": None,
                "wertstoffinsel_kleider": None,
                "wertstoffinsel_papier": None,
                "google_maps_url": f"https://www.google.com/maps?q={lat},{lng}",
            }
        )
    return rows


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json", default="data/berlin_recyclehof.json", help="Input JSON path")
    parser.add_argument("--out", default="data/berlin_recyclehof.csv", help="Output CSV path")
    args = parser.parse_args()

    source_path = Path(args.json)
    out_path = Path(args.out)
    with source_path.open("r", encoding="utf-8") as f:
        payload = json.load(f)

    rows = build_rows(payload)
    if not rows:
        raise SystemExit("No valid rows found in source JSON.")

    df = pd.DataFrame(rows)
    df[
        [
            "external_id",
            "typ_code",
            "typ_label",
            "name",
            "address",
            "lat",
            "lng",
            "disposal_positive",
            "wertstoffinsel_glas",
            "wertstoffinsel_kleider",
            "wertstoffinsel_papier",
            "google_maps_url",
        ]
    ].to_csv(out_path, index=False, encoding="utf-8")
    print(f"OK -> {out_path} ({len(df)} rows)")


if __name__ == "__main__":
    main()
