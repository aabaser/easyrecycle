import "../models/recycle_center_link.dart";
import "../ui/disposal_chip_palette.dart";
import "../ui/disposal_tone_help_sheet.dart";

class DisposalChipCtaState {
  const DisposalChipCtaState({
    required this.hasExplicitTone,
    required this.hasToneHelp,
    required this.hasActiveLink,
    required this.priority,
  });

  final bool hasExplicitTone;
  final bool hasToneHelp;
  final bool hasActiveLink;
  final int priority;
}

DisposalChipCtaState disposalChipCtaState(
  String label,
  RecycleCenterLink? link,
) {
  final paletteSource = (link?.disposalCode ?? label).trim();
  final hasExplicitTone = disposalChipHasExplicitTone(paletteSource);
  final hasToneHelp = disposalToneHelpAvailableFor(paletteSource);
  final hasActiveLink = link != null && link.isActionable && !hasExplicitTone;
  final priority = hasExplicitTone
      ? 0
      : hasActiveLink
          ? 1
          : 2;
  return DisposalChipCtaState(
    hasExplicitTone: hasExplicitTone,
    hasToneHelp: hasToneHelp,
    hasActiveLink: hasActiveLink,
    priority: priority,
  );
}

List<String> orderDisposalChipLabels(
  Iterable<String> labels,
  Map<String, RecycleCenterLink> tagLinkMap,
) {
  final indexed = labels
      .where((label) => label.trim().isNotEmpty)
      .toList(growable: false)
      .asMap()
      .entries
      .toList(growable: false);

  indexed.sort((a, b) {
    final aState = disposalChipCtaState(a.value, tagLinkMap[a.value.trim()]);
    final bState = disposalChipCtaState(b.value, tagLinkMap[b.value.trim()]);
    final byPriority = aState.priority.compareTo(bState.priority);
    if (byPriority != 0) {
      return byPriority;
    }
    return a.key.compareTo(b.key);
  });

  return indexed.map((entry) => entry.value).toList(growable: false);
}
