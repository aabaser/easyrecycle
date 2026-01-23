"""vision cache notes

Revision ID: 0005_vision_cache_notes
Revises: 0004_vision_cache
Create Date: 2026-01-07
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0005_vision_cache_notes"
down_revision = "0004_vision_cache"
branch_labels = None
depends_on = None


def upgrade() -> None:
  op.execute(
    """
    ALTER TABLE core.vision_cache
    ADD COLUMN IF NOT EXISTS notes text NULL;
    """
  )


def downgrade() -> None:
  op.execute(
    """
    ALTER TABLE core.vision_cache
    DROP COLUMN IF EXISTS notes;
    """
  )
