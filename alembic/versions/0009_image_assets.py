"""replace item_image with image_asset + scan_event

Revision ID: 0009_image_assets
Revises: 0008_item_feedback_unique
Create Date: 2026-01-22
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0009_image_assets"
down_revision = "0008_item_feedback_unique"
branch_labels = None
depends_on = None


def upgrade() -> None:
  op.execute(
    """
    DROP TABLE IF EXISTS core.item_image;

    CREATE TABLE IF NOT EXISTS core.image_asset (
      image_id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      storage_key       text NOT NULL,
      normalized_sha256 text NOT NULL,
      content_type      text NULL,
      byte_size         int NULL,
      width             int NULL,
      height            int NULL,
      source            text NOT NULL DEFAULT 'scan',
      created_at        timestamptz NOT NULL DEFAULT now(),
      UNIQUE (normalized_sha256)
    );
    CREATE INDEX IF NOT EXISTS ix_image_asset_created ON core.image_asset(created_at);

    CREATE TABLE IF NOT EXISTS core.scan_event (
      scan_id     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      image_id    uuid NOT NULL REFERENCES core.image_asset(image_id) ON DELETE CASCADE,
      cache_key   text NULL,
      city_id     uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
      item_id     uuid NULL REFERENCES core.item(item_id) ON DELETE SET NULL,
      prospect_id uuid NULL REFERENCES core.prospect(prospect_id) ON DELETE SET NULL,
      search_text text NULL,
      source      text NOT NULL DEFAULT 'scan',
      created_at  timestamptz NOT NULL DEFAULT now()
    );
    CREATE INDEX IF NOT EXISTS ix_scan_event_created ON core.scan_event(created_at);
    CREATE INDEX IF NOT EXISTS ix_scan_event_city ON core.scan_event(city_id);
    CREATE INDEX IF NOT EXISTS ix_scan_event_item ON core.scan_event(item_id);
    CREATE INDEX IF NOT EXISTS ix_scan_event_prospect ON core.scan_event(prospect_id);

    ALTER TABLE core.vision_cache
      ADD COLUMN IF NOT EXISTS image_id uuid
        REFERENCES core.image_asset(image_id) ON DELETE SET NULL;
    CREATE INDEX IF NOT EXISTS ix_vision_cache_image ON core.vision_cache(image_id);
    """
  )


def downgrade() -> None:
  op.execute(
    """
    DROP INDEX IF EXISTS ix_vision_cache_image;
    ALTER TABLE core.vision_cache
      DROP COLUMN IF EXISTS image_id;

    DROP TABLE IF EXISTS core.scan_event;
    DROP TABLE IF EXISTS core.image_asset;

    CREATE TABLE IF NOT EXISTS core.item_image (
      item_image_id   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      item_id         uuid NOT NULL REFERENCES core.item(item_id) ON DELETE CASCADE,
      url             text NOT NULL,
      sort_order      int NOT NULL DEFAULT 1
    );
    CREATE INDEX IF NOT EXISTS idx_item_image_item ON core.item_image(item_id);
    """
  )
