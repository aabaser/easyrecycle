import "package:flutter/material.dart";

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
    required this.primaryCtaLabel,
    required this.onPrimaryTap,
    this.subtitle,
    this.onHeaderTap,
    this.secondaryCtaLabel,
    this.onSecondaryTap,
    this.leadingIcon = Icons.eco_outlined,
  });

  final String title;
  final String? recommendedLabel;
  final String primaryCtaLabel;
  final VoidCallback? onPrimaryTap;
  final String? subtitle;
  final VoidCallback? onHeaderTap;
  final String? secondaryCtaLabel;
  final VoidCallback? onSecondaryTap;
  final IconData leadingIcon;

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
                      Container(
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
                      ),
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
                        Icons.chevron_right,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (recommendedLabel != null && recommendedLabel!.trim().isNotEmpty)
              ...[
                const SizedBox(height: 8),
                ResultPill(text: recommendedLabel!),
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
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton.icon(
                onPressed: onPrimaryTap,
                icon: const Icon(Icons.place_outlined, size: 18),
                label: Text(primaryCtaLabel),
              ),
            ),
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
