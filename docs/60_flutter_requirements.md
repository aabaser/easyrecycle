# Flutter MVP Requirements (Easy Recycle)

## Scope
- Flutter MVP for Android + Web.
- City rules are independent; no cross-city fallback.
- Language selection first screen (DE/TR/EN) with persistence.

## Pages (4 total)
1) LanguagePickerPage
   - DE/TR/EN selection.
   - Persist locale.
2) CityPickerPage
   - Berlin + Hannover.
   - Search/filter input.
   - City required to continue; persist selection.
3) ScanPage
   - Camera button + gallery/upload.
   - Text search input with suffix search icon.
   - Text search calls `/resolve` API.
   - AppBar shows Language + City pills (same style, with dropdown arrow).
4) ResultPage
   - Found: item header (title + categories in parentheses), confidence, disposal block, description, best option, other options, warnings, rescan.
   - NotFound: warning + 3 similar item cards + rescan.
   - AppBar shows Language + City pills (same style, with dropdown arrow).

## i18n
- `intl` + ARB files:
  - `lib/l10n/arb/app_de.arb`
  - `lib/l10n/arb/app_tr.arb`
  - `lib/l10n/arb/app_en.arb`
- `AppLocalizations` loads ARB at runtime.
- Locale source order: saved locale > device locale (if supported) > German.

## Design System
- Tokens: `lib/theme/design_tokens.dart` and `docs/design_system.md`.
- Colors: deep green primary, soft mint container, off-white surface.
- Spacing: 8dp base, 24dp sections, 16dp card padding.
- Radius: 16dp corners; buttons 52/44dp.

## Services (Mock + API)
- Vision (mock): text keywords map to categories.
- Rules (mock): category -> disposal, steps, warnings, options.
- Similarity (mock): returns 3 items.
- API integration:
  - Text search triggers GET `/resolve?city={id}&lang={lang}&item_name={query}`.
  - ResultPage shows `item`, `description`, `categories`, `disposals` labels from JSON.
  - Similar item CTA triggers GET `/resolve?city={id}&lang={lang}&item_id={id}` and opens Found state.

## Data Models
- `ScanResult` includes:
  - `state`, `itemName`, `description`, `confidence`, `disposalMethod`, `disposalSteps`.
  - `categories`, `disposalLabels`.
  - `bestOption`, `otherOptions`, `warnings`, `similarItems`.

## UI Details (Found)
- AppBar title: `Erkannt: <item>`.
- Header image placeholder + item row + confidence chip.
- Entsorgung card with icon, steps, and "Anleitung anzeigen" toggle.
- Categories appear next to item title in parentheses.
- Disposals show as chips inside the Entsorgung card.
- Best option card + other options accordion.
- Warnings banner at bottom.
- Description HTML is cleaned before display.

## UI Details (NotFound)
- Title: "Kein Treffer".
- Warning banner.
- "Aehnliche Vorschlaege" + 3 cards.
- Rescan button.
- Similar item cards show alias/title + disposal chips only.
