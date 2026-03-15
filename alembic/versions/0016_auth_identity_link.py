"""add auth identity and guest link tables

Revision ID: 0016_auth_identity_link
Revises: 0015_recycle_center_disp_pos
Create Date: 2026-03-07
"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "0016_auth_identity_link"
down_revision = "0015_recycle_center_disp_pos"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.execute(
        """
        CREATE TABLE IF NOT EXISTS core.auth_identity (
          identity_id      uuid PRIMARY KEY DEFAULT gen_random_uuid(),
          provider         text NOT NULL,
          subject          text NOT NULL,
          email            citext NULL,
          email_verified   boolean NOT NULL DEFAULT false,
          last_login_at    timestamptz NULL,
          created_at       timestamptz NOT NULL DEFAULT now(),
          updated_at       timestamptz NOT NULL DEFAULT now(),
          UNIQUE (provider, subject)
        );

        CREATE INDEX IF NOT EXISTS ix_auth_identity_email
          ON core.auth_identity(email);

        CREATE TABLE IF NOT EXISTS core.guest_identity_link (
          link_id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
          guest_sub       text NOT NULL UNIQUE,
          identity_id     uuid NOT NULL REFERENCES core.auth_identity(identity_id) ON DELETE CASCADE,
          linked_at       timestamptz NOT NULL DEFAULT now(),
          created_at      timestamptz NOT NULL DEFAULT now(),
          updated_at      timestamptz NOT NULL DEFAULT now()
        );

        CREATE INDEX IF NOT EXISTS ix_guest_identity_link_identity
          ON core.guest_identity_link(identity_id);
        """
    )


def downgrade() -> None:
    op.execute(
        """
        DROP TABLE IF EXISTS core.guest_identity_link;
        DROP TABLE IF EXISTS core.auth_identity;
        """
    )
