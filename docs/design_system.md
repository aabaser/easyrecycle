# Easy Recycle Design System (Flutter MVP)

## Colors
- Primary: #2E6B4F (deep green)
- PrimaryContainer: #DDEBE3 (soft mint)
- Surface: #F7F8F7 (off-white)
- OnSurface: #1E1F1E
- Outline: #D9DED9
- Warning bg: #FFF3D6
- Warning text: #6B4E00
- Danger bg: #FFE3E3
- Danger text: #7A1C1C

## Typography
- Font family: system default (Roboto); fallback Roboto/Arial/sans-serif
- Title L: 22, weight 600
- Title M: 18, weight 600
- Body: 14–16, weight 400
- Caption: 12, weight 400
- Buttons: 16, weight 600

## Spacing & Radius
- Base spacing: 8dp
- Section spacing: 24dp
- Card padding: 16dp
- Corner radius: 16dp
- Buttons height: 52dp (primary), 44dp (secondary)

## Layout Rules
- Use MaxWidthCenter(maxWidth: 640) on web
- One primary CTA per screen (except Result cards)
- Avoid dense lists; use section titles + whitespace

## Components
- Buttons: PrimaryButton, SecondaryButton
- InfoBanner: warning/info/danger
- Cards: ActionCard, SimilarItemCard
- City selector: CityPill
