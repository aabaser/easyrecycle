import "dart:math";
import "dart:convert";

import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:http/http.dart" as http;

import "../models/city.dart";
import "../models/scan_result.dart";
import "../config/api_config.dart";

class AppState extends ChangeNotifier {
  Locale locale = const Locale("de");
  City? selectedCity;
  ScanResult? lastResult;
  String sessionId = "";
  String? authToken;
  int? authTokenExpiresAt;
  ThemeMode themeMode = ThemeMode.system;
  bool adminEnabled = false;
  int currentTabIndex = 1;
  int? _requestedTabIndex;
  bool _cameraScanRequested = false;

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

    authToken = prefs.getString("authToken");
    authTokenExpiresAt = prefs.getInt("authTokenExpiresAt");

    final storedTheme = prefs.getString("themeMode");
    if (storedTheme == "light") {
      themeMode = ThemeMode.light;
    } else if (storedTheme == "dark") {
      themeMode = ThemeMode.dark;
    }

    adminEnabled = prefs.getBool("adminEnabled") ?? false;
    currentTabIndex = prefs.getInt("currentTabIndex") ?? 1;
    await ensureGuestToken();
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

  Future<void> ensureGuestToken() async {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if (authToken != null &&
        authTokenExpiresAt != null &&
        authTokenExpiresAt! - nowMs > 60000) {
      return;
    }

    if (sessionId.isEmpty) {
      sessionId = _generateSessionId();
    }

    final uri = Uri.parse("${ApiConfig.baseUrl}/auth/guest");
    final response = await http.post(
      uri,
      headers: const {"Content-Type": "application/json"},
      body: jsonEncode({"device_id": sessionId, "attestation": "TODO"}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return;
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final token = body["access_token"]?.toString();
    final expiresIn = body["expires_in"] as int? ?? 900;
    if (token == null || token.isEmpty) {
      return;
    }
    authToken = token;
    authTokenExpiresAt = nowMs + (expiresIn * 1000);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("authToken", token);
    await prefs.setInt("authTokenExpiresAt", authTokenExpiresAt!);
  }

  Future<Map<String, String>> authHeaders({
    Map<String, String>? extra,
  }) async {
    await ensureGuestToken();
    final headers = <String, String>{};
    if (extra != null) {
      headers.addAll(extra);
    }
    if (authToken != null && authToken!.isNotEmpty) {
      headers["Authorization"] = "Bearer $authToken";
    }
    return headers;
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

  Future<void> setAdminEnabled(bool value) async {
    adminEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("adminEnabled", value);
    notifyListeners();
  }

  Future<void> setCurrentTabIndex(int index) async {
    currentTabIndex = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("currentTabIndex", index);
    notifyListeners();
  }

  void requestTab(int index) {
    _requestedTabIndex = index;
    notifyListeners();
  }

  int? consumeRequestedTab() {
    final value = _requestedTabIndex;
    _requestedTabIndex = null;
    return value;
  }

  void requestCameraScan() {
    _cameraScanRequested = true;
    notifyListeners();
  }

  bool consumeCameraScanRequest() {
    if (_cameraScanRequested) {
      _cameraScanRequested = false;
      return true;
    }
    return false;
  }

  String _generateSessionId() {
    final rand = Random();
    final now = DateTime.now().microsecondsSinceEpoch;
    final r = rand.nextInt(1 << 31);
    return "${now.toRadixString(16)}${r.toRadixString(16)}";
  }
}
