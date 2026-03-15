import "package:flutter/foundation.dart";

class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "http://192.168.2.177:8000",
  );

  static const String _adminApiKeyRaw = String.fromEnvironment(
    "ADMIN_API_KEY",
    defaultValue: "",
  );

  static String get adminApiKey => kReleaseMode ? "" : _adminApiKeyRaw;
}
