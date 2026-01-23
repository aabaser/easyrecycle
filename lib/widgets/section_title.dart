import "package:flutter/material.dart";
import "../theme/design_tokens.dart";

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      title,
      style: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
    );
  }
}
