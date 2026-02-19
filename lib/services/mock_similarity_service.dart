import "dart:math";
import "dart:typed_data";
import "../models/similar_item.dart";
import "../models/scan_result.dart";
import "similarity_service.dart";

class MockSimilarityService implements SimilarityService {
  @override
  List<SimilarItem> getTop3Similar({
    required String cityId,
    Uint8List? imageBytes,
    String? queryText,
  }) {
    final items = [
      SimilarItem(
        itemId: null,
        itemTitle: "item_battery",
        aliasTitle: "item_battery",
        confidence: ConfidenceLevel.high,
        hintCategory: "battery",
        disposalLabels: const ["Wertstoffhof"],
      ),
      SimilarItem(
        itemId: null,
        itemTitle: "item_cable",
        aliasTitle: "item_cable",
        confidence: ConfidenceLevel.medium,
        hintCategory: "cable",
        disposalLabels: const ["Elektroschrott"],
      ),
      SimilarItem(
        itemId: null,
        itemTitle: "item_glass",
        aliasTitle: "item_glass",
        confidence: ConfidenceLevel.low,
        hintCategory: "glass",
        disposalLabels: const ["Altglas"],
      ),
    ];

    final seed = (queryText ?? "").hashCode;
    final random = Random(seed);
    items.shuffle(random);
    return items.take(3).toList();
  }
}
