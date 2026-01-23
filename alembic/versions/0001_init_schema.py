"""init schema

Revision ID: 0001_init_schema
Revises:
Create Date: 2026-01-04

"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0001_init_schema"
down_revision = None
branch_labels = None
depends_on = None

def upgrade() -> None:
  # Execute raw SQL schema
  with open("sql/schema.sql", "r", encoding="utf-8") as f:
    op.execute(f.read())

def downgrade() -> None:
  op.execute("DROP SCHEMA IF EXISTS core CASCADE;")
