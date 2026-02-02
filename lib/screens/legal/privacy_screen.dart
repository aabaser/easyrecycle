import "package:flutter/material.dart";

import "../../theme/design_tokens.dart";

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gizlilik"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
        child: Text(
          "TODO: Gizlilik politikası içeriği.",
          style: DesignTokens.body,
        ),
      ),
    );
  }
}
