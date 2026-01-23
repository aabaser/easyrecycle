import "dart:typed_data";
import "../models/similar_item.dart";

abstract class SimilarityService {
  List<SimilarItem> getTop3Similar({
    required String cityId,
    Uint8List? imageBytes,
    String? queryText,
  });
}
