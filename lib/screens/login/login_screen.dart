import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../l10n/app_localizations.dart";
import "../../models/city.dart";
import "../../pages/home_shell.dart";
import "../../state/app_state.dart";
import "../../ui/components/er_button.dart";
import "../../ui/components/er_social_button.dart";
import "../../widgets/brand_title.dart";
import "../../widgets/city_chips.dart";
import "../../widgets/language_selector.dart";
import "../../widgets/max_width_center.dart";
import "../legal/privacy_screen.dart";
import "../legal/terms_screen.dart";
import "email_login_screen.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    _initialized = true;
    final appState = context.read<AppState>();
    if (appState.selectedCity == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appState.setSelectedCity(City(id: "berlin", name: "Berlin"));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final selectedLang = appState.locale.languageCode;
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    const cities = [
      City(id: "berlin", name: "Berlin"),
      City(id: "hannover", name: "Hannover"),
    ];

    return Scaffold(
      body: SafeArea(
        child: MaxWidthCenter(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      "assets/uix/empty_state_light_house.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const BrandTitle(),
                const SizedBox(height: 12),
                Text(
                  loc.t("entry_headline"),
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  loc.t("entry_subtitle"),
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ERSocialButton(
                        label: loc.t("login_google"),
                        icon: Icons.g_mobiledata,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("TODO: Google login"),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
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
                const SizedBox(height: 20),
                Text(
                  loc.t("landing_city_label"),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                CityChips(
                  cities: cities,
                  selectedCityId: appState.selectedCity?.id,
                  onSelected: appState.setSelectedCity,
                ),
                const SizedBox(height: 16),
                LanguageSelector(
                  selected: selectedLang,
                  onChanged: (value) => appState.setLocale(Locale(value)),
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
      ),
    );
  }
}
