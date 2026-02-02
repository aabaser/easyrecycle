# Import pipeline

Current source:
- CSV `data/aha_abc_new_05_01_2026_12.csv` (Hannover defaults)
- Excel overrides are removed for now; importer is CSV-only.

Import rules:
1) All rows create/update canonical `core.item`.
2) Translations -> core.i18n_translation (currently only `de` loaded; other langs later).
3) City data is written per city (`core.item_city_*`). Cities are independent; missing city rules remain empty.
4) When a city lacks rules at runtime, `/resolve` creates a prospect for admin enrichment instead of falling back.
5) Slug generation:
   - German transliteration: ä->ae, ö->oe, ü->ue, ß->ss
   - Collisions are resolved with suffixes: `-2`, `-3`, ...

Scripts:
- scripts/import_csv.py : load CSV -> canonical tables + item_city_* (Hannover base; Berlin overrides not included in CSV)
- scripts/import_berlin_json.py : load Berlin JSON overrides (city=berlin), uses same slug normalization and collision suffixes

Usage:
```bash
python scripts/import_csv.py data/aha_abc_new_05_01_2026_12.csv
```

Full reset + re-import (Hannover + Berlin wiped):
```bash
python scripts/import_csv.py data/aha_abc_new_05_01_2026_12.csv --full-reset
```

Notes:
- `--full-reset` truncates all core data tables (including Berlin overrides, i18n translations, and item_city_*).
- Use `--dry-run` to validate the CSV shape before importing.

Dry-run:
```bash
python scripts/import_csv.py data/aha_abc_new_05_01_2026_12.csv --dry-run
```

Berlin JSON import:
```bash
python scripts/import_berlin_json.py data/berlin_abfall.json
```
