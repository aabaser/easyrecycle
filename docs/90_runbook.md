# Runbook (Local)

## Backend
1) Start Postgres
```bash
docker compose up -d
```

2) Create venv and install
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

3) Run migrations
```bash
export DATABASE_URL="postgresql+psycopg://postgres:postgres@localhost:5432/easy_recycle"
alembic upgrade head
```
Note: `alembic upgrade head` also creates `core.vision_cache` (migration `0004_vision_cache`).

4) Seed example data
```bash
psql "postgresql://postgres:postgres@localhost:5432/easy_recycle" -f sql/seed_example.sql
```

5) Run API
Create a `.env` file (see `.env.example`) and set:
```
OPENAI_API_KEY="your_api_key_here"
```
Then run:
```bash
uvicorn app.main:app --reload --port 8000
```

Open:
- http://localhost:8000/docs
- /health
- /resolve?city=hannover&item_id=<UUID>&lang=de

## Flutter (Web + Android)
1) Enable web support (one-time)
```bash
flutter create .
```

2) Install Flutter deps
```bash
flutter pub get
```

3) Run on web
```bash
flutter run -d chrome
```

4) Run on Android
```bash
flutter run -d android
```

Notes:
- Scan page calls `http://localhost:8000/resolve` for text search.
- Photo flow calls `http://localhost:8000/analyze`.
- Keep the API running locally while testing Flutter.

## Vision cache
- Image is normalized (resize + JPEG).
- SHA256 of normalized bytes + model name -> `cache_key`.
- If `core.vision_cache` contains this key, the result is returned without calling OpenAI.
