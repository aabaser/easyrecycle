import "package:flutter/material.dart";
import "../config/api_config.dart";
import "../l10n/app_localizations.dart";
import "../models/recycle_center_link.dart";
import "../models/similar_item.dart";
import "../ui/components/er_plant_card.dart";
import "../utils/recycling_center_rules.dart";

class SimilarItemCard extends StatelessWidget {
  const SimilarItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onFindCenterTap,
    this.onRecycleCenterLinkTap,
    this.findCenterLabel,
    this.lowEmphasisCta = true,
  });

  final SimilarItem item;
  final VoidCallback onTap;
  final VoidCallback? onFindCenterTap;
  final ValueChanged<RecycleCenterLink>? onRecycleCenterLinkTap;
  final String? findCenterLabel;
  final bool lowEmphasisCta;

  String? _resolvedImageUrl() {
    final raw = item.imageUrl?.trim();
    if (raw == null || raw.isEmpty) {
      return null;
    }
    if (raw.startsWith("http://") || raw.startsWith("https://")) {
      return raw;
    }
    return "${ApiConfig.baseUrl}$raw";
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final category = item.hintCategory.trim();
    final subtitle = category.isEmpty || category.toLowerCase() == "unknown"
        ? null
        : category;
    final imageUrl = _resolvedImageUrl();
    final canFindCenter = hasEligibleRecyclingCenterDisposal([
      ...item.disposalCodes,
      ...item.disposalLabels,
    ]);
    final tagLinkMap = {
      for (final link in item.disposalTagLinks)
        if (link.label.trim().isNotEmpty) link.label.trim(): link,
    };
    final hasActionableTagLinks = tagLinkMap.isNotEmpty;
    final tagItems = item.disposalLabels
        .where((label) => label.trim().isNotEmpty)
        .map((label) {
          final tagLink = tagLinkMap[label.trim()];
          return ERTagChipData(
            label: label,
            icon: tagLink == null ? null : Icons.location_on_rounded,
            highlighted: tagLink != null,
            paletteKey: tagLink == null ? null : _paletteKeyFor(tagLink),
            onTap: tagLink == null || onRecycleCenterLinkTap == null
                ? null
                : () => onRecycleCenterLinkTap!(tagLink),
          );
        })
        .toList(growable: false);

    return ERPlantCard(
      title: item.itemTitle,
      tagItems: tagItems,
      subtitle: subtitle,
      leadingIcon: Icons.eco_rounded,
      imageSize: 88,
      image: imageUrl == null
          ? null
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported_rounded),
            ),
      trailing: const Icon(Icons.chevron_right_rounded),
      ctaLabel: canFindCenter && !hasActionableTagLinks
          ? findCenterLabel ?? loc.t("find_recycling_center")
          : null,
      onCtaTap: canFindCenter && !hasActionableTagLinks ? onFindCenterTap : null,
      lowEmphasisCta: lowEmphasisCta,
      onTap: onTap,
    );
  }

  String _paletteKeyFor(RecycleCenterLink link) {
    if (link.typCode != null && link.typCode! > 0) {
      return "recycle_type_${link.typCode}";
    }
    final disposalPositive = link.disposalPositive?.trim();
    if (disposalPositive != null && disposalPositive.isNotEmpty) {
      return "recycle_disposal_${_normalizePaletteKey(disposalPositive)}";
    }
    return "recycle_link_${_normalizePaletteKey(link.label)}";
  }

  String _normalizePaletteKey(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll("\u00e4", "ae")
        .replaceAll("\u00f6", "oe")
        .replaceAll("\u00fc", "ue")
        .replaceAll("\u00df", "ss")
        .replaceAll(RegExp(r"[^a-z0-9]+"), "_")
        .replaceAll(RegExp(r"_+"), "_")
        .replaceAll(RegExp(r"^_|_$"), "");
  }
}
