# Easy Recycle – Codex Instructions (AGENTS.md)

## Goal
Build an AI-native recycling assistant:
- Input: item photo + city (+ optional user context)
- Output: actions (recycle/repair/donate/resell), disposal method(s), warnings, locations
- Key constraint: city rules are independent (no fallback); each city has its own rule set.

## Source of truth
- Database schema: /sql/schema.sql
- Docs: /docs/*
- Import pipeline: /scripts/import_csv.py

## Data model principles
1) No deleting duplicates: use canonical items (never hard-delete duplicates from source).
2) i18n: NEVER store de/en/tr columns in domain tables.
   - Store translation keys in domain tables, text in i18n_translation.
3) City logic:
   - No runtime fallback between cities. A city only returns its own records; missing data stays empty/unknown.
   - Prospect flow: when an item is requested but missing for a city, persist a “prospect” entry for that city (per canonical item) to be enriched later.
   - Enrichment (AI/semantic): generate city-specific category/disposal/warnings/text and write only to that city’s item_city_* rows; do not alter other cities.
   - If city rules are missing, return suggestions (similar items) to the user and mark prospect created; admin-only flow handles approval/edits.
   - Prospect rules:
     * item not found -> prospect with search_text per city, plus 3 suggestions
     * item found but city has no rules -> prospect for that city (unique), plus 3 suggestions
     * item found and city has rules -> no prospect
4) Canonical taxonomy:
   - category.code and disposal_method.code are stable identifiers.
5) Keep API responses small JSON (UI templates in client).

## Coding conventions
- Python 3.11+, FastAPI
- SQLAlchemy 2.0 style
- Prefer explicit SQL for resolver logic where clearer.
- Always add/update tests when implementing non-trivial logic.

## Run locally
- docker compose up -d
- export DATABASE_URL="postgresql+psycopg://postgres:postgres@localhost:5432/easy_recycle"
- alembic upgrade head
- uvicorn app.main:app --reload --port 8000

## Acceptance criteria for tasks
- Migrations apply cleanly
- Import scripts are idempotent (safe to re-run)
- City fallback logic has tests (base + override case)
