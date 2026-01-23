"""prospect table

Revision ID: 0002_prospect_table
Revises: 0001_init_schema
Create Date: 2026-01-06
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0002_prospect_table"
down_revision = "0001_init_schema"
branch_labels = None
depends_on = None


def upgrade() -> None:
  op.execute(
    """
    CREATE TABLE IF NOT EXISTS core.prospect (
      prospect_id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      item_id              uuid NOT NULL REFERENCES core.item(item_id) ON DELETE CASCADE,
      city_id              uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
      lang                 text NOT NULL REFERENCES core.language(lang),
      status               text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','approved','rejected')),
      reason               text NULL,
      suggested_categories text[] NULL,
      suggested_disposals  text[] NULL,
      suggested_warnings   text[] NULL,
      notes                text NULL,
      created_at           timestamptz NOT NULL DEFAULT now(),
      updated_at           timestamptz NOT NULL DEFAULT now(),
      UNIQUE (item_id, city_id, lang)
    );
    CREATE INDEX IF NOT EXISTS ix_prospect_status ON core.prospect(status);
    """
  )


def downgrade() -> None:
  op.execute("DROP TABLE IF EXISTS core.prospect;")
