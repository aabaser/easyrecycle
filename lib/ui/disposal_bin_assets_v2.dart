import "package:flutter/material.dart";

String _normalizeDisposal(String raw) {
  return raw
      .toLowerCase()
      .replaceAll("\u00e4", "ae")
      .replaceAll("\u00f6", "oe")
      .replaceAll("\u00fc", "ue")
      .replaceAll("\u00df", "ss")
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

  // Prefer bold assets on all themes when available.
  if (tone == "gray") {
    return "assets/easy_recycle_images/recycle-bin_gray-bold.png";
  }
  if (tone == "blue" || tone == "yellow") {
    return "assets/easy_recycle_images/recycle-bin-$tone-bold.png";
  }
  // Brown currently has no bold variant.
  return "assets/easy_recycle_images/recycle-bin-$tone.png";
}

bool isMappedDisposalType(String value) {
  return _binToneFor(_normalizeDisposal(value)) != null;
}
