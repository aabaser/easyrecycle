import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../l10n/app_localizations.dart";
import "../../pages/home_shell.dart";
import "../../state/app_state.dart";
import "../../ui/components/er_button.dart";
import "../../widgets/brand_title.dart";
import "../../widgets/max_width_center.dart";
import "../legal/privacy_screen.dart";
import "../legal/terms_screen.dart";
import "email_login_screen.dart";

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final titleStyle = textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.primaryContainer.withValues(alpha: 0.35),
                      colorScheme.surfaceContainerLowest,
                    ],
                  ),
                ),
              ),
            ),
            MaxWidthCenter(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          BrandTitle(textStyle: titleStyle),
                          const SizedBox(height: 8),
                          Text(
                            loc.t("entry_headline"),
                            textAlign: TextAlign.center,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (appState.selectedCity != null)
                            Align(
                              alignment: Alignment.center,
                              child: Chip(
                                avatar: const Icon(Icons.location_on_outlined, size: 18),
                                label: Text(
                                  appState.selectedCity!.name,
                                  style: textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                backgroundColor: colorScheme.primaryContainer,
                                side: BorderSide(
                                  color: colorScheme.primary.withValues(alpha: 0.35),
                                ),
                              ),
                            ),
                          const SizedBox(height: 14),
                          _BrandedSocialButton(
                            label: loc.t("login_google"),
                            icon: const _GoogleMark(),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("TODO: Google login")),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          _BrandedSocialButton(
                            label: _appleLabel(appState.locale.languageCode),
                            icon: Icon(Icons.apple, color: colorScheme.onSurface),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("TODO: Apple login")),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          ERButton(
                            label: loc.t("login_email"),
                            variant: ERButtonVariant.secondary,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const EmailLoginScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          ERButton(
                            label: loc.t("login_guest"),
                            variant: ERButtonVariant.ghost,
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const HomeShell(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          loc.t("privacy_text_prefix"),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.64),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PrivacyScreen(),
                              ),
                            );
                          },
                          child: Text(
                            loc.t("privacy_link_label"),
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          loc.t("privacy_text_between"),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.64),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const TermsScreen(),
                              ),
                            );
                          },
                          child: Text(
                            loc.t("terms_link_label"),
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          loc.t("privacy_text_suffix"),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.64),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _appleLabel(String languageCode) {
    switch (languageCode) {
      case "de":
        return "Mit Apple fortfahren";
      case "tr":
        return "Apple ile devam et";
      default:
        return "Continue with Apple";
    }
  }
}

class _BrandedSocialButton extends StatelessWidget {
  const _BrandedSocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerLow,
          side: BorderSide(color: colorScheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 22, height: 22, child: Center(child: icon)),
            const SizedBox(width: 10),
            Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE6E8EC)),
      ),
      child: const Text(
        "G",
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 12,
          color: Color(0xFF4285F4),
        ),
      ),
    );
  }
}
