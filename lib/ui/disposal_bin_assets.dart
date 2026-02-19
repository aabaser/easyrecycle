import "package:flutter/material.dart";

String _normalizeDisposal(String raw) {
  return raw
      .toLowerCase()
      .replaceAll("ä", "ae")
      .replaceAll("ö", "oe")
      .replaceAll("ü", "ue")
      .replaceAll("ß", "ss")
      .replaceAll(RegExp(r"[^a-z0-9_]"), "");
}

String? _binToneFor(String normalized) {
  final brown = {
    "laub_und_garten_tonne",
    "biotonne",
    "biogut_tonne",
  };
  final blue = {
    "altpapiersack",
    "altpapiertonne",
    "papier_tonne",
  };
  final yellow = {
    "gelbe_tonne",
    "wertstoff_tonne",
  };
  final gray = {
    "restabfalltonne",
    "restabfall_tonne",
  };

  bool match(Set<String> values) =>
      values.any((v) => normalized == v || normalized.contains(v));

  if (match(brown)) {
    return "braun";
  }
  if (match(blue)) {
    return "blue";
  }
  if (match(yellow)) {
    return "yellow";
  }
  if (match(gray)) {
    return "gray";
  }
  return null;
}

String? disposalBinAssetFor(String value, Brightness brightness) {
  final tone = _binToneFor(_normalizeDisposal(value));
  if (tone == null) {
    return null;
  }

  // Brown currently has only non-bold file.
  if (brightness == Brightness.dark && tone != "braun") {
    return "assets/Easy Recycle Images/recycle-bin-$tone-bold.png";
  }
  return "assets/Easy Recycle Images/recycle-bin-$tone.png";
}
