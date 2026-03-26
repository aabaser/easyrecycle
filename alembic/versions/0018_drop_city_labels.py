"""drop unused city label tables

Revision ID: 0018_drop_city_labels
Revises: 0017_disposal_method_city
Create Date: 2026-03-24
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0018_drop_city_labels"
down_revision = "0017_disposal_method_city"
branch_labels = None
depends_on = None


def upgrade() -> None:
  op.execute("DROP TABLE IF EXISTS core.city_disposal_label")
  op.execute("DROP TABLE IF EXISTS core.city_category_label")


def downgrade() -> None:
  op.execute(
    """
    CREATE TABLE IF NOT EXISTS core.city_category_label (
      city_id       uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
      category_id   uuid NOT NULL REFERENCES core.category(category_id) ON DELETE CASCADE,
      label_key     text NOT NULL,
      PRIMARY KEY (city_id, category_id)
    )
    """
  )
  op.execute(
    """
    CREATE TABLE IF NOT EXISTS core.city_disposal_label (
      city_id       uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
      disposal_id   uuid NOT NULL REFERENCES core.disposal_method(disposal_id) ON DELETE CASCADE,
      label_key     text NOT NULL,
      PRIMARY KEY (city_id, disposal_id)
    )
    """
  )
