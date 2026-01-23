import "package:flutter/material.dart";

class AppColors {
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryIndigo = Color(0xFF4338CA);
  static const Color accentCyan = Color(0xFF22D3EE);

  static const Color bgLight = Color(0xFFF7FAFF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color inkLight = Color(0xFF0B1220);

  static const Color bgDark = Color(0xFF0B1220);
  static const Color surfaceDark = Color(0xFF111B2E);
  static const Color inkDark = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF38BDF8);

  static Color appBackground(Brightness brightness) {
    return brightness == Brightness.dark ? bgDark : bgLight;
  }

  static Color surface(Brightness brightness) {
    return brightness == Brightness.dark ? surfaceDark : surfaceLight;
  }

  static Color surfaceVariant(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF1A2842)
        : const Color(0xFFEAF0FA);
  }

  static Color border(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF233252)
        : const Color(0xFFD6DFEE);
  }

  static Color textPrimary(Brightness brightness) {
    return brightness == Brightness.dark ? inkDark : inkLight;
  }

  static Color textSecondary(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFFB8C2D7)
        : const Color(0xFF4B5563);
  }

  static Color iconDefault(Brightness brightness) {
    return textSecondary(brightness);
  }

  static Color focus(Brightness brightness) {
    return brightness == Brightness.dark ? accentCyan : primaryBlue;
  }
}
