import "package:flutter/material.dart";

import "er_button.dart";

class ERSocialButton extends StatelessWidget {
  const ERSocialButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.login,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ERButton(
      label: label,
      onPressed: onPressed,
      variant: ERButtonVariant.secondary,
      icon: icon,
    );
  }
}
