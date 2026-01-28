import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../l10n/app_localizations.dart";
import "../../models/city.dart";
import "../../pages/home_shell.dart";
import "../../state/app_state.dart";
import "../../theme/design_tokens.dart";
import "../../widgets/max_width_center.dart";
import "../../widgets/primary_button.dart";
import "widgets/language_toggle.dart";

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final selectedLocale = appState.locale.languageCode;
    final hasCitySelected = appState.selectedCity != null;
    final cityOptions = City.defaults(
      berlinName: loc.t("city_berlin"),
      hannoverName: loc.t("city_hannover"),
    );
    final selectedCityId = appState.selectedCity?.id;

    Widget heroHeader() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
              children: const [
                TextSpan(
                  text: "Easy ",
                  style: TextStyle(color: Color(0xFF4338CA)),
                ),
                TextSpan(
                  text: "Recycle",
                  style: TextStyle(color: Color(0xFF0B1220)),
                ),
                TextSpan(
                  text: "•",
                  style: TextStyle(color: Color(0xFF22D3EE)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            loc.t("entry_headline"),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0B1220),
                ),
          ),
          const SizedBox(height: 6),
          Text(
            loc.t("entry_subtitle"),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: const Color(0xFF0B1220).withOpacity(0.7)),
          ),
        ],
      );
    }

    Widget citySelector() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            loc.t("city_title"),
            textAlign: TextAlign.center,
            style: DesignTokens.titleM.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: cityOptions
                .map(
                  (city) => ChoiceChip(
                    label: Text(city.name),
                    selected: selectedCityId == city.id,
                    onSelected: (_) {
                      appState.setSelectedCity(city);
                    },
                  ),
                )
                .toList(),
          ),
        ],
      );
    }

    Widget startButton() {
      return SizedBox(
        width: double.infinity,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: PrimaryButton(
            label: loc.t("entry_cta"),
            onPressed: () {
              if (!hasCitySelected) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loc.t("admin_city_required")),
                  ),
                );
                return;
              }
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const HomeShell(),
                ),
              );
            },
          ),
        ),
      );
    }

    Widget languageSelector() {
      return LanguageToggle(
        selected: selectedLocale,
        onChanged: (value) {
          appState.setLocale(Locale(value));
        },
        primaryColor: colorScheme.primary,
        outlineColor: colorScheme.outline,
        textColor: colorScheme.onSurface,
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
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
                      const SizedBox(height: 24),
                      heroHeader(),
                      const SizedBox(height: 24),
                      citySelector(),
                      const SizedBox(height: 16),
                      if (!hasCitySelected) ...[
                        Text(
                          loc.t("admin_city_required"),
                          textAlign: TextAlign.center,
                          style: DesignTokens.caption.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      startButton(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 12,
              child: languageSelector(),
            ),
          ],
        ),
      ),
    );
  }

}
