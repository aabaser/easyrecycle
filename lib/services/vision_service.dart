import "dart:typed_data";
import "../models/scan_result.dart";

class VisionInference {
  VisionInference({
    required this.itemName,
    required this.category,
    required this.confidence,
  });

  final String? itemName;
  final String category;
  final ConfidenceLevel confidence;
}

abstract class VisionService {
  Future<VisionInference> infer({
    required String cityId,
    Uint8List? imageBytes,
    String? queryText,
  });
}
