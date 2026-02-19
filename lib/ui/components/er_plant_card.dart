import "package:flutter/material.dart";

import "../disposal_chip_palette.dart";

class ERPlantCard extends StatelessWidget {
  const ERPlantCard({
    super.key,
    required this.title,
    this.primaryLabel,
    this.subtitle,
    this.image,
    this.tags = const [],
    this.trailing,
    this.ctaLabel,
    this.onCtaTap,
    this.leadingIcon = Icons.eco_outlined,
    this.onTap,
  });

  final String title;
  final String? primaryLabel;
  final String? subtitle;
  final Widget? image;
  final List<String> tags;
  final Widget? trailing;
  final String? ctaLabel;
  final VoidCallback? onCtaTap;
  final IconData leadingIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final radius = BorderRadius.circular(20);
    final topLabel = (primaryLabel != null && primaryLabel!.trim().isNotEmpty)
        ? primaryLabel!.trim()
        : title;
    final showSecondaryTitle = topLabel != title;
    final tagSource = tags.where((tag) => tag.trim().isNotEmpty).toList();
    final visibleTags = tagSource;
    final hasImage = image != null;

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
                            width: 72,
                            height: 72,
                            color: colorScheme.surfaceContainer,
                            alignment: Alignment.center,
                            child: image,
                          ),
                        )
                      else
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                  if (visibleTags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: visibleTags
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
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: onCtaTap,
                        icon: const Icon(Icons.place_outlined, size: 18),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDisposalRow({
  required String tag,
  required ThemeData theme,
}) {
  final palette = disposalChipPaletteFor(tag, theme.brightness);
  return Container(
    constraints: const BoxConstraints(minHeight: 48),
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    decoration: BoxDecoration(
      color: palette.background,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: palette.border, width: 1.2),
    ),
    child: Text(
      tag,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.labelLarge?.copyWith(
        color: palette.foreground,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}
