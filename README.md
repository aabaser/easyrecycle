# Easy Recycle

Project documentation lives in `/docs`.

Recommended starting points:
- `docs/00_overview.md`
- `docs/50_architecture.md`
- `docs/60_flutter_requirements.md`
- `docs/90_runbook.md`

## Codex
Codex reads `AGENTS.md` first. Keep it updated when rules change.

## Quick Start

### Backend (Postgres + FastAPI)
```bash
docker compose up -d
export DATABASE_URL="postgresql+psycopg://postgres:postgres@localhost:5432/easy_recycle"
alembic upgrade head
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

Optional env (Vision):
```bash
export OPENAI_API_KEY="..."
```

Health check:
```
http://<PC_IP>:8000/health
```

### Flutter (Web)
```bash
flutter pub get
flutter gen-l10n
flutter run -d chrome --dart-define=API_BASE_URL=http://<PC_IP>:8000
flutter run -d chrome --dart-define=API_BASE_URL=http://192.168.2.177:8000
```

### Flutter (Android APK)
Prereqs:
- Java 17+
- Android SDK configured (ANDROID_SDK_ROOT)

Build:
```bash
flutter build apk --dart-define=API_BASE_URL=http://<PC_IP>:8000
```

Install APK:
```bash
flutter install
```

## Data Import (CSV only)

The importer supports **CSV only**. Use the Hannover CSV export as the base dataset; Berlin overrides
are not part of this CSV import.

Import:
```bash
python scripts/import_csv.py data/aha_abc_new_05_01_2026_12.csv
```

Full reset + re-import (Hannover + Berlin wiped):
```bash
python scripts/import_csv.py data/aha_abc_new_05_01_2026_12.csv --full-reset
```

Dry-run:
```bash
python scripts/import_csv.py data/aha_abc_new_05_01_2026_12.csv --dry-run
```

Berlin JSON import:
```bash
python scripts/import_berlin_json.py data/berlin_abfall.json
```

## Item Alias Seed (DB → CSV → Import)

Build alias seed CSV directly from DB:
```bash
python scripts/build_item_alias_seed.py --database-url "$DATABASE_URL" \
  --out item_alias_seed.csv \
  --collisions item_alias_collisions.csv
```

Import alias seed CSV into `core.item_alias`:
```bash
python scripts/import_item_alias_seed.py --database-url "$DATABASE_URL" --csv item_alias_seed.csv
```
Note: `import_item_alias_seed.py` uses psycopg directly and expects a DSN like
`postgresql://...` (not `postgresql+psycopg://...`). If your `DATABASE_URL`
uses the SQLAlchemy format, replace `postgresql+psycopg://` with `postgresql://`
for this script.

## Auth (Local)

Env setup:
```bash
cp .env.example .env
```

Guest token:
```bash
curl -X POST http://localhost:8000/auth/guest \
  -H "Content-Type: application/json" \
  -d '{"device_id":"device_12345678","attestation":"TODO"}'
```

Me:
```bash
curl http://localhost:8000/auth/me \
  -H "Authorization: Bearer <GUEST_JWT>"
```

Verify:
```bash
curl -X POST http://localhost:8000/auth/verify \
  -H "Authorization: Bearer <JWT>"
```

Enable Cognito (no live test required):
```bash
export COGNITO_ENABLED=true
export COGNITO_REGION=eu-central-1
export COGNITO_USER_POOL_ID=eu-central-1_XXXXXXXXX
export COGNITO_APP_CLIENT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxx
# Optional:
# export COGNITO_ISSUER=https://cognito-idp.eu-central-1.amazonaws.com/eu-central-1_XXXXXXXXX
```
