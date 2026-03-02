import "package:flutter/material.dart";
import "../config/api_config.dart";
import "../l10n/app_localizations.dart";
import "../models/similar_item.dart";
import "../ui/components/er_plant_card.dart";
import "../utils/recycling_center_rules.dart";

class SimilarItemCard extends StatelessWidget {
  const SimilarItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onFindCenterTap,
    this.findCenterLabel,
    this.lowEmphasisCta = false,
  });

  final SimilarItem item;
  final VoidCallback onTap;
  final VoidCallback? onFindCenterTap;
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

    return ERPlantCard(
      title: item.itemTitle,
      tags: item.disposalLabels,
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
      ctaLabel: findCenterLabel ?? loc.t("find_recycling_center"),
      onCtaTap: canFindCenter ? onFindCenterTap : null,
      lowEmphasisCta: lowEmphasisCta,
      onTap: onTap,
    );
  }
}
