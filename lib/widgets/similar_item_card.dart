import "package:flutter/material.dart";
import "../l10n/app_localizations.dart";
import "../models/similar_item.dart";
import "../ui/components/result_card.dart";
import "../utils/recycling_center_rules.dart";

class SimilarItemCard extends StatelessWidget {
  const SimilarItemCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onFindCenterTap,
    this.findCenterLabel,
  });

  final SimilarItem item;
  final VoidCallback onTap;
  final VoidCallback? onFindCenterTap;
  final String? findCenterLabel;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final category = item.hintCategory.trim();
    final subtitle = category.isEmpty || category.toLowerCase() == "unknown"
        ? null
        : category;
    final recommended =
        item.disposalLabels.isNotEmpty ? item.disposalLabels.first : null;
    final canFindCenter = hasEligibleRecyclingCenterDisposal(item.disposalCodes);

    return ResultCard(
      title: item.itemTitle,
      recommendedLabel: recommended,
      subtitle: subtitle,
      leadingIcon: Icons.eco_outlined,
      onHeaderTap: onTap,
      primaryCtaLabel: findCenterLabel ?? loc.t("find_recycling_center"),
      onPrimaryTap: canFindCenter ? onFindCenterTap : null,
    );
  }
}
