import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../models/city.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final appState = context.watch<AppState>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cityOptions = City.defaults(
      berlinName: loc.t("city_berlin"),
      hannoverName: loc.t("city_hannover"),
    );

    return ListView(
      padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.t("settings_city"),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: DesignTokens.baseSpacing),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cityOptions
                    .map(
                      (city) => ChoiceChip(
                        label: Text(city.name),
                        selected: city.id == appState.selectedCity?.id,
                        onSelected: (_) {
                          appState.setSelectedCity(city);
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text("Dark Mode"),
          value: appState.themeMode == ThemeMode.dark,
          onChanged: (value) {
            appState.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
          },
        ),
      ],
    );
  }
}
