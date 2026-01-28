import "dart:convert";
import "dart:typed_data";

import "package:http/http.dart" as http;

import "../config/api_config.dart";
import "../models/admin_item.dart";
import "../models/city.dart";
import "../models/admin_image.dart";

class AdminService {
  Future<List<AdminItemSummary>> listItems({
    required String lang,
    String? query,
  }) async {
    final uri = Uri.parse(
      "${ApiConfig.baseUrl}/admin/items?lang=$lang${query != null && query.isNotEmpty ? "&q=${Uri.encodeComponent(query)}" : ""}",
    );
    final response = await http.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("admin_items_failed");
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    final items = (body["items"] as List<dynamic>? ?? []);
    return items.map((entry) {
      final item = entry as Map<String, dynamic>;
      return AdminItemSummary(
        id: item["id"]?.toString() ?? "",
        canonicalKey: item["canonical_key"]?.toString() ?? "",
        title: item["title"]?.toString(),
        description: item["description"]?.toString(),
        primaryImageId: item["primary_image_id"]?.toString(),
        imageUrl: item["image_url"]?.toString(),
        isActive: item["is_active"] as bool? ?? true,
      );
    }).toList();
  }

  Future<AdminItemDetail> getItem({
    required String itemId,
    required String cityId,
    required String lang,
  }) async {
    final uri = Uri.parse(
      "${ApiConfig.baseUrl}/admin/items/$itemId?city=$cityId&lang=$lang",
    );
    final response = await http.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("admin_item_failed");
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    return _parseDetail(body);
  }

  Future<AdminOptions> getOptions({required String lang, String? cityId}) async {
    final cityParam = cityId != null && cityId.isNotEmpty
        ? "&city=${Uri.encodeComponent(cityId)}"
        : "";
    final uri = Uri.parse("${ApiConfig.baseUrl}/admin/options?lang=$lang$cityParam");
    final response = await http.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("admin_options_failed");
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    return AdminOptions(
      categories: _parseCodeLabelList(body["categories"]),
      disposals: _parseCodeLabelList(body["disposals"]),
      warnings: _parseCodeLabelList(body["warnings"]),
    );
  }

  Future<AdminItemDetail> updateItem({
    required String itemId,
    required String cityId,
    required String lang,
    String? title,
    String? description,
    List<String>? categoryCodes,
    List<String>? disposalCodes,
    List<String>? warningCodes,
    String? primaryImageId,
    bool? isActive,
  }) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/admin/items/$itemId");
    final response = await http.put(
      uri,
      headers: const {"Content-Type": "application/json"},
      body: json.encode({
        "city": cityId,
        "lang": lang,
        "title": title,
        "description": description,
        "category_codes": categoryCodes,
        "disposal_codes": disposalCodes,
        "warning_codes": warningCodes,
        "primary_image_id": primaryImageId,
        "is_active": isActive,
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("admin_update_failed");
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    return _parseDetail(body);
  }

  Future<List<AdminImageAsset>> listImages({int limit = 50}) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/admin/images?limit=$limit");
    final response = await http.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("admin_images_failed");
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    final images = (body["images"] as List<dynamic>? ?? []);
    return images.map((entry) {
      final item = entry as Map<String, dynamic>;
      return AdminImageAsset(
        imageId: item["image_id"]?.toString() ?? "",
        imageUrl: item["image_url"]?.toString() ?? "",
        width: item["width"] as int?,
        height: item["height"] as int?,
        source: item["source"]?.toString(),
        createdAt: item["created_at"]?.toString(),
        isPrimary: item["is_primary"] as bool? ?? false,
      );
    }).toList();
  }

  Future<List<City>> listCities({required String lang}) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/admin/cities?lang=$lang");
    final response = await http.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("admin_cities_failed");
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    final cities = (body["cities"] as List<dynamic>? ?? []);
    return cities.map((entry) {
      final item = entry as Map<String, dynamic>;
      return City(
        id: item["code"]?.toString() ?? "",
        name: item["label"]?.toString() ?? "",
      );
    }).toList();
  }

  Future<List<AdminImageAsset>> listItemImages(String itemId) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/admin/items/$itemId/images");
    final response = await http.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("admin_item_images_failed");
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    final images = (body["images"] as List<dynamic>? ?? []);
    return images.map((entry) {
      final item = entry as Map<String, dynamic>;
      return AdminImageAsset(
        imageId: item["image_id"]?.toString() ?? "",
        imageUrl: item["image_url"]?.toString() ?? "",
        width: item["width"] as int?,
        height: item["height"] as int?,
        source: item["source"]?.toString(),
        createdAt: item["created_at"]?.toString(),
        isPrimary: item["is_primary"] as bool? ?? false,
      );
    }).toList();
  }

  Future<AdminImageAsset> uploadItemImage({
    required String itemId,
    required String cityId,
    required Uint8List bytes,
  }) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/admin/items/$itemId/images");
    final response = await http.post(
      uri,
      headers: const {"Content-Type": "application/json"},
      body: json.encode({
        "city": cityId,
        "image_base64": base64Encode(bytes),
        "source": "admin",
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("admin_item_image_upload_failed");
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    return AdminImageAsset(
      imageId: body["image_id"]?.toString() ?? "",
      imageUrl: body["image_url"]?.toString() ?? "",
      width: null,
      height: null,
      source: "admin",
      createdAt: null,
      isPrimary: false,
    );
  }

  Future<void> deleteItemImage({
    required String itemId,
    required String imageId,
  }) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/admin/items/$itemId/images/$imageId");
    final response = await http.delete(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("admin_item_image_delete_failed");
    }
  }

  Future<AdminImageAsset> uploadImage(Uint8List bytes) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/admin/images");
    final response = await http.post(
      uri,
      headers: const {"Content-Type": "application/json"},
      body: json.encode({
        "image_base64": base64Encode(bytes),
        "source": "admin",
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("admin_upload_failed");
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    return AdminImageAsset(
      imageId: body["image_id"]?.toString() ?? "",
      imageUrl: body["image_url"]?.toString() ?? "",
      width: null,
      height: null,
      source: "admin",
      createdAt: null,
      isPrimary: false,
    );
  }

  AdminItemDetail _parseDetail(Map<String, dynamic> body) {
    final item = body["item"] as Map<String, dynamic>;
    final categories = (body["categories"] as List<dynamic>? ?? [])
        .map((entry) => _parseCodeLabel(entry))
        .toList();
    final disposals = (body["disposals"] as List<dynamic>? ?? [])
        .map((entry) => _parseCodeLabel(entry))
        .toList();
    final warnings = (body["warnings"] as List<dynamic>? ?? [])
        .map((entry) => _parseCodeLabel(entry))
        .toList();
    return AdminItemDetail(
      item: AdminItemSummary(
        id: item["id"]?.toString() ?? "",
        canonicalKey: item["canonical_key"]?.toString() ?? "",
        title: item["title"]?.toString(),
        description: item["description"]?.toString(),
        primaryImageId: item["primary_image_id"]?.toString(),
        imageUrl: item["image_url"]?.toString(),
        isActive: item["is_active"] as bool? ?? true,
      ),
      categories: categories,
      disposals: disposals,
      warnings: warnings,
    );
  }

  AdminCodeLabel _parseCodeLabel(dynamic entry) {
    if (entry is Map<String, dynamic>) {
      return AdminCodeLabel(
        code: entry["code"]?.toString() ?? "",
        label: entry["label"]?.toString(),
      );
    }
    return AdminCodeLabel(code: entry.toString(), label: null);
  }

  List<AdminCodeLabel> _parseCodeLabelList(dynamic data) {
    final list = data as List<dynamic>? ?? [];
    return list.map((entry) => _parseCodeLabel(entry)).toList();
  }
}
