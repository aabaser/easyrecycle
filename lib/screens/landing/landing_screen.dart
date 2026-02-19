import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../l10n/app_localizations.dart";
import "../../models/city.dart";
import "../../state/app_state.dart";
import "../../ui/components/er_button.dart";
import "../../widgets/brand_title.dart";
import "../../widgets/city_pills.dart";
import "../../widgets/language_segment.dart";
import "../../widgets/max_width_center.dart";
import "../login/auth_choice_screen.dart";

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
    final loc = AppLocalizations.of(context);
    final selectedLang = appState.locale.languageCode;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final cities = <City>[
      City(id: "berlin", name: "Berlin"),
      City(id: "hannover", name: "Hannover"),
    ];

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
                      colorScheme.primaryContainer.withValues(alpha: 0.5),
                      colorScheme.surfaceContainerLowest,
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: 0.16,
                    child: Image.asset(
                      "assets/uix/bg_top_abstract.png",
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            MaxWidthCenter(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 520),
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primaryContainer,
                            colorScheme.secondaryContainer,
                          ],
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Opacity(
                            opacity: 0.18,
                            child: Image.asset(
                              "assets/uix/bg_top_abstract.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                              child: Image.asset(
                                "assets/images/login_hero.png",
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  "assets/uix/header.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    BrandTitle(
                      textStyle: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
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
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 440),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.t("landing_city_label"),
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            loc.t("city_helper"),
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          CityPills(
                            cities: cities,
                            selectedCityId: appState.selectedCity?.id,
                            onSelected: appState.setSelectedCity,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: ERButton(
                        label: loc.t("entry_cta"),
                        onPressed: appState.selectedCity == null
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const AuthChoiceScreen(),
                                  ),
                        );
                              },
                      ),
                    ),
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
