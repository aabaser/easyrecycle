import "package:flutter/material.dart";

import "../../pages/home_shell.dart";
import "../../theme/design_tokens.dart";
import "../../widgets/brand_title.dart";
import "../../widgets/primary_button.dart";
import "../../widgets/secondary_button.dart";
import "email_login_screen.dart";

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        );

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.sectionSpacing,
            vertical: DesignTokens.sectionSpacing,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BrandTitle(textStyle: titleStyle),
              const SizedBox(height: 20),
              PrimaryButton(
                label: "Google ile devam et",
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("TODO: Google login")),
                  );
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: "E-posta ile devam et",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const EmailLoginScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("TODO: Misafir girişi")),
                  );
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const HomeShell(),
                    ),
                  );
                },
                child: Text(
                  "Misafir olarak devam et",
                  style: DesignTokens.body.copyWith(
                    color: const Color(0xFF22D3EE),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
