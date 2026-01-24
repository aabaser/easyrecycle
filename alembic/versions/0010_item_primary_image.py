"""add primary_image_id to item

Revision ID: 0010_item_primary_image
Revises: 0009_image_assets
Create Date: 2026-01-23
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0010_item_primary_image"
down_revision = "0009_image_assets"
branch_labels = None
depends_on = None


def upgrade() -> None:
  op.execute(
    """
    ALTER TABLE core.item
      ADD COLUMN IF NOT EXISTS primary_image_id uuid
        REFERENCES core.image_asset(image_id) ON DELETE SET NULL;
    CREATE INDEX IF NOT EXISTS ix_item_primary_image ON core.item(primary_image_id);
    """
  )


def downgrade() -> None:
  op.execute(
    """
    DROP INDEX IF EXISTS ix_item_primary_image;
    ALTER TABLE core.item
      DROP COLUMN IF EXISTS primary_image_id;
    """
  )
