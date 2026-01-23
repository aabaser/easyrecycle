import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/services.dart";

class AppLocalizations {
  AppLocalizations(this.locale, this._strings);

  final Locale locale;
  final Map<String, String> _strings;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localization = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    if (localization == null) {
      throw StateError("AppLocalizations not found");
    }
    return localization;
  }

  String t(String key) {
    return _strings[key] ?? key;
  }

  bool hasKey(String key) {
    return _strings.containsKey(key);
  }

  static Future<AppLocalizations> load(Locale locale) async {
    final code = locale.languageCode;
    final path = "lib/l10n/arb/app_${code}.arb";
    final raw = await rootBundle.loadString(path);
    final jsonMap = json.decode(raw) as Map<String, dynamic>;

    final strings = <String, String>{};
    jsonMap.forEach((key, value) {
      if (!key.startsWith("@")) {
        strings[key] = value.toString();
      }
    });

    return AppLocalizations(locale, strings);
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ["de", "tr", "en"].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
