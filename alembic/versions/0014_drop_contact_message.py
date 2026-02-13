"""drop contact messages

Revision ID: 0014_drop_contact_message
Revises: 0013_contact_message
Create Date: 2026-02-12
"""

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "0014_drop_contact_message"
down_revision = "0013_contact_message"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.drop_index("ix_contact_message_created", table_name="contact_message", schema="core")
    op.drop_table("contact_message", schema="core")


def downgrade() -> None:
    op.create_table(
        "contact_message",
        sa.Column(
            "message_id",
            sa.UUID(),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column("email", sa.Text(), nullable=False),
        sa.Column("name", sa.Text(), nullable=True),
        sa.Column("message", sa.Text(), nullable=False),
        sa.Column("ip", sa.Text(), nullable=True),
        sa.Column("user_agent", sa.Text(), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        schema="core",
    )
    op.create_index(
        "ix_contact_message_created",
        "contact_message",
        ["created_at"],
        schema="core",
    )
