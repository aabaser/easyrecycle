"""item feedback

Revision ID: 0007_item_feedback
Revises: 0006_drop_item_alias
Create Date: 2026-01-08
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0007_item_feedback"
down_revision = "0006_drop_item_alias"
branch_labels = None
depends_on = None


def upgrade() -> None:
  op.execute(
    """
    CREATE TABLE IF NOT EXISTS core.item_feedback (
      feedback_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      item_id     uuid NOT NULL REFERENCES core.item(item_id) ON DELETE CASCADE,
      city_id     uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
      lang        text NULL REFERENCES core.language(lang),
      feedback    smallint NOT NULL CHECK (feedback IN (-1, 1)),
      source      text NULL,
      session_id  text NULL,
      created_at  timestamptz NOT NULL DEFAULT now()
    );
    CREATE INDEX IF NOT EXISTS ix_item_feedback_item_city
      ON core.item_feedback(item_id, city_id);
    CREATE INDEX IF NOT EXISTS ix_item_feedback_created
      ON core.item_feedback(created_at);
    """
  )


def downgrade() -> None:
  op.execute("DROP TABLE IF EXISTS core.item_feedback;")
