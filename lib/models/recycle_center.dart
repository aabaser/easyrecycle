class RecycleCenter {
  RecycleCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    this.typCode,
    this.typLabel,
    this.hasGlas,
    this.hasKleider,
    this.hasPapier,
    this.distanceKm,
  });

  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final int? typCode;
  final String? typLabel;
  final bool? hasGlas;
  final bool? hasKleider;
  final bool? hasPapier;
  final double? distanceKm;

  factory RecycleCenter.fromJson(Map<String, dynamic> json) {
    return RecycleCenter(
      id: json["id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      address: json["address"]?.toString() ?? "",
      lat: _toDouble(json["lat"]) ?? 0,
      lng: _toDouble(json["lng"]) ?? 0,
      typCode: _toInt(json["typ_code"]),
      typLabel: json["typ_label"]?.toString(),
      hasGlas: _toBool(json["has_glas"]),
      hasKleider: _toBool(json["has_kleider"]),
      hasPapier: _toBool(json["has_papier"]),
      distanceKm: _toDouble(json["distance_km"]),
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

  static double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  static bool? _toBool(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value;
    }
    final lowered = value.toString().toLowerCase();
    if ({"true", "1", "yes", "y"}.contains(lowered)) {
      return true;
    }
    if ({"false", "0", "no", "n"}.contains(lowered)) {
      return false;
    }
    return null;
  }
}
