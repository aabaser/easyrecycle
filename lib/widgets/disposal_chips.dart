import "package:flutter/material.dart";
import "../theme/design_tokens.dart";
import "../ui/disposal_bin_assets_v2.dart";

class DisposalChips extends StatelessWidget {
  const DisposalChips({super.key, required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty) {
      return const SizedBox.shrink();
    }
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: DesignTokens.baseSpacing,
      runSpacing: 10,
      children: labels.map(
        (label) {
          final style = _styleForLabel(label, colorScheme);
          if (isMappedDisposalType(label)) {
            return _mappedDisposalPill(
              context: context,
              label: label,
              style: style,
              brightness: colorScheme.brightness,
            );
          }
          return _defaultDisposalChip(
            context: context,
            label: label,
            style: style,
          );
        },
      ).toList(),
    );
  }
}

class _ChipStyle {
  const _ChipStyle({
    required this.background,
    required this.foreground,
    required this.border,
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final IconData icon;
}

_ChipStyle _styleForLabel(String label, ColorScheme cs) {
  final value = label.toLowerCase();

  if (value.contains("sonder") ||
      value.contains("batter") ||
      value.contains("elektro") ||
      value.contains("hazard")) {
    return _ChipStyle(
      background: cs.errorContainer,
      foreground: cs.onErrorContainer,
      border: cs.error,
      icon: Icons.warning_amber_rounded,
    );
  }

  if (value.contains("bio") ||
      value.contains("kompost") ||
      value.contains("garten")) {
    return _ChipStyle(
      background: cs.tertiaryContainer,
      foreground: cs.onTertiaryContainer,
      border: cs.tertiary,
      icon: Icons.eco_outlined,
    );
  }

  if (value.contains("rest") ||
      value.contains("hausm") ||
      value.contains("müll") ||
      value.contains("mull")) {
    return _ChipStyle(
      background: cs.secondaryContainer,
      foreground: cs.onSecondaryContainer,
      border: cs.secondary,
      icon: Icons.delete_outline,
    );
  }

  return _ChipStyle(
    background: cs.primaryContainer,
    foreground: cs.onPrimaryContainer,
    border: cs.primary,
    icon: Icons.recycling_outlined,
  );
}

Widget _mappedDisposalPill({
  required BuildContext context,
  required String label,
  required _ChipStyle style,
  required Brightness brightness,
}) {
  final binAsset = disposalBinAssetFor(label, brightness);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: style.background,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: style.border, width: 1.4),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (binAsset != null)
          Image.asset(
            binAsset,
            width: 26,
            height: 26,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              style.icon,
              size: 20,
              color: style.foreground,
            ),
          )
        else
          Icon(
            style.icon,
            size: 20,
            color: style.foreground,
          ),
        const SizedBox(width: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: style.foreground,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.1,
              ),
        ),
      ],
    ),
  );
}

Widget _defaultDisposalChip({
  required BuildContext context,
  required String label,
  required _ChipStyle style,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: style.background,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: style.border, width: 1.3),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          style.icon,
          size: 16,
          color: style.foreground,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: style.foreground,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.1,
              ),
        ),
      ],
    ),
  );
}
