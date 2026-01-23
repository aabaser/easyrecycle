import "package:flutter/material.dart";
import "../theme/design_tokens.dart";

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: DesignTokens.secondaryButtonHeight,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withOpacity(0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.cornerRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: DesignTokens.body),
      ),
    );
  }
}
