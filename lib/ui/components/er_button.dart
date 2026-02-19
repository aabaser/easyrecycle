import "package:flutter/material.dart";

enum ERButtonVariant { primary, secondary, ghost }

class ERButton extends StatelessWidget {
  const ERButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.variant = ERButtonVariant.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final ERButtonVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final disabled = loading || onPressed == null;
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (loading)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else if (icon != null)
          Icon(icon, size: 18),
        if (loading || icon != null) const SizedBox(width: 8),
        Text(label),
      ],
    );

    switch (variant) {
      case ERButtonVariant.primary:
        return FilledButton(
          onPressed: disabled ? null : onPressed,
          child: child,
        );
      case ERButtonVariant.secondary:
        return OutlinedButton(
          onPressed: disabled ? null : onPressed,
          child: child,
        );
      case ERButtonVariant.ghost:
        return TextButton(
          onPressed: disabled ? null : onPressed,
          child: child,
        );
    }
  }
}
