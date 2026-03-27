import "package:flutter/material.dart";

import "../disposal_chip_palette.dart";

class ERPlantCard extends StatelessWidget {
  const ERPlantCard({
    super.key,
    required this.title,
    this.eyebrowLabel,
    this.primaryLabel,
    this.subtitle,
    this.image,
    this.tags = const [],
    this.trailing,
    this.ctaLabel,
    this.onCtaTap,
    this.leadingIcon = Icons.eco_rounded,
    this.onTap,
    this.imageSize = 72,
    this.lowEmphasisCta = false,
    this.footer,
    this.tagItems,
  });

  final String title;
  final String? eyebrowLabel;
  final String? primaryLabel;
  final String? subtitle;
  final Widget? image;
  final List<String> tags;
  final Widget? trailing;
  final String? ctaLabel;
  final VoidCallback? onCtaTap;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
  final double imageSize;
  final bool lowEmphasisCta;
  final Widget? footer;
  final List<ERTagChipData>? tagItems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final radius = BorderRadius.circular(20);
    final topLabel = (primaryLabel != null && primaryLabel!.trim().isNotEmpty)
        ? primaryLabel!.trim()
        : title;
    final showSecondaryTitle = topLabel != title;
    final eyebrow = eyebrowLabel?.trim();
    final visibleTagItems = (tagItems == null || tagItems!.isEmpty)
        ? tags
            .where((tag) => tag.trim().isNotEmpty)
            .map((tag) => ERTagChipData(label: tag))
            .toList()
        : tagItems!
            .where((tag) => tag.label.trim().isNotEmpty)
            .toList(growable: false);
    final hasImage = image != null;
    final hasLeadingIcon = !hasImage && leadingIcon != null;

    return Material(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       if (hasImage)
                         ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: imageSize,
                            height: imageSize,
                            color: colorScheme.surfaceContainer,
                            alignment: Alignment.center,
                            child: image,
                          ),
                        )
                       else if (hasLeadingIcon)
                         Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                             child: Icon(
                               leadingIcon,
                               size: 24,
                               color: colorScheme.primary,
                             ),
                           ),
                       if (hasImage || hasLeadingIcon) const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (eyebrow != null && eyebrow.isNotEmpty) ...[
                              Text(
                                eyebrow,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],
                            Text(
                              topLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (showSecondaryTitle) ...[
                              const SizedBox(height: 2),
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (trailing != null) ...[
                        const SizedBox(width: 8),
                        trailing!,
                      ],
                    ],
                  ),
                  if (visibleTagItems.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: visibleTagItems
                          .map(
                            (tag) => _buildDisposalRow(
                              tag: tag,
                              theme: theme,
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ],
                  if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (ctaLabel != null &&
                      ctaLabel!.trim().isNotEmpty &&
                      onCtaTap != null) ...[
                    const SizedBox(height: 12),
                    if (lowEmphasisCta)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: onCtaTap,
                          icon: const Icon(Icons.location_on_rounded, size: 18),
                          label: Text(
                            ctaLabel!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: OutlinedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            side: BorderSide(color: colorScheme.outlineVariant),
                            foregroundColor: colorScheme.primary,
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: onCtaTap,
                          icon: const Icon(Icons.location_on_rounded, size: 18),
                          label: Text(
                            ctaLabel!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: FilledButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                  if (footer != null) ...[
                    const SizedBox(height: 12),
                    footer!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ERTagChipData {
  const ERTagChipData({
    required this.label,
    this.icon,
    this.onTap,
    this.highlighted = false,
    this.paletteKey,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool highlighted;
  final String? paletteKey;
}

Widget _buildDisposalRow({
  required ERTagChipData tag,
  required ThemeData theme,
}) {
  final palette = disposalChipPaletteFor(
    tag.paletteKey ?? tag.label,
    theme.brightness,
  );
  final background =
      tag.highlighted ? palette.background.withValues(alpha: 0.9) : palette.background;
  final border =
      tag.highlighted ? palette.foreground.withValues(alpha: 0.35) : palette.border;
  final child = Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: border, width: tag.highlighted ? 1.2 : 1.0),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (tag.icon != null) ...[
          Icon(
            tag.icon,
            size: tag.icon == Icons.delete_rounded ? 16 : 15,
            color: palette.foreground,
          ),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            tag.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: palette.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
  if (tag.onTap == null) {
    return child;
  }
  return InkWell(
    onTap: tag.onTap,
    borderRadius: BorderRadius.circular(999),
    child: child,
  );
}
