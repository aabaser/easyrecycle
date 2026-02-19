import "dart:typed_data";

class ScanInput {
  ScanInput({
    required this.cityId,
    required this.imageBytes,
    required this.queryText,
  });

  final String cityId;
  final Uint8List? imageBytes;
  final String? queryText;
}
