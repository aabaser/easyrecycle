import "package:flutter/material.dart";
import "../../config/api_config.dart";
import "../disposal_chip_palette.dart";

class ResultPill extends StatelessWidget {
  const ResultPill({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: colorScheme.secondary, width: 1.1),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.title,
    this.recommendedLabel,
    this.recommendedLabels = const [],
    required this.primaryCtaLabel,
    required this.onPrimaryTap,
    this.subtitle,
    this.onHeaderTap,
    this.secondaryCtaLabel,
    this.onSecondaryTap,
    this.leadingIcon = Icons.eco_rounded,
    this.thumbnailUrl,
  });

  final String title;
  final String? recommendedLabel;
  final List<String> recommendedLabels;
  final String primaryCtaLabel;
  final VoidCallback? onPrimaryTap;
  final String? subtitle;
  final VoidCallback? onHeaderTap;
  final String? secondaryCtaLabel;
  final VoidCallback? onSecondaryTap;
  final IconData leadingIcon;
  final String? thumbnailUrl;

  String? _resolvedThumbnailUrl() {
    final raw = thumbnailUrl?.trim();
    if (raw == null || raw.isEmpty) {
      return null;
    }
    if (raw.startsWith("http://") || raw.startsWith("https://")) {
      return raw;
    }
    return "${ApiConfig.baseUrl}$raw";
  }

  Widget _leadingVisual(ColorScheme colorScheme) {
    final resolvedUrl = _resolvedThumbnailUrl();
    if (resolvedUrl == null) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Icon(
          leadingIcon,
          size: 22,
          color: colorScheme.primary,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Image.network(
          resolvedUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: colorScheme.primaryContainer,
            alignment: Alignment.center,
            child: Icon(
              leadingIcon,
              size: 22,
              color: colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(16);

    return Material(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onHeaderTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _leadingVisual(colorScheme),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (recommendedLabels.isNotEmpty ||
                (recommendedLabel != null &&
                    recommendedLabel!.trim().isNotEmpty)) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (recommendedLabels.isNotEmpty
                        ? recommendedLabels
                        : <String>[recommendedLabel!])
                    .where((e) => e.trim().isNotEmpty)
                    .map((e) => _InlineResultPill(text: e))
                    .toList(growable: false),
              ),
            ],
            if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            if (onPrimaryTap != null && primaryCtaLabel.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: onPrimaryTap,
                  icon: const Icon(Icons.location_on_rounded, size: 18),
                  label: Text(primaryCtaLabel),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    side: BorderSide(color: colorScheme.outlineVariant),
                    foregroundColor: colorScheme.primary,
                  ),
                ),
              ),
            ],
            if (secondaryCtaLabel != null &&
                secondaryCtaLabel!.trim().isNotEmpty &&
                onSecondaryTap != null) ...[
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onSecondaryTap,
                  child: Text(secondaryCtaLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InlineResultPill extends StatelessWidget {
  const _InlineResultPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = disposalChipPaletteFor(text, theme.brightness);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.border, width: 1.0),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelMedium?.copyWith(
          color: palette.foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
