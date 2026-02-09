import json
from pathlib import Path

import pandas as pd


def _clean_text(value: str | None) -> str:
    if value is None:
        return ""
    text = str(value).replace("\r\n", " ").replace("\n", " ").strip()
    return " ".join(text.split())


def _to_bool(value: object) -> bool | None:
    if value is None:
        return None
    return bool(value)


source_path = Path("data/hannover_addresses.json")
with source_path.open("r", encoding="utf-8") as f:
    data = json.load(f)

rows: list[dict[str, object]] = []
typ_labels = {
    1: "Wertstoffhöfe",
    2: "Deponien und angeschlossene Wertstoffhöfe",
    3: "Grüngutannahmestelle",
    5: "Wertstoffinsel",
    None: "NA",
}
for item in data:
    typ_raw = item.get("typ")
    try:
        typ = int(typ_raw) if typ_raw is not None else None
    except (TypeError, ValueError):
        typ = None

    name = _clean_text(item.get("name"))
    strasse = _clean_text(item.get("strasse"))
    nummer = _clean_text(item.get("nummer"))
    plz = _clean_text(item.get("plz"))
    ort = _clean_text(item.get("ort"))

    address = f"{strasse} {nummer}, {plz} {ort}"
    address = " ".join(address.split()).strip(" ,")

    lat = item.get("breitengrad")
    lng = item.get("laengengrad")

    wertstoffinsel = item.get("wertstoffinsel") or {}
    rows.append(
        {
            "typ": typ,
            "typ_label": typ_labels.get(typ, "NA"),
            "name": name,
            "address": address,
            "lat": lat,
            "lng": lng,
            "wertstoffinsel_glas": _to_bool(wertstoffinsel.get("glas")),
            "wertstoffinsel_kleider": _to_bool(wertstoffinsel.get("kleider")),
            "wertstoffinsel_papier": _to_bool(wertstoffinsel.get("papier")),
        }
    )

df = pd.DataFrame(rows)
df["google_maps_url"] = df.apply(
    lambda r: f"https://www.google.com/maps?q={r['lat']},{r['lng']}", axis=1
)

out_path = Path("data/aha_locations.csv")
df[
    [
        "typ",
        "typ_label",
        "name",
        "address",
        "lat",
        "lng",
        "wertstoffinsel_glas",
        "wertstoffinsel_kleider",
        "wertstoffinsel_papier",
        "google_maps_url",
    ]
].to_csv(out_path, index=False, encoding="utf-8")
print(f"OK -> {out_path}")
