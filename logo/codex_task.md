# Codex Task — Fix Logo Placement (Login) + Launcher Icons

## Goal
1) Make the logo render correctly on the Login screen (no clipping, correct size).
2) Generate working Android adaptive icons + safe iOS icons.

## Add assets
Copy folder `assets/logo/` into the app repo.

Update `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/logo/
```

## Login screen (recommended)
Use constraints to avoid stretch/crop:

```dart
Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 180, maxHeight: 180),
    child: Image.asset(
      'assets/logo/app_logo_mark_512.png',
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    ),
  ),
)
```

Dark background variant:
`assets/logo/app_logo_dark_512.png`

## Launcher icons (flutter_launcher_icons)
Install:
```bash
flutter pub add --dev flutter_launcher_icons
```

Add config in `pubspec.yaml`:
```yaml
flutter_launcher_icons:
  android: true
  ios: true

  # iOS prefers opaque icons
  image_path: assets/logo/app_logo_light_1024.png
  remove_alpha_ios: true

  # Android adaptive icon
  adaptive_icon_foreground: assets/logo/ic_launcher_foreground_432.png
  adaptive_icon_background: "#F7FAFF"
```

Generate:
```bash
flutter pub get
dart run flutter_launcher_icons
```

## If icons look unchanged
- Run `flutter clean` and rebuild
- Uninstall the app from device/emulator (launchers cache icons)
