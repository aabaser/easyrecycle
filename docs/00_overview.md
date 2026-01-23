# Overview

Easy Recycle turns an item photo into a concrete action plan:
- Recycle: which disposal method, where, and any warnings
- Repair / Donate / Resell: suggested pathways and partners (payload-driven)

The platform is **city-aware** and each city is independent (no fallback):
- If a city has rules for the item, return only that city's data.
- If a city has no rules, return suggestions + create a prospect for admin enrichment.

## Core flows
- `/resolve`: city-only rules (no cross-city fallback), suggestions + prospect when missing.
- `/analyze`: image -> OpenAI Vision -> resolve (or suggestions + prospect if unknown).
- Vision cache: normalized image hash + model -> cache_key to avoid repeated calls.
- i18n: domain tables store keys, texts live in `core.i18n_translation`.
