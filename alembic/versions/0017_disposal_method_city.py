"""add city and recycle center type to disposal methods

Revision ID: 0017_disposal_method_city
Revises: 0016_auth_identity_link
Create Date: 2026-03-24
"""

from __future__ import annotations

from alembic import op
from sqlalchemy import text

# revision identifiers, used by Alembic.
revision = "0017_disposal_method_city"
down_revision = "0016_auth_identity_link"
branch_labels = None
depends_on = None


SEEDS = (
  {"city_code": "berlin", "code": "biogut_tonne", "label": "Biogut-Tonne", "typ_label": None, "typ_code": None},
  {"city_code": "berlin", "code": "glas_tonne_glas_iglu", "label": "Glas-Tonne / Glas-Iglu", "typ_label": None, "typ_code": None},
  {"city_code": "berlin", "code": "laub_und_garten_tonne", "label": "Laub- und Garten-Tonne", "typ_label": None, "typ_code": None},
  {"city_code": "berlin", "code": "papier_tonne", "label": "Papier-Tonne", "typ_label": None, "typ_code": None},
  {"city_code": "berlin", "code": "recyclinghoefe", "label": "Recyclinghöfe", "typ_label": None, "typ_code": None},
  {
    "city_code": "berlin",
    "code": "recyclinghoefe_mit_schadstoff_annahme",
    "label": "Recyclinghöfe mit Schadstoff-Annahme",
    "typ_label": None,
    "typ_code": None,
  },
  {"city_code": "berlin", "code": "restabfall_tonne", "label": "Restabfall-Tonne", "typ_label": None, "typ_code": None},
  {"city_code": "berlin", "code": "sperrmuellabfuhr", "label": "Sperrmüllabfuhr", "typ_label": None, "typ_code": None},
  {"city_code": "berlin", "code": "wertstoff_tonne", "label": "Wertstoff-Tonne", "typ_label": None, "typ_code": None},
  {"city_code": "hannover", "code": "abholung_elektrogeraete", "label": "Abholung Elektrogeräte", "typ_label": None, "typ_code": None},
  {"city_code": "hannover", "code": "altpapiersack", "label": "Altpapiersack", "typ_label": None, "typ_code": None},
  {"city_code": "hannover", "code": "altpapiertonne", "label": "Altpapiertonne", "typ_label": None, "typ_code": None},
  {"city_code": "hannover", "code": "biotonne", "label": "Biotonne", "typ_label": None, "typ_code": None},
  {
    "city_code": "hannover",
    "code": "deponie",
    "label": "Deponie",
    "typ_label": "Deponien und angeschlossene Wertstoffhöfe",
    "typ_code": 2,
  },
  {
    "city_code": "hannover",
    "code": "deponie_hannover_lahe",
    "label": "Deponie Hannover Lahe",
    "typ_label": "Deponien und angeschlossene Wertstoffhöfe",
    "typ_code": 2,
  },
  {
    "city_code": "hannover",
    "code": "deponie_hannover_sonderabfallannahmestelle",
    "label": "Deponie Hannover - Sonderabfallannahmestelle",
    "typ_label": "Deponien und angeschlossene Wertstoffhöfe",
    "typ_code": 2,
  },
  {"city_code": "hannover", "code": "gelbe_tonne", "label": "Gelbe Tonne", "typ_label": None, "typ_code": None},
  {
    "city_code": "hannover",
    "code": "gruengutannahmestellen",
    "label": "Grüngutannahmestellen",
    "typ_label": "Grüngutannahmestelle",
    "typ_code": 3,
  },
  {"city_code": "hannover", "code": "restabfalltonne", "label": "Restabfalltonne", "typ_label": None, "typ_code": None},
  {"city_code": "hannover", "code": "sperrabfallabholung", "label": "Sperrabfallabholung", "typ_label": None, "typ_code": None},
  {
    "city_code": "hannover",
    "code": "wertstoffhof",
    "label": "Wertstoffhof",
    "typ_label": "Wertstoffhöfe",
    "typ_code": 1,
  },
  {
    "city_code": "hannover",
    "code": "wertstoffinsel",
    "label": "Wertstoffinsel",
    "typ_label": "Wertstoffinsel",
    "typ_code": 5,
  },
)


def _ensure_city(bind, city_code: str) -> str:
  name_key = f"city.{city_code}.name"
  bind.execute(
    text(
      """
      INSERT INTO core.i18n_translation(key, lang, text)
      VALUES (:key, 'de', :text)
      ON CONFLICT (key, lang)
      DO UPDATE SET text = EXCLUDED.text, updated_at = now()
      """
    ),
    {"key": name_key, "text": city_code.capitalize()},
  )
  row = bind.execute(
    text(
      """
      INSERT INTO core.city(code, name_key)
      VALUES (:code, :name_key)
      ON CONFLICT (code)
      DO UPDATE SET name_key = EXCLUDED.name_key, updated_at = now()
      RETURNING city_id::text
      """
    ),
    {"code": city_code, "name_key": name_key},
  ).first()
  return row[0]


def _resolve_typ_code(bind, city_id: str, typ_label: str | None, fallback_typ_code: int | None) -> int | None:
  if not typ_label:
    return None
  row = bind.execute(
    text(
      """
      SELECT typ_code
      FROM core.recycle_center
      WHERE city_id = :city_id
        AND typ_label = :typ_label
        AND typ_code IS NOT NULL
      ORDER BY updated_at DESC NULLS LAST, created_at DESC NULLS LAST
      LIMIT 1
      """
    ),
    {"city_id": city_id, "typ_label": typ_label},
  ).first()
  return int(row[0]) if row and row[0] is not None else fallback_typ_code


def upgrade() -> None:
  bind = op.get_bind()

  op.execute("ALTER TABLE core.disposal_method ADD COLUMN IF NOT EXISTS city_id uuid NULL")
  op.execute("ALTER TABLE core.disposal_method ADD COLUMN IF NOT EXISTS recycle_center_typ_code integer NULL")
  op.execute(
    """
    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_disposal_method_city'
          AND conrelid = 'core.disposal_method'::regclass
      ) THEN
        ALTER TABLE core.disposal_method
          ADD CONSTRAINT fk_disposal_method_city
          FOREIGN KEY (city_id) REFERENCES core.city(city_id) ON DELETE RESTRICT;
      END IF;
    END $$;
    """
  )
  op.execute(
    "CREATE INDEX IF NOT EXISTS ix_disposal_method_city ON core.disposal_method(city_id)"
  )
  op.execute(
    "CREATE INDEX IF NOT EXISTS ix_disposal_method_city_type ON core.disposal_method(city_id, recycle_center_typ_code)"
  )

  city_ids = {
    city_code: _ensure_city(bind, city_code)
    for city_code in sorted({seed["city_code"] for seed in SEEDS})
  }

  for seed in SEEDS:
    city_id = city_ids[seed["city_code"]]
    name_key = f"disposal.{seed['code']}.name"
    typ_code = _resolve_typ_code(bind, city_id, seed["typ_label"], seed["typ_code"])

    bind.execute(
      text(
        """
        INSERT INTO core.i18n_translation(key, lang, text)
        VALUES (:key, 'de', :text)
        ON CONFLICT (key, lang)
        DO UPDATE SET text = EXCLUDED.text, updated_at = now()
        """
      ),
      {"key": name_key, "text": seed["label"]},
    )

    existing = bind.execute(
      text("SELECT disposal_id::text FROM core.disposal_method WHERE code = :code"),
      {"code": seed["code"]},
    ).first()

    if existing:
      bind.execute(
        text(
          """
          UPDATE core.disposal_method
          SET name_key = :name_key,
              city_id = :city_id,
              recycle_center_typ_code = :typ_code,
              updated_at = now()
          WHERE code = :code
          """
        ),
        {
          "name_key": name_key,
          "city_id": city_id,
          "typ_code": typ_code,
          "code": seed["code"],
        },
      )
      continue

    bind.execute(
      text(
        """
        INSERT INTO core.disposal_method (
          code,
          name_key,
          description_key,
          city_id,
          recycle_center_typ_code
        )
        VALUES (
          :code,
          :name_key,
          NULL,
          :city_id,
          :typ_code
        )
        """
      ),
      {
        "code": seed["code"],
        "name_key": name_key,
        "city_id": city_id,
        "typ_code": typ_code,
      },
    )


def downgrade() -> None:
  op.execute("DROP INDEX IF EXISTS ix_disposal_method_city_type")
  op.execute("DROP INDEX IF EXISTS ix_disposal_method_city")
  op.execute(
    """
    ALTER TABLE core.disposal_method
    DROP CONSTRAINT IF EXISTS fk_disposal_method_city
    """
  )
  op.execute("ALTER TABLE core.disposal_method DROP COLUMN IF EXISTS recycle_center_typ_code")
  op.execute("ALTER TABLE core.disposal_method DROP COLUMN IF EXISTS city_id")
