import "package:flutter/material.dart";
import "../l10n/app_localizations.dart";
import "../models/similar_item.dart";
import "../theme/design_tokens.dart";
import "disposal_chips.dart";

class SimilarItemCard extends StatelessWidget {
  const SimilarItemCard({super.key, required this.item, required this.onTap});

  final SimilarItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.aliasTitle ?? item.itemTitle,
                  style: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
                ),
                if (item.disposalLabels.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  _buildChips(item.disposalLabels, colorScheme),
                ],
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              loc.t("details_button"),
              style: DesignTokens.caption.copyWith(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChips(List<String> labels, ColorScheme colorScheme) {
    final visible = labels.take(2).toList();
    final remaining = labels.length - visible.length;
    final chips = <Widget>[
      ...visible.map((label) => Chip(label: Text(label))),
      if (remaining > 0) Chip(label: Text("+$remaining")),
    ];
    return Wrap(
      spacing: DesignTokens.baseSpacing,
      runSpacing: 6,
      children: chips,
    );
  }
}
