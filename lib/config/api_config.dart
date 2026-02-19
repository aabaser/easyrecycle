class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "http://192.168.2.177:8000",
  );

  static const String adminApiKey = String.fromEnvironment(
    "ADMIN_API_KEY",
    defaultValue: "",
  );
}
