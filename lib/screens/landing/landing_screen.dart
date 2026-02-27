import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../l10n/app_localizations.dart";
import "../../models/city.dart";
import "../../state/app_state.dart";
import "../../ui/components/er_button.dart";
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
        appState.setSelectedCity(const City(id: "berlin", name: "Berlin"));
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

    const cities = <City>[
      City(id: "berlin", name: "Berlin"),
      City(id: "hannover", name: "Hannover"),
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  "assets/uix/landing_vibrant_bg.jpg",
                  fit: BoxFit.cover,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.14),
                        colorScheme.surfaceContainerLowest.withValues(
                          alpha: 0.92,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                MaxWidthCenter(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 120),
                        Text(
                          loc.t("entry_headline"),
                          textAlign: TextAlign.center,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
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
                        const SizedBox(height: 22),
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 440),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow.withValues(
                              alpha: 0.9,
                            ),
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
        ],
      ),
    );
  }
}
