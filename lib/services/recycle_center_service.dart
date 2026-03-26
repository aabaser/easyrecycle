import "dart:convert";

import "package:http/http.dart" as http;

import "../config/api_config.dart";
import "../models/recycle_center.dart";
import "../state/app_state.dart";

class RecycleCenterService {
  static Future<List<RecycleCenter>> fetchCenters({
    required AppState appState,
    required String cityCode,
    double? lat,
    double? lng,
    int? typCode,
    String? disposalPositive,
    int limit = 1000,
  }) async {
    final query = <String, String>{"city": cityCode, "limit": "$limit"};
    if (lat != null && lng != null) {
      query["lat"] = lat.toString();
      query["lng"] = lng.toString();
    }
    if (typCode != null) {
      query["typ_code"] = "$typCode";
    }
    if (disposalPositive != null && disposalPositive.trim().isNotEmpty) {
      query["disposal_positive"] = disposalPositive.trim();
    }
    final uri = Uri.parse("${ApiConfig.baseUrl}/recycle-centers")
        .replace(queryParameters: query);
    final headers = await appState.authHeaders();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("recycle_centers_failed");
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final centersRaw = (body["centers"] as List<dynamic>? ?? []);
    return centersRaw
        .whereType<Map<String, dynamic>>()
        .map(RecycleCenter.fromJson)
        .toList();
  }
}
