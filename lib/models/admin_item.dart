class AdminCodeLabel {
  const AdminCodeLabel({required this.code, required this.label});

  final String code;
  final String? label;
}

class AdminItemSummary {
  const AdminItemSummary({
    required this.id,
    required this.canonicalKey,
    required this.title,
    required this.description,
    required this.primaryImageId,
    required this.imageUrl,
    required this.isActive,
  });

  final String id;
  final String canonicalKey;
  final String? title;
  final String? description;
  final String? primaryImageId;
  final String? imageUrl;
  final bool isActive;
}

class AdminItemDetail {
  const AdminItemDetail({
    required this.item,
    required this.categories,
    required this.disposals,
    required this.warnings,
  });

  final AdminItemSummary item;
  final List<AdminCodeLabel> categories;
  final List<AdminCodeLabel> disposals;
  final List<AdminCodeLabel> warnings;
}
