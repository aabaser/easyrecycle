class AdminImageAsset {
  const AdminImageAsset({
    required this.imageId,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.source,
    required this.createdAt,
    required this.isPrimary,
  });

  final String imageId;
  final String imageUrl;
  final int? width;
  final int? height;
  final String? source;
  final String? createdAt;
  final bool isPrimary;
}
