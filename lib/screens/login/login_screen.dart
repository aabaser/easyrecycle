import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../models/city.dart";
import "../../pages/home_shell.dart";
import "../../state/app_state.dart";
import "../../theme/design_tokens.dart";
import "../../widgets/brand_title.dart";
import "../../widgets/city_chips.dart";
import "../../widgets/language_selector.dart";
import "../../widgets/max_width_center.dart";
import "../../widgets/primary_button.dart";
import "../../widgets/secondary_button.dart";
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
    final colorScheme = Theme.of(context).colorScheme;

    const copy = {
      "de": {
        "slogan": "Reduzieren. Trennen. Weitergeben.",
        "subtitle": "Kleine Schritte, große Wirkung.",
      },
      "en": {
        "slogan": "Reduce. Sort. Share.",
        "subtitle": "Small steps, big impact.",
      },
      "tr": {
        "slogan": "Azalt. Ayır. Paylaş.",
        "subtitle": "Küçük adımlar, büyük etki yaratır.",
      },
    };
    final slogan = copy[selectedLang]?["slogan"] ?? copy["tr"]!["slogan"]!;
    final subtitle = copy[selectedLang]?["subtitle"] ?? copy["tr"]!["subtitle"]!;

    final List<City> cities = [
      City(id: "berlin", name: "Berlin"),
      City(id: "hannover", name: "Hannover"),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: MaxWidthCenter(
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
                const BrandTitle(),
                const SizedBox(height: 12),
                Text(
                  slogan,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF475569),
                      ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(DesignTokens.cardPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(DesignTokens.cornerRadius),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryButton(
                        label: "Google ile devam et",
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("TODO: Google login"),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 8),
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Şehir:",
                      style: DesignTokens.titleM.copyWith(
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CityChips(
                        cities: cities,
                        selectedCityId: appState.selectedCity?.id,
                        onSelected: (city) => appState.setSelectedCity(city),
                      ),
                    ),
                  ],
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
                      "Devam ederek ",
                      style: DesignTokens.caption.copyWith(
                        color: const Color(0xFF475569),
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
                        "Gizlilik",
                        style: DesignTokens.caption.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      " Politikası ve ",
                      style: DesignTokens.caption.copyWith(
                        color: const Color(0xFF475569),
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
                        "Şartlar",
                        style: DesignTokens.caption.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "’ı kabul edersin.",
                      style: DesignTokens.caption.copyWith(
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
