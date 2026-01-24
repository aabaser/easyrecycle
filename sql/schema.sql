CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE SCHEMA IF NOT EXISTS core;

CREATE TABLE IF NOT EXISTS core.city (
  city_id        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code           text NOT NULL UNIQUE,
  name_key       text NOT NULL,
  base_city_id   uuid NULL REFERENCES core.city(city_id) ON DELETE SET NULL,
  is_active      boolean NOT NULL DEFAULT true,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS core.language (
  lang           text PRIMARY KEY,
  is_active      boolean NOT NULL DEFAULT true
);
INSERT INTO core.language(lang) VALUES ('de'), ('en'), ('tr') ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS core.i18n_translation (
  key            text NOT NULL,
  lang           text NOT NULL REFERENCES core.language(lang),
  text           text NOT NULL,
  updated_at     timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (key, lang)
);
CREATE INDEX IF NOT EXISTS ix_i18n_translation_fts
  ON core.i18n_translation USING gin (to_tsvector('simple', text));
CREATE INDEX IF NOT EXISTS ix_i18n_translation_trgm
  ON core.i18n_translation USING gin (text gin_trgm_ops);

CREATE TABLE IF NOT EXISTS core.category (
  category_id    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code           text NOT NULL UNIQUE,
  name_key       text NOT NULL,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS core.disposal_method (
  disposal_id     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code            text NOT NULL UNIQUE,
  name_key        text NOT NULL,
  description_key text NULL,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS core.warning (
  warning_id   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code         text NOT NULL UNIQUE,
  title_key    text NOT NULL,
  body_key     text NULL,
  severity     smallint NOT NULL DEFAULT 2,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now()
);

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

CREATE TABLE IF NOT EXISTS core.item (
  item_id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  external_document_id  text UNIQUE,
  source                text NULL,
  canonical_key         text NOT NULL UNIQUE,
  title_key             text NOT NULL,
  desc_key              text NULL,
  primary_image_id      uuid NULL REFERENCES core.image_asset(image_id) ON DELETE SET NULL,
  is_active             boolean NOT NULL DEFAULT true,
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS ix_item_primary_image ON core.item(primary_image_id);

CREATE TABLE IF NOT EXISTS core.item_city_text_override (
  city_id       uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
  item_id       uuid NOT NULL REFERENCES core.item(item_id) ON DELETE CASCADE,
  title_key     text NULL,
  desc_key      text NULL,
  PRIMARY KEY (city_id, item_id)
);

CREATE TABLE IF NOT EXISTS core.item_city_category (
  city_id       uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
  item_id       uuid NOT NULL REFERENCES core.item(item_id) ON DELETE CASCADE,
  category_id   uuid NOT NULL REFERENCES core.category(category_id) ON DELETE RESTRICT,
  priority      int NOT NULL DEFAULT 1,
  PRIMARY KEY (city_id, item_id, category_id)
);
CREATE INDEX IF NOT EXISTS ix_item_city_category_item_city
  ON core.item_city_category(item_id, city_id);

CREATE TABLE IF NOT EXISTS core.item_city_action (
  city_id       uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
  item_id       uuid NOT NULL REFERENCES core.item(item_id) ON DELETE CASCADE,
  action_type   text NOT NULL CHECK (action_type IN ('recycle','repair','donate','resell')),
  payload       jsonb NULL,
  priority      int NOT NULL DEFAULT 1,
  PRIMARY KEY (city_id, item_id, action_type, priority)
);
CREATE INDEX IF NOT EXISTS ix_item_city_action_item_city
  ON core.item_city_action(item_id, city_id);

CREATE TABLE IF NOT EXISTS core.item_city_disposal (
  city_id       uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
  item_id       uuid NOT NULL REFERENCES core.item(item_id) ON DELETE CASCADE,
  disposal_id   uuid NOT NULL REFERENCES core.disposal_method(disposal_id) ON DELETE RESTRICT,
  priority      int NOT NULL DEFAULT 1,
  PRIMARY KEY (city_id, item_id, disposal_id)
);
CREATE INDEX IF NOT EXISTS ix_item_city_disposal_item_city
  ON core.item_city_disposal(item_id, city_id);

CREATE TABLE IF NOT EXISTS core.item_city_warning (
  city_id       uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
  item_id       uuid NOT NULL REFERENCES core.item(item_id) ON DELETE CASCADE,
  warning_id    uuid NOT NULL REFERENCES core.warning(warning_id) ON DELETE RESTRICT,
  PRIMARY KEY (city_id, item_id, warning_id)
);
CREATE INDEX IF NOT EXISTS ix_item_city_warning_item_city
  ON core.item_city_warning(item_id, city_id);

CREATE TABLE IF NOT EXISTS core.city_category_label (
  city_id       uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
  category_id   uuid NOT NULL REFERENCES core.category(category_id) ON DELETE CASCADE,
  label_key     text NOT NULL,
  PRIMARY KEY (city_id, category_id)
);

CREATE TABLE IF NOT EXISTS core.city_disposal_label (
  city_id       uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
  disposal_id   uuid NOT NULL REFERENCES core.disposal_method(disposal_id) ON DELETE CASCADE,
  label_key     text NOT NULL,
  PRIMARY KEY (city_id, disposal_id)
);

CREATE TABLE IF NOT EXISTS core.prospect (
  prospect_id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  item_id              uuid NULL REFERENCES core.item(item_id) ON DELETE CASCADE,
  city_id              uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
  lang                 text NOT NULL REFERENCES core.language(lang),
  status               text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','approved','rejected')),
  reason               text NULL,
  search_text          text NULL,
  suggested_categories text[] NULL,
  suggested_disposals  text[] NULL,
  suggested_warnings   text[] NULL,
  notes                text NULL,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS ix_prospect_status ON core.prospect(status);
CREATE UNIQUE INDEX IF NOT EXISTS ux_prospect_item_city_lang
  ON core.prospect(item_id, city_id, lang) WHERE item_id IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS ux_prospect_search_city_lang
  ON core.prospect(search_text, city_id, lang) WHERE search_text IS NOT NULL;

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

CREATE TABLE IF NOT EXISTS core.vision_cache (
  cache_key     text PRIMARY KEY,
  image_id      uuid NULL REFERENCES core.image_asset(image_id) ON DELETE SET NULL,
  canonical_key text NULL,
  confidence    double precision NOT NULL,
  labels        jsonb NOT NULL,
  notes         text NULL,
  created_at    timestamptz NOT NULL DEFAULT now(),
  expires_at    timestamptz NOT NULL
);
CREATE INDEX IF NOT EXISTS ix_vision_cache_expires ON core.vision_cache(expires_at);
CREATE INDEX IF NOT EXISTS ix_vision_cache_image ON core.vision_cache(image_id);

CREATE TABLE IF NOT EXISTS core.item_feedback (
  feedback_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  item_id     uuid NOT NULL REFERENCES core.item(item_id) ON DELETE CASCADE,
  city_id     uuid NOT NULL REFERENCES core.city(city_id) ON DELETE CASCADE,
  lang        text NULL REFERENCES core.language(lang),
  feedback    smallint NOT NULL CHECK (feedback IN (-1, 1)),
  source      text NULL,
  session_id  text NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS ix_item_feedback_item_city
  ON core.item_feedback(item_id, city_id);
CREATE INDEX IF NOT EXISTS ix_item_feedback_created
  ON core.item_feedback(created_at);
CREATE UNIQUE INDEX IF NOT EXISTS ux_item_feedback_item_city_session
  ON core.item_feedback(item_id, city_id, session_id);
