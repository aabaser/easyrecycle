import "package:flutter/material.dart";

enum DisposalBinStyle { outline, solid }

String _normalizeDisposal(String raw) {
  return raw
      .toLowerCase()
      .replaceAll("\u00e4", "ae")
      .replaceAll("\u00f6", "oe")
      .replaceAll("\u00fc", "ue")
      .replaceAll("\u00df", "ss")
      .replaceAll(RegExp(r"[^a-z0-9]+"), "_")
      .replaceAll(RegExp(r"_+"), "_")
      .replaceAll(RegExp(r"^_+|_+$"), "");
}

String? _binToneFor(String normalized) {
  const brown = {
    "laub_und_garten_tonne",
    "biotonne",
    "biogut_tonne",
  };
  const blue = {
    "altpapiersack",
    "altpapiertonne",
    "papier_tonne",
  };
  const yellow = {
    "gelbe_tonne",
    "wertstoff_tonne",
  };
  const gray = {
    "restabfalltonne",
    "restabfall_tonne",
  };

  bool match(Set<String> values) =>
      values.any((v) => normalized == v || normalized.contains(v));

  if (match(brown)) {
    return "brown";
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

String? disposalBinToneFor(String value) {
  return _binToneFor(_normalizeDisposal(value));
}

String disposalBinAssetForTone(
  String tone, {
  required DisposalBinStyle style,
}) {
  final suffix = switch (style) {
    DisposalBinStyle.outline => "outline",
    DisposalBinStyle.solid => "solid",
  };
  return "assets/easy_recycle_images/recycle-bin-$tone-$suffix.png";
}

String? disposalBinAssetFor(String value, Brightness brightness) {
  final tone = disposalBinToneFor(value);
  if (tone == null) {
    return null;
  }
  final style = brightness == Brightness.dark
      ? DisposalBinStyle.outline
      : DisposalBinStyle.solid;
  return disposalBinAssetForTone(tone, style: style);
}

bool isMappedDisposalType(String value) {
  return disposalBinToneFor(value) != null;
}
