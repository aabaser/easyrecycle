import "package:flutter/material.dart";
import "app_colors.dart";
import "design_tokens.dart";

class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryBlue,
      onPrimary: AppColors.inkDark,
      primaryContainer: const Color(0xFFDDE6FF),
      onPrimaryContainer: AppColors.inkLight,
      secondary: AppColors.primaryIndigo,
      onSecondary: AppColors.inkDark,
      secondaryContainer: const Color(0xFFE0E7FF),
      onSecondaryContainer: AppColors.inkLight,
      tertiary: AppColors.accentCyan,
      onTertiary: AppColors.inkLight,
      tertiaryContainer: const Color(0xFFCFFAFE),
      onTertiaryContainer: AppColors.inkLight,
      error: AppColors.error,
      onError: AppColors.inkDark,
      errorContainer: const Color(0xFFFEE2E2),
      onErrorContainer: AppColors.inkLight,
      background: AppColors.bgLight,
      onBackground: AppColors.inkLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.inkLight,
      surfaceVariant: AppColors.surfaceVariant(Brightness.light),
      onSurfaceVariant: AppColors.textSecondary(Brightness.light),
      outline: AppColors.border(Brightness.light),
      outlineVariant: AppColors.border(Brightness.light),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.surfaceDark,
      onInverseSurface: AppColors.inkDark,
      inversePrimary: AppColors.primaryIndigo,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.appBackground(Brightness.light),
      canvasColor: colorScheme.surface,
      dialogBackgroundColor: colorScheme.surface,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: AppColors.accentCyan.withOpacity(0.25),
      ),
      textTheme: TextTheme(
        titleLarge: DesignTokens.titleL.copyWith(color: colorScheme.onSurface),
        titleMedium: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
        bodyLarge: DesignTokens.body.copyWith(color: colorScheme.onSurface),
        bodyMedium: DesignTokens.body.copyWith(color: colorScheme.onSurface),
        bodySmall: DesignTokens.caption.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelLarge: DesignTokens.button.copyWith(color: colorScheme.onSurface),
        labelSmall: DesignTokens.caption.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
          borderSide: BorderSide(color: AppColors.focus(Brightness.light)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.cardPadding,
          vertical: 14,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        labelStyle: DesignTokens.caption.copyWith(color: colorScheme.onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        contentTextStyle: DesignTokens.body.copyWith(color: colorScheme.onSurface),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryBlue,
      onPrimary: AppColors.inkDark,
      primaryContainer: const Color(0xFF1D2A44),
      onPrimaryContainer: AppColors.inkDark,
      secondary: AppColors.primaryIndigo,
      onSecondary: AppColors.inkDark,
      secondaryContainer: const Color(0xFF232B54),
      onSecondaryContainer: AppColors.inkDark,
      tertiary: AppColors.accentCyan,
      onTertiary: AppColors.inkLight,
      tertiaryContainer: const Color(0xFF0B3D4A),
      onTertiaryContainer: AppColors.inkDark,
      error: AppColors.error,
      onError: AppColors.inkDark,
      errorContainer: const Color(0xFF4B1D1D),
      onErrorContainer: AppColors.inkDark,
      background: AppColors.bgDark,
      onBackground: AppColors.inkDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.inkDark,
      surfaceVariant: AppColors.surfaceVariant(Brightness.dark),
      onSurfaceVariant: AppColors.textSecondary(Brightness.dark),
      outline: AppColors.border(Brightness.dark),
      outlineVariant: AppColors.border(Brightness.dark),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.surfaceLight,
      onInverseSurface: AppColors.inkLight,
      inversePrimary: AppColors.primaryIndigo,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.appBackground(Brightness.dark),
      canvasColor: colorScheme.surface,
      dialogBackgroundColor: colorScheme.surface,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: AppColors.accentCyan.withOpacity(0.25),
      ),
      textTheme: TextTheme(
        titleLarge: DesignTokens.titleL.copyWith(color: colorScheme.onSurface),
        titleMedium: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
        bodyLarge: DesignTokens.body.copyWith(color: colorScheme.onSurface),
        bodyMedium: DesignTokens.body.copyWith(color: colorScheme.onSurface),
        bodySmall: DesignTokens.caption.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        labelLarge: DesignTokens.button.copyWith(color: colorScheme.onSurface),
        labelSmall: DesignTokens.caption.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
          borderSide: BorderSide(color: AppColors.focus(Brightness.dark)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.cardPadding,
          vertical: 14,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        labelStyle: DesignTokens.caption.copyWith(color: colorScheme.onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        contentTextStyle: DesignTokens.body.copyWith(color: colorScheme.onSurface),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
