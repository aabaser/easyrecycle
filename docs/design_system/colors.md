# Palette C - Color System (Easy Recycle)

## Core Brand Colors
- Primary Blue: #2563EB
- Primary Indigo: #4338CA
- Accent Cyan: #22D3EE

## Neutrals
- Light Background: #F7FAFF
- Light Surface: #FFFFFF
- Light Text (Ink): #0B1220
- Dark Background: #0B1220
- Dark Surface: #111B2E
- Dark Text: #FFFFFF

## Status Colors
- Success: #16A34A
- Warning: #F59E0B
- Error: #EF4444
- Info: #38BDF8

## Usage Rules
- Use neutrals for surfaces and large areas; keep color accents minimal.
- Primary Blue is the default CTA color.
- Primary Indigo is for secondary emphasis (rare).
- Accent Cyan is for highlights and informational accents (rare).
- Status colors should be applied subtly (low-opacity backgrounds + solid text/icon).

## Gradients
Allowed only for special surfaces (hero/header/brand accents):
- PrimaryGradient: #2563EB -> #4338CA
- AccentGradient: #22D3EE -> #2563EB

Avoid gradients on body text or small icons.

## Component Mapping
- AppBar: surface background, onSurface text/icons
- Primary Button: primaryBlue background, white text
- Secondary Button: transparent background, primaryBlue border/text
- Cards: surface background + subtle border
- Chips: surfaceVariant background, onSurface text
- Alerts: status color (low opacity) + status text

## Disposal Chip Mapping
These rules are implemented in `lib/ui/disposal_chip_palette.dart`.

### Normalization
- Convert to lowercase
- Replace `ä -> ae`, `ö -> oe`, `ü -> ue`, `ß -> ss`
- Replace non-alphanumeric characters with `_`
- Collapse repeated `_`

### Recycle Center Type Keys
- `recycle_type_1` -> `emerald`
- `recycle_type_2` -> `slate`
- `recycle_type_3` -> `olive`
- `recycle_type_5` -> `sky`

### Disposal Method Keys
- `brown`
  - `laub_und_garten_tonne`
  - `biotonne`
  - `biogut_tonne`
- `blue`
  - `altpapiersack`
  - `altpapiertonne`
  - `papier_tonne`
- `yellow`
  - `gelbe_tonne`
  - `wertstoff_tonne`
- `gray`
  - `restabfalltonne`
  - `restabfall_tonne`
- All other values -> `default`

### Palette Key Generation
- If `typCode` exists: `recycle_type_<typCode>`
- Else if `disposalPositive` exists: `recycle_disposal_<normalized>`
- Else: `recycle_link_<normalized label>`

### Important Note
- Only the keys above have explicit special tones.
- `recycle_disposal_*` and `recycle_link_*` values fall back to `default` unless a new mapping is added in code.

## Accessibility Notes
- Text on primaryBlue/primaryIndigo must stay white for contrast.
- In dark mode, keep surfaces distinct from background.
- Disabled buttons: primary at ~30% opacity, text at ~60%.
