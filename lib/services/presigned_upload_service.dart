import "dart:convert";

import "package:http/http.dart" as http;
import "package:flutter/foundation.dart";

import "../config/api_config.dart";
import "../state/app_state.dart";

class PresignedUploadResult {
  PresignedUploadResult({
    required this.uploadUrl,
    required this.s3Key,
    required this.contentType,
  });

  final String uploadUrl;
  final String s3Key;
  final String contentType;
}

class PresignedUploadService {
  static const List<int> _pngMagic = [
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A
  ];

  static String detectContentType(Uint8List bytes) {
    if (bytes.length >= _pngMagic.length) {
      var isPng = true;
      for (var i = 0; i < _pngMagic.length; i++) {
        if (bytes[i] != _pngMagic[i]) {
          isPng = false;
          break;
        }
      }
      if (isPng) {
        return "image/png";
      }
    }
    return "image/jpeg";
  }

  static String _extForContentType(String contentType) {
    if (contentType == "image/png") {
      return "png";
    }
    return "jpg";
  }

  static Future<PresignedUploadResult> presign({
    required AppState appState,
    required String contentType,
  }) async {
    final uri = Uri.parse("${ApiConfig.baseUrl}/uploads/presign");
    debugPrint("presign: request content_type=$contentType url=$uri");
    final headers = await appState.authHeaders(
      extra: const {"Content-Type": "application/json"},
    );
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        "content_type": contentType,
        "file_ext": _extForContentType(contentType),
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint(
          "presign: failed status=${response.statusCode} body=${response.body}");
      throw Exception("presign_failed");
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final uploadUrl = body["upload_url"]?.toString();
    final s3Key = body["s3_key"]?.toString();
    if (uploadUrl == null ||
        uploadUrl.isEmpty ||
        s3Key == null ||
        s3Key.isEmpty) {
      debugPrint("presign: invalid response body=$body");
      throw Exception("presign_invalid");
    }
    debugPrint("presign: ok s3_key=$s3Key");
    return PresignedUploadResult(
      uploadUrl: uploadUrl,
      s3Key: s3Key,
      contentType: contentType,
    );
  }

  static Future<void> upload({
    required PresignedUploadResult presign,
    required Uint8List bytes,
  }) async {
    debugPrint(
      "upload: put bytes=${bytes.length} to s3_key=${presign.s3Key} content_type=${presign.contentType}",
    );
    final response = await http.put(
      Uri.parse(presign.uploadUrl),
      headers: {"Content-Type": presign.contentType},
      body: bytes,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint(
          "upload: failed status=${response.statusCode} body=${response.body}");
      throw Exception("upload_failed");
    }
    debugPrint("upload: ok");
  }
}
