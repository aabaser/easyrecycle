# City rules (no inheritance)

Resolver rule:
1) Try requested city only.
2) If city has no rules for the item, return empty rules + suggestions, and create a prospect for admin enrichment.
3) No fallback to other cities (even if base_city_id exists).

This is applied per facet:
- disposal(s)
- warnings
- actions
- text overrides (title/desc)

Prospect:
- Missing city rules trigger a pending prospect row; admin can enrich with city-specific item_city_* data.
- Suggestions are based on similar item aliases (trigram).
