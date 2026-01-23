import "dart:typed_data";

import "vision_service.dart";
import "../models/scan_result.dart";

class MockVisionService implements VisionService {
  @override
  Future<VisionInference> infer({
    required String cityId,
    Uint8List? imageBytes,
    String? queryText,
  }) async {
    final text = (queryText ?? "").toLowerCase();
    if (text.contains("batterie") || text.contains("akku") || text.contains("battery")) {
      return VisionInference(
        itemName: "item_battery",
        category: "battery",
        confidence: ConfidenceLevel.high,
      );
    }
    if (text.contains("glas")) {
      return VisionInference(
        itemName: "item_glass",
        category: "glass",
        confidence: ConfidenceLevel.medium,
      );
    }
    if (text.contains("kabel")) {
      return VisionInference(
        itemName: "item_cable",
        category: "cable",
        confidence: ConfidenceLevel.medium,
      );
    }
    if (text.contains("plastik") || text.contains("verpack")) {
      return VisionInference(
        itemName: "item_plastic_packaging",
        category: "plastic_packaging",
        confidence: ConfidenceLevel.medium,
      );
    }

    if (imageBytes == null && text.isEmpty) {
      return VisionInference(
        itemName: null,
        category: "unknown",
        confidence: ConfidenceLevel.low,
      );
    }

    return VisionInference(
      itemName: "unknown_item",
      category: "unknown",
      confidence: ConfidenceLevel.low,
    );
  }
}
