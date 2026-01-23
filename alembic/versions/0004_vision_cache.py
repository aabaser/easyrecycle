"""vision cache

Revision ID: 0004_vision_cache
Revises: 0003_prospect
Create Date: 2026-01-06
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0004_vision_cache"
down_revision = "0003_prospect"
branch_labels = None
depends_on = None


def upgrade() -> None:
  op.execute(
    """
    CREATE TABLE IF NOT EXISTS core.vision_cache (
      cache_key     text PRIMARY KEY,
      canonical_key text NULL,
      confidence    double precision NOT NULL,
      labels        jsonb NOT NULL,
      created_at    timestamptz NOT NULL DEFAULT now(),
      expires_at    timestamptz NOT NULL
    );
    CREATE INDEX IF NOT EXISTS ix_vision_cache_expires ON core.vision_cache(expires_at);
    """
  )


def downgrade() -> None:
  op.execute("DROP TABLE IF EXISTS core.vision_cache;")
