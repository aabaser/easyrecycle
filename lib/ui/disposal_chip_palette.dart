import "package:flutter/material.dart";

class DisposalChipPalette {
  const DisposalChipPalette({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}

String _normalizeDisposalCode(String raw) {
  final normalized = raw
      .toLowerCase()
      .replaceAll("\u00e4", "ae")
      .replaceAll("\u00f6", "oe")
      .replaceAll("\u00fc", "ue")
      .replaceAll("\u00df", "ss")
      .replaceAll(RegExp(r"[^a-z0-9]+"), "_")
      .replaceAll(RegExp(r"_+"), "_")
      .replaceAll(RegExp(r"^_+|_+$"), "");
  return normalized;
}

String _toneForDisposal(String raw) {
  final code = _normalizeDisposalCode(raw);
  const recycleTypeTones = {
    "recycle_type_1": "emerald",
    "recycle_type_2": "slate",
    "recycle_type_3": "olive",
    "recycle_type_5": "sky",
  };
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

  bool matches(Set<String> values) =>
      values.any((v) => code == v || code.contains(v));

  final recycleTone = recycleTypeTones[code];
  if (recycleTone != null) {
    return recycleTone;
  }
  if (matches(brown)) {
    return "brown";
  }
  if (matches(blue)) {
    return "blue";
  }
  if (matches(yellow)) {
    return "yellow";
  }
  if (matches(gray)) {
    return "gray";
  }
  return "default";
}

DisposalChipPalette disposalChipPaletteFor(String raw, Brightness brightness) {
  final tone = _toneForDisposal(raw);
  final dark = brightness == Brightness.dark;

  switch (tone) {
    case "brown":
      return dark
          ? const DisposalChipPalette(
              background: Color(0xFF4C3826),
              foreground: Color(0xFFF3DEC8),
              border: Color(0xFFD4A470),
            )
          : const DisposalChipPalette(
              background: Color(0xFFF3E3D0),
              foreground: Color(0xFF6C4217),
              border: Color(0xFFA9743A),
            );
    case "blue":
      return dark
          ? const DisposalChipPalette(
              background: Color(0xFF1E3A56),
              foreground: Color(0xFFD4E9FF),
              border: Color(0xFF6AB1FF),
            )
          : const DisposalChipPalette(
              background: Color(0xFFE4F2FF),
              foreground: Color(0xFF0D4A84),
              border: Color(0xFF2A88E3),
            );
    case "yellow":
      return dark
          ? const DisposalChipPalette(
              background: Color(0xFF4A421D),
              foreground: Color(0xFFFFE9A8),
              border: Color(0xFFF4C84A),
            )
          : const DisposalChipPalette(
              background: Color(0xFFFFF7D6),
              foreground: Color(0xFF7C5E00),
              border: Color(0xFFF3C12E),
            );
    case "gray":
      return dark
          ? const DisposalChipPalette(
              background: Color(0xFF1F252A),
              foreground: Color(0xFFE4EAEE),
              border: Color(0xFF8C99A3),
            )
          : const DisposalChipPalette(
              background: Color(0xFFD4DBE0),
              foreground: Color(0xFF27343C),
              border: Color(0xFF667680),
            );
    case "emerald":
      return dark
          ? const DisposalChipPalette(
              background: Color(0xFF14372A),
              foreground: Color(0xFFD1F4E4),
              border: Color(0xFF57C28B),
            )
          : const DisposalChipPalette(
              background: Color(0xFFE0F5EA),
              foreground: Color(0xFF176744),
              border: Color(0xFF3FA56E),
            );
    case "slate":
      return dark
          ? const DisposalChipPalette(
              background: Color(0xFF252C38),
              foreground: Color(0xFFE0E7F1),
              border: Color(0xFF8A98AF),
            )
          : const DisposalChipPalette(
              background: Color(0xFFE7ECF3),
              foreground: Color(0xFF304156),
              border: Color(0xFF73839A),
            );
    case "olive":
      return dark
          ? const DisposalChipPalette(
              background: Color(0xFF35391D),
              foreground: Color(0xFFF0F3C9),
              border: Color(0xFFB5C15A),
            )
          : const DisposalChipPalette(
              background: Color(0xFFF0F3DA),
              foreground: Color(0xFF5D6720),
              border: Color(0xFF9CAA45),
            );
    case "sky":
      return dark
          ? const DisposalChipPalette(
              background: Color(0xFF1A3446),
              foreground: Color(0xFFD8F0FF),
              border: Color(0xFF69B5E6),
            )
          : const DisposalChipPalette(
              background: Color(0xFFE0F3FB),
              foreground: Color(0xFF145677),
              border: Color(0xFF4F9CC8),
            );
    default:
      return dark
          ? const DisposalChipPalette(
              background: Color(0xFF2B2B33),
              foreground: Color(0xFFE3E3EC),
              border: Color(0xFF8D8EA1),
            )
          : const DisposalChipPalette(
              background: Color(0xFFF1F2F8),
              foreground: Color(0xFF3F4257),
              border: Color(0xFFB7BAC9),
            );
  }
}
