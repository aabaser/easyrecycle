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
