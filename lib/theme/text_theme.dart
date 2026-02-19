import "package:flutter/material.dart";

TextTheme buildAppTextTheme(ColorScheme colorScheme) {
  const fontFamily = "Jost";
  return TextTheme(
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 36,
      fontWeight: FontWeight.w800,
      height: 1.1,
      letterSpacing: -0.6,
      color: colorScheme.onSurface,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -0.4,
      color: colorScheme.onSurface,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.3,
      color: colorScheme.onSurface,
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.3,
      color: colorScheme.onSurface,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.3,
      color: colorScheme.onSurface,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.35,
      color: colorScheme.onSurface,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.6,
      color: colorScheme.onSurface,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.55,
      color: colorScheme.onSurfaceVariant,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: colorScheme.onSurfaceVariant,
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: colorScheme.onSurface,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: colorScheme.onSurfaceVariant,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: colorScheme.onSurfaceVariant,
    ),
  );
}
