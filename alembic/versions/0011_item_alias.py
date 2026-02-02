"""add core.item_alias and normalization

Revision ID: 0011_item_alias
Revises: 0010_item_primary_image
Create Date: 2026-01-31
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0011_item_alias"
down_revision = "0010_item_primary_image"
branch_labels = None
depends_on = None


def upgrade() -> None:
  op.execute(
    """
    CREATE EXTENSION IF NOT EXISTS unaccent;
    CREATE EXTENSION IF NOT EXISTS pg_trgm;

    CREATE TABLE IF NOT EXISTS core.item_alias (
      alias_id BIGSERIAL PRIMARY KEY,
      canonical_key TEXT NOT NULL
        REFERENCES core.item(canonical_key) ON DELETE CASCADE,
      lang TEXT NOT NULL,
      alias_text TEXT NOT NULL,
      alias_norm TEXT NOT NULL,
      alias_type TEXT NOT NULL DEFAULT 'auto',
      source TEXT NOT NULL DEFAULT 'seed',
      confidence NUMERIC(3,2) NOT NULL DEFAULT 1.00,
      created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
      CONSTRAINT uq_item_alias_lang_norm UNIQUE (lang, alias_norm)
    );

    CREATE INDEX IF NOT EXISTS ix_item_alias_canonical_key
      ON core.item_alias(canonical_key);
    CREATE INDEX IF NOT EXISTS ix_item_alias_alias_norm_trgm
      ON core.item_alias USING GIN (alias_norm gin_trgm_ops);
    """
  )


def downgrade() -> None:
  op.execute(
    """
    DROP INDEX IF EXISTS ix_item_alias_alias_norm_trgm;
    DROP INDEX IF EXISTS ix_item_alias_canonical_key;
    DROP TABLE IF EXISTS core.item_alias;
    """
  )
