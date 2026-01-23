# Data model (high level)

Core ideas:
- **Items are canonical**
- **Text is via i18n keys**; translations live in i18n_translation
- **Cities are independent**; no runtime fallback between cities. Each city has its own item_city_* rows; missing data stays empty/unknown and triggers a prospect.

Key tables:
- core.item
- core.city (base_city_id is unused at runtime; cities are independent)
- core.i18n_translation (currently only de is populated in imports)
- core.category, core.disposal_method, core.warning
- core.item_city_* (disposal/category/actions/warnings/text overrides)
- core.prospect (pending enrichment for missing city rules)

See `/sql/schema.sql` for the full schema.
