class RecycleCenterLink {
  const RecycleCenterLink({
    required this.label,
    this.typCode,
    this.disposalCode,
    this.disposalPositive,
  });

  final String label;
  final int? typCode;
  final String? disposalCode;
  final String? disposalPositive;

  bool get isActionable =>
      (typCode != null && typCode! > 0) ||
      (disposalPositive != null && disposalPositive!.trim().isNotEmpty);

  factory RecycleCenterLink.fromJson(
    Map<String, dynamic> json, {
    required String cityCode,
  }) {
    final typCode = _toInt(json["recycle_center_typ_code"]);
    final label = (json["label"] ?? json["code"] ?? "").toString().trim();
    return RecycleCenterLink(
      label: label,
      typCode: typCode,
      disposalCode: json["code"]?.toString(),
      disposalPositive: typCode == null && cityCode == "berlin" ? label : null,
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }
}
