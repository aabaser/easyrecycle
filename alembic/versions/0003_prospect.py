"""prospect search_text and nullable item

Revision ID: 0003_prospect
Revises: 0002_prospect_table
Create Date: 2026-01-06
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0003_prospect"
down_revision = "0002_prospect_table"
branch_labels = None
depends_on = None


def upgrade() -> None:
  op.execute(
    """
    ALTER TABLE core.prospect
      ALTER COLUMN item_id DROP NOT NULL,
      ADD COLUMN IF NOT EXISTS search_text text NULL;
    -- drop old unique constraint if exists
    DO $$
    BEGIN
      IF EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'core_prospect_item_id_city_id_lang_key'
          AND conrelid = 'core.prospect'::regclass
      ) THEN
        ALTER TABLE core.prospect DROP CONSTRAINT core_prospect_item_id_city_id_lang_key;
      END IF;
    END$$;
    CREATE UNIQUE INDEX IF NOT EXISTS ux_prospect_item_city_lang
      ON core.prospect(item_id, city_id, lang) WHERE item_id IS NOT NULL;
    CREATE UNIQUE INDEX IF NOT EXISTS ux_prospect_search_city_lang
      ON core.prospect(search_text, city_id, lang) WHERE search_text IS NOT NULL;
    """
  )


def downgrade() -> None:
  op.execute(
    """
    DROP INDEX IF EXISTS ux_prospect_item_city_lang;
    DROP INDEX IF EXISTS ux_prospect_search_city_lang;
    ALTER TABLE core.prospect DROP COLUMN IF EXISTS search_text;
    ALTER TABLE core.prospect ALTER COLUMN item_id SET NOT NULL;
    ALTER TABLE core.prospect ADD CONSTRAINT core_prospect_item_id_city_id_lang_key UNIQUE (item_id, city_id, lang);
    """
  )
