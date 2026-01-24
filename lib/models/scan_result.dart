import "dart:typed_data";

import "action_option.dart";
import "warning.dart";
import "similar_item.dart";

enum ScanState { found, notFound }

enum ConfidenceLevel { high, medium, low }

enum SearchMode { text, image, unknown }

class ScanResult {
  ScanResult({
    this.itemId,
    required this.state,
    required this.itemName,
    required this.confidence,
    required this.description,
    required this.disposalMethod,
    required this.disposalSteps,
    required this.categories,
    required this.disposalLabels,
    required this.bestOption,
    required this.otherOptions,
    required this.warnings,
    required this.similarItems,
    required this.imageBytes,
    this.imageUrl,
    required this.searchMode,
    required this.queryText,
  });

  final ScanState state;
  final String? itemId;
  final String? itemName;
  final ConfidenceLevel confidence;
  final String? description;
  final String? disposalMethod;
  final List<String> disposalSteps;
  final List<String> categories;
  final List<String> disposalLabels;
  final ActionOption? bestOption;
  final List<ActionOption> otherOptions;
  final List<Warning> warnings;
  final List<SimilarItem> similarItems;
  final Uint8List? imageBytes;
  final String? imageUrl;
  final SearchMode searchMode;
  final String? queryText;
}
