import "package:flutter/material.dart";

import "../../theme/design_tokens.dart";

class EmailLoginScreen extends StatelessWidget {
  const EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-posta ile giriş"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
        child: Text(
          "TODO: E-posta ile giriş ekranı.",
          style: DesignTokens.body,
        ),
      ),
    );
  }
}
