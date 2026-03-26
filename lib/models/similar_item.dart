import "recycle_center_link.dart";
import "scan_result.dart";

class SimilarItem {
  SimilarItem({
    required this.itemId,
    required this.itemTitle,
    required this.aliasTitle,
    required this.confidence,
    required this.hintCategory,
    required this.disposalLabels,
    this.disposalCodes = const [],
    this.recycleCenterLinks = const [],
    this.disposalTagLinks = const [],
    this.imageUrl,
  });

  final String? itemId;
  final String itemTitle;
  final String? aliasTitle;
  final ConfidenceLevel confidence;
  final String hintCategory;
  final List<String> disposalLabels;
  final List<String> disposalCodes;
  final List<RecycleCenterLink> recycleCenterLinks;
  final List<RecycleCenterLink> disposalTagLinks;
  final String? imageUrl;
}
