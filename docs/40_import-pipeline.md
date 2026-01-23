# Import pipeline

Current source:
- CSV `data/aha_abc_new_05_01_2026_12.csv` (Hannover defaults)
- Future Excel override sheets can be added per city, but there is no runtime fallback.

Import rules:
1) All rows create/update canonical `core.item`.
2) Translations -> core.i18n_translation (currently only `de` loaded; other langs later).
3) City data is written per city (`core.item_city_*`). Cities are independent; missing city rules remain empty.
4) When a city lacks rules at runtime, `/resolve` creates a prospect for admin enrichment instead of falling back.

Scripts:
- scripts/import_csv.py : load CSV/Excel -> canonical tables + item_city_* for given city sheets
