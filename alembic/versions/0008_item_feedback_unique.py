"""item feedback unique per session

Revision ID: 0008_item_feedback_unique
Revises: 0007_item_feedback
Create Date: 2026-01-08
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0008_item_feedback_unique"
down_revision = "0007_item_feedback"
branch_labels = None
depends_on = None


def upgrade() -> None:
  op.execute(
    """
    ALTER TABLE core.item_feedback
    ADD COLUMN IF NOT EXISTS updated_at timestamptz NOT NULL DEFAULT now();
    UPDATE core.item_feedback
    SET session_id = 'unknown'
    WHERE session_id IS NULL;
    ALTER TABLE core.item_feedback
    ALTER COLUMN session_id SET NOT NULL;
    CREATE UNIQUE INDEX IF NOT EXISTS ux_item_feedback_item_city_session
      ON core.item_feedback(item_id, city_id, session_id);
    """
  )


def downgrade() -> None:
  op.execute(
    """
    DROP INDEX IF EXISTS ux_item_feedback_item_city_session;
    ALTER TABLE core.item_feedback
    ALTER COLUMN session_id DROP NOT NULL;
    ALTER TABLE core.item_feedback
    DROP COLUMN IF EXISTS updated_at;
    """
  )
