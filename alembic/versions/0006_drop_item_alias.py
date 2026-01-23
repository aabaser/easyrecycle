"""drop item_alias

Revision ID: 0006_drop_item_alias
Revises: 0005_vision_cache_notes
Create Date: 2026-01-07
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0006_drop_item_alias"
down_revision = "0005_vision_cache_notes"
branch_labels = None
depends_on = None


def upgrade() -> None:
  op.execute("DROP TABLE IF EXISTS core.item_alias;")


def downgrade() -> None:
  op.execute(
    """
    CREATE TABLE IF NOT EXISTS core.item_alias (
      item_id     uuid NOT NULL REFERENCES core.item(item_id) ON DELETE CASCADE,
      lang        text NOT NULL REFERENCES core.language(lang),
      alias_text  text NOT NULL,
      created_at  timestamptz NOT NULL DEFAULT now(),
      PRIMARY KEY (item_id, lang, alias_text)
    );
    CREATE INDEX IF NOT EXISTS ix_item_alias_trgm
      ON core.item_alias USING gin (alias_text gin_trgm_ops);
    """
  )
