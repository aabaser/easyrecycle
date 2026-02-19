import "package:flutter/material.dart";

class ERChip extends StatelessWidget {
  const ERChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.leading,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bg = selected
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerLow;
    final fg =
        selected ? colorScheme.onPrimaryContainer : colorScheme.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null || icon != null) ...[
              leading ?? Icon(icon, size: 14, color: fg),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style:
                  Theme.of(context).textTheme.labelSmall?.copyWith(color: fg),
            ),
          ],
        ),
      ),
    );
  }
}
