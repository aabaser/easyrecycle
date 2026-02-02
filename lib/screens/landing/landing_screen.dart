import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../models/city.dart";
import "../../state/app_state.dart";
import "../../theme/design_tokens.dart";
import "../../widgets/brand_title.dart";
import "../../widgets/city_pills.dart";
import "../../widgets/language_segment.dart";
import "../../widgets/max_width_center.dart";
import "../legal/privacy_screen.dart";
import "../legal/terms_screen.dart";
import "../login/email_login_screen.dart";
import "../../pages/home_shell.dart";

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
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

    const copy = {
      "de": {
        "slogan": "Reduzieren. Trennen. Weitergeben.",
        "subtitle": "Kleine Schritte. Große Wirkung.",
        "city_label": "Stadt wählen",
        "privacy_prefix": "Mit dem Fortfahren akzeptierst du ",
        "privacy_link": "Datenschutz",
        "terms_link": "AGB",
        "privacy_suffix": ".",
        "login_google": "Mit Google fortfahren",
        "login_email": "Mit E-Mail fortfahren",
        "login_guest": "Als Gast fortfahren",
      },
      "en": {
        "slogan": "Reduce. Sort. Share.",
        "subtitle": "Small steps, big impact.",
        "city_label": "City",
        "privacy_prefix": "By continuing, you accept ",
        "privacy_link": "Privacy",
        "terms_link": "Terms",
        "privacy_suffix": ".",
        "login_google": "Continue with Google",
        "login_email": "Continue with email",
        "login_guest": "Continue as guest",
      },
      "tr": {
        "slogan": "Azalt. Ayır. Paylaş.",
        "subtitle": "Küçük adımlar, büyük etki yaratır.",
        "city_label": "Şehir",
        "privacy_prefix": "Devam ederek ",
        "privacy_link": "Gizlilik",
        "terms_link": "Şartlar",
        "privacy_suffix": "’ı kabul edersin.",
        "login_google": "Google ile devam et",
        "login_email": "E-posta ile devam et",
        "login_guest": "Misafir olarak devam et",
      },
    };
    final slogan = copy[selectedLang]?["slogan"] ?? copy["tr"]!["slogan"]!;
    final subtitle =
        copy[selectedLang]?["subtitle"] ?? copy["tr"]!["subtitle"]!;
    final cityLabel =
        copy[selectedLang]?["city_label"] ?? copy["tr"]!["city_label"]!;
    final privacyPrefix =
        copy[selectedLang]?["privacy_prefix"] ?? copy["tr"]!["privacy_prefix"]!;
    final privacyLink =
        copy[selectedLang]?["privacy_link"] ?? copy["tr"]!["privacy_link"]!;
    final termsLink =
        copy[selectedLang]?["terms_link"] ?? copy["tr"]!["terms_link"]!;
    final privacySuffix =
        copy[selectedLang]?["privacy_suffix"] ?? copy["tr"]!["privacy_suffix"]!;
    final loginGoogle =
        copy[selectedLang]?["login_google"] ?? copy["tr"]!["login_google"]!;
    final loginEmail =
        copy[selectedLang]?["login_email"] ?? copy["tr"]!["login_email"]!;
    final loginGuest =
        copy[selectedLang]?["login_guest"] ?? copy["tr"]!["login_guest"]!;

    final cities = <City>[
      City(id: "berlin", name: "Berlin"),
      City(id: "hannover", name: "Hannover"),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        child: Stack(
          children: [
            MaxWidthCenter(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.sectionSpacing,
                  vertical: DesignTokens.sectionSpacing,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    BrandTitle(
                      textStyle: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                            letterSpacing: -0.4,
                          ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      slogan,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0B1220),
                            fontSize: 21,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF0B1220).withOpacity(0.7),
                            fontSize: 15,
                          ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      cityLabel,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0B1220),
                          ),
                    ),
                    const SizedBox(height: 8),
                    CityPills(
                      cities: cities,
                      selectedCityId: appState.selectedCity?.id,
                      onSelected: appState.setSelectedCity,
                    ),
                    const SizedBox(height: 22),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("TODO: Google login"),
                                  ),
                                );
                              },
                              child: Text(
                                loginGoogle,
                                style: DesignTokens.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF2563EB),
                                side: const BorderSide(
                                  color: Color(0xFF2563EB),
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const EmailLoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                loginEmail,
                                style: DesignTokens.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("TODO: Misafir girişi"),
                                ),
                              );
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const HomeShell(),
                                ),
                              );
                            },
                            child: Text(
                              loginGuest,
                              style: DesignTokens.body.copyWith(
                                color: const Color(0xFF0B1220).withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          privacyPrefix,
                          style: DesignTokens.caption.copyWith(
                            color: const Color(0xFF0B1220).withOpacity(0.6),
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
                            privacyLink,
                            style: DesignTokens.caption.copyWith(
                              color: const Color(0xFF4338CA),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          " ve ",
                          style: DesignTokens.caption.copyWith(
                            color: const Color(0xFF0B1220).withOpacity(0.6),
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
                            termsLink,
                            style: DesignTokens.caption.copyWith(
                              color: const Color(0xFF4338CA),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          privacySuffix,
                          style: DesignTokens.caption.copyWith(
                            color: const Color(0xFF0B1220).withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 12,
              child: LanguageSegment(
                selected: selectedLang,
                onChanged: (value) => appState.setLocale(Locale(value)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
