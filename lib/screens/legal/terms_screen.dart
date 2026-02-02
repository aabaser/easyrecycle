import "package:flutter/material.dart";

import "../../theme/design_tokens.dart";

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Şartlar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
        child: Text(
          "TODO: Şartlar içeriği.",
          style: DesignTokens.body,
        ),
      ),
    );
  }
}
