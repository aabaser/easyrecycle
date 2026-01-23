import "dart:math";

import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../models/city.dart";
import "../models/scan_result.dart";

class AppState extends ChangeNotifier {
  Locale locale = const Locale("de");
  City? selectedCity;
  ScanResult? lastResult;
  String sessionId = "";
  ThemeMode themeMode = ThemeMode.system;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString("localeCode");
    if (localeCode != null && localeCode.isNotEmpty) {
      locale = Locale(localeCode);
    }

    final cityId = prefs.getString("selectedCityId");
    if (cityId != null && cityId.isNotEmpty) {
      selectedCity = City(id: cityId, name: cityId);
    }

    final storedSessionId = prefs.getString("sessionId");
    if (storedSessionId != null && storedSessionId.isNotEmpty) {
      sessionId = storedSessionId;
    } else {
      sessionId = _generateSessionId();
      await prefs.setString("sessionId", sessionId);
    }

    final storedTheme = prefs.getString("themeMode");
    if (storedTheme == "light") {
      themeMode = ThemeMode.light;
    } else if (storedTheme == "dark") {
      themeMode = ThemeMode.dark;
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    locale = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("localeCode", newLocale.languageCode);
    notifyListeners();
  }

  Future<void> setSelectedCity(City city) async {
    selectedCity = city;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedCityId", city.id);
    notifyListeners();
  }

  void setLastResult(ScanResult? result) {
    lastResult = result;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    if (mode == ThemeMode.light) {
      await prefs.setString("themeMode", "light");
    } else if (mode == ThemeMode.dark) {
      await prefs.setString("themeMode", "dark");
    } else {
      await prefs.remove("themeMode");
    }
    notifyListeners();
  }

  String _generateSessionId() {
    final rand = Random();
    final now = DateTime.now().microsecondsSinceEpoch;
    final r = rand.nextInt(1 << 31);
    return "${now.toRadixString(16)}${r.toRadixString(16)}";
  }
}
