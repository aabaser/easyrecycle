import "dart:async";
import "dart:convert";
import "dart:math";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

import "../config/api_config.dart";
import "../models/city.dart";
import "../models/scan_result.dart";

class AppState extends ChangeNotifier {
  Locale locale = const Locale("de");
  City? selectedCity;
  ScanResult? lastResult;
  String sessionId = "";
  String? authToken;
  int? authTokenExpiresAt;
  String? adminSessionToken;
  int? adminSessionExpiresAt;
  ThemeMode themeMode = ThemeMode.system;
  bool adminEnabled = false;
  int currentTabIndex = 1;
  int? _requestedTabIndex;
  bool _cameraScanRequested = false;
  String? _requestedRecycleCenterCityCode;
  int? _requestedRecycleCenterTypCode;
  String? _requestedRecycleCenterDisposalPositive;
  int _citySelectionVersion = 0;

  int get citySelectionVersion => _citySelectionVersion;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString("localeCode");
    if (localeCode == "de") {
      locale = const Locale("de");
    } else {
      locale = const Locale("de");
      if (localeCode != null && localeCode.isNotEmpty) {
        await prefs.setString("localeCode", "de");
      }
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
    adminSessionToken = prefs.getString("adminSessionToken");
    adminSessionExpiresAt = prefs.getInt("adminSessionExpiresAt");
    await prefs.remove("authTokenType");
    await prefs.remove("userId");
    await prefs.remove("userEmail");

    final storedTheme = prefs.getString("themeMode");
    if (storedTheme == "light") {
      themeMode = ThemeMode.light;
    } else if (storedTheme == "dark") {
      themeMode = ThemeMode.dark;
    }

    adminEnabled = prefs.getBool("adminEnabled") ?? false;
    currentTabIndex = prefs.getInt("currentTabIndex") ?? 1;
    unawaited(ensureGuestToken());
  }

  Future<void> setLocale(Locale newLocale) async {
    locale = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("localeCode", newLocale.languageCode);
    notifyListeners();
  }

  Future<void> setSelectedCity(City city) async {
    final previousCityId = selectedCity?.id;
    selectedCity = city;
    if (previousCityId != city.id) {
      lastResult = null;
      _requestedTabIndex = null;
      _cameraScanRequested = false;
      _citySelectionVersion++;
    }
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
    http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: const {"Content-Type": "application/json"},
            body: jsonEncode({"device_id": sessionId, "attestation": "TODO"}),
          )
          .timeout(const Duration(seconds: 4));
    } on TimeoutException {
      return;
    } catch (_) {
      return;
    }

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

  bool get hasValidAdminSession {
    final token = adminSessionToken;
    final expiresAt = adminSessionExpiresAt;
    if (token == null || token.isEmpty || expiresAt == null) {
      return false;
    }
    return expiresAt - DateTime.now().millisecondsSinceEpoch > 60000;
  }

  Future<void> setAdminSession({
    required String token,
    required int expiresInSeconds,
  }) async {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    adminSessionToken = token;
    adminSessionExpiresAt = nowMs + (expiresInSeconds * 1000);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("adminSessionToken", token);
    await prefs.setInt("adminSessionExpiresAt", adminSessionExpiresAt!);
    notifyListeners();
  }

  Future<void> clearAdminSession() async {
    adminSessionToken = null;
    adminSessionExpiresAt = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("adminSessionToken");
    await prefs.remove("adminSessionExpiresAt");
    notifyListeners();
  }

  Future<Map<String, String>> adminHeaders({
    Map<String, String>? extra,
  }) async {
    if (!hasValidAdminSession) {
      throw StateError("admin_session_missing");
    }
    final headers = <String, String>{};
    if (extra != null) {
      headers.addAll(extra);
    }
    headers["Authorization"] = "Bearer $adminSessionToken";
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

  void requestRecycleCenterFilter({
    required String cityCode,
    int? typCode,
    String? disposalPositive,
  }) {
    _requestedRecycleCenterCityCode = cityCode;
    _requestedRecycleCenterTypCode = typCode;
    _requestedRecycleCenterDisposalPositive = disposalPositive;
    notifyListeners();
  }

  ({String cityCode, int? typCode, String? disposalPositive})?
      consumeRequestedRecycleCenterFilter() {
    final cityCode = _requestedRecycleCenterCityCode;
    if (cityCode == null || cityCode.isEmpty) {
      return null;
    }
    final result = (
      cityCode: cityCode,
      typCode: _requestedRecycleCenterTypCode,
      disposalPositive: _requestedRecycleCenterDisposalPositive,
    );
    _requestedRecycleCenterCityCode = null;
    _requestedRecycleCenterTypCode = null;
    _requestedRecycleCenterDisposalPositive = null;
    return result;
  }

  String _generateSessionId() {
    final rand = Random();
    final now = DateTime.now().microsecondsSinceEpoch;
    final r = rand.nextInt(1 << 31);
    return "${now.toRadixString(16)}${r.toRadixString(16)}";
  }
}
