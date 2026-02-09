"""add recycle centers

Revision ID: 0012_recycle_centers
Revises: 0011_item_alias
Create Date: 2026-02-08
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0012_recycle_centers"
down_revision = "0011_item_alias"
branch_labels = None
depends_on = None


def upgrade() -> None:
  op.execute(
    """
    CREATE TABLE IF NOT EXISTS core.recycle_center (
      center_id   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      city_id     uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
      source      text NOT NULL DEFAULT 'import',
      external_id text NULL,
      name        text NOT NULL,
      address     text NOT NULL,
      lat         double precision NOT NULL,
      lng         double precision NOT NULL,
      typ_code    int NULL,
      typ_label   text NULL,
      has_glas    boolean NULL,
      has_kleider boolean NULL,
      has_papier  boolean NULL,
      is_active   boolean NOT NULL DEFAULT true,
      created_at  timestamptz NOT NULL DEFAULT now(),
      updated_at  timestamptz NOT NULL DEFAULT now()
    );
    CREATE INDEX IF NOT EXISTS ix_recycle_center_city
      ON core.recycle_center(city_id);
    CREATE INDEX IF NOT EXISTS ix_recycle_center_city_type
      ON core.recycle_center(city_id, typ_code);
    """
  )


def downgrade() -> None:
  op.execute(
    """
    DROP TABLE IF EXISTS core.recycle_center;
    """
  )
