"""add disposal_positive to recycle centers

Revision ID: 0015_recycle_center_disp_pos
Revises: 0014_drop_contact_message
Create Date: 2026-03-01
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0015_recycle_center_disp_pos"
down_revision = "0014_drop_contact_message"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.execute(
        """
        ALTER TABLE core.recycle_center
        ADD COLUMN IF NOT EXISTS disposal_positive text[] NULL;
        """
    )


def downgrade() -> None:
    op.execute(
        """
        ALTER TABLE core.recycle_center
        DROP COLUMN IF EXISTS disposal_positive;
        """
    )
