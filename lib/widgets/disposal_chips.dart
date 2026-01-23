import "package:flutter/material.dart";
import "../theme/design_tokens.dart";

class DisposalChips extends StatelessWidget {
  const DisposalChips({super.key, required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(
      spacing: DesignTokens.baseSpacing,
      runSpacing: 6,
      children: labels
          .map((label) => Chip(label: Text(label)))
          .toList(),
    );
  }
}
