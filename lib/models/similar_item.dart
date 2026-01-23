import "scan_result.dart";

class SimilarItem {
  SimilarItem({
    required this.itemId,
    required this.itemTitle,
    required this.aliasTitle,
    required this.confidence,
    required this.hintCategory,
    required this.disposalLabels,
  });

  final String? itemId;
  final String itemTitle;
  final String? aliasTitle;
  final ConfidenceLevel confidence;
  final String hintCategory;
  final List<String> disposalLabels;
}
