import "package:flutter/material.dart";

class L10n {
  static const supportedLocales = [
    Locale("de"),
    Locale("tr"),
    Locale("en"),
  ];

  static Locale resolve(Locale? locale, Iterable<Locale> supported) {
    if (locale == null) {
      return const Locale("de");
    }
    for (final candidate in supportedLocales) {
      if (candidate.languageCode == locale.languageCode) {
        return candidate;
      }
    }
    return const Locale("de");
  }

  static bool isSupported(Locale locale) {
    return supportedLocales
        .any((element) => element.languageCode == locale.languageCode);
  }
}
