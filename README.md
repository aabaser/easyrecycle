# Easy Recycle

Project documentation lives in `/docs`.

Recommended starting points:
- `docs/00_overview.md`
- `docs/50_architecture.md`
- `docs/60_flutter_requirements.md`
- `docs/90_runbook.md`

## Codex
Codex reads `AGENTS.md` first. Keep it updated when rules change.

## Project Rule - Admin Archive

Admin features are not part of the active app or API anymore.

- Keep admin code only in the local `admin_next_project/` archive.
- `admin_next_project/` is gitignored and must not be deployed.
- If admin returns, move it into a separate project/repo.

## Project Rule - Language UI (Temporary)

For now, the app UI is German-only.

- Keep English/Turkish localization files and keys in the codebase.
- Do not delete EN/TR translations or locale support code.
- EN/TR may be hidden from UI selectors (Landing, Settings, pickers), but must remain reactivatable.

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

Production hardening (recommended):
```bash
export APP_ENV=production
export API_DOCS_ENABLED=false
export CORS_ALLOW_ORIGINS="https://your-frontend.example"
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
flutter build apk --dart-define=API_BASE_URL=http://192.168.2.177:8000
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

Hannover recycling centers (AHA addresses):
```bash
curl.exe -L "https://www.aha-region.de/app-fileadmin/annahmestellen/addresses.json" -o "data/hannover_addresses.json"
```
Build the CSV:
```bash
python scripts/build_hannover_recycle_center.py
```
Import into Postgres:
```bash
python scripts/import_recycle_centers.py --city hannover --csv data/aha_locations.csv --replace
```

## Item Alias Seed (DB → CSV → Import)

Build alias seed CSV directly from DB:
```bash
python scripts/build_item_alias_seed.py --database-url "$DATABASE_URL" \
  --out data/item_alias_seed.csv \
  --collisions data/item_alias_collisions.csv
```

Import alias seed CSV into `core.item_alias`:
```bash
python scripts/import_item_alias_seed.py --database-url "$DATABASE_URL" --csv data/item_alias_seed.csv
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

## Image Storage (S3)

Set env vars (local dev):
```bash
export AWS_REGION=eu-central-1
export S3_BUCKET_NAME=easy-recycle-images-dev
export S3_PRESIGN_TTL_SECONDS=120
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
```

Presign upload (guest/user auth required):
```bash
curl -X POST http://localhost:8000/uploads/presign \
  -H "Authorization: Bearer <JWT>" \
  -H "Content-Type: application/json" \
  -d '{"content_type":"image/jpeg","file_ext":"jpg"}'
```

Upload to S3:
```bash
curl -X PUT "<upload_url>" \
  -H "Content-Type: image/jpeg" \
  --data-binary @/path/to/image.jpg
```

Analyze with s3_key:
```bash
curl -X POST http://localhost:8000/analyze \
  -H "Authorization: Bearer <JWT>" \
  -H "Content-Type: application/json" \
  -d '{"city":"hannover","lang":"de","s3_key":"guest/<device_id>/2026/02/xxxx.jpg"}'
```

Analyze with multipart upload:
```bash
curl -X POST http://localhost:8000/analyze \
  -H "Authorization: Bearer <JWT>" \
  -F "city=hannover" \
  -F "lang=de" \
  -F "file=@/path/to/image.jpg"
```

## Recycle Centers API

List recycle centers for a city (type_code=5 is filtered out):
```bash
curl -H "Authorization: Bearer <JWT>" \
  "http://localhost:8000/recycle-centers?city=hannover"
```

List nearest centers (requires location):
```bash
curl -H "Authorization: Bearer <JWT>" \
  "http://localhost:8000/recycle-centers?city=hannover&lat=52.37&lng=9.73&limit=20"
```

## Website Landing Page (Static + Formspree)

The static landing page lives in `site/` and can be deployed as a Render Static Site.

Run locally (from repo root):
```bash
python -m http.server 8080 --directory site
```

## Render (Backend API)

The repo includes a starter Blueprint file at `render.yaml` for the FastAPI backend and a managed
Render Postgres database.

High-level flow:
1. Push the repo with `render.yaml`.
2. In Render, create a new Blueprint and select the repo.
3. Confirm the `easy-recycle-db` database and `easy-recycle-api` web service.
4. Fill the prompted secret env vars:
   - `CORS_ALLOW_ORIGINS`
   - `AWS_REGION`
   - `S3_BUCKET_NAME`
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `OPENAI_API_KEY` (optional if you want live vision calls)
5. Deploy and wait for `/health` to return `{"ok": true}`.

Notes:
- `startCommand` runs `alembic upgrade head` before starting Uvicorn.
- `DATABASE_URL` from Render Postgres is normalized in code to work with SQLAlchemy + psycopg.
- Without the AWS/S3 vars, startup validation currently fails by design.

Open:
```text
http://localhost:8080
```

Waitlist/contact form is currently wired to **Formspree** (no FastAPI required).
Endpoint is configured in `site/index.html`:

```html
<meta name="formspree-endpoint" content="https://formspree.io/f/xpqjqgra" />
```

Form fields:
- `email` (required)
- `name` (optional)
- `message` (optional)
