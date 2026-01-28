import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../models/city.dart";
import "admin_items_page.dart";
import "auth_test_page.dart";
import "../screens/debug/theme_preview_screen.dart";
import "../features/entry/widgets/language_toggle.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final appState = context.watch<AppState>();
    final city = appState.selectedCity;
    final cityLabel = city == null
        ? "-"
        : (city.id == "berlin"
            ? loc.t("city_berlin")
            : loc.t("city_hannover"));
    final cityOptions = City.defaults(
      berlinName: loc.t("city_berlin"),
      hannoverName: loc.t("city_hannover"),
    );
    final selectedLocale = appState.locale.languageCode;

    return ListView(
      padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
      children: [
        Text(
          loc.t("settings_language"),
          style: DesignTokens.titleM,
        ),
        const SizedBox(height: DesignTokens.baseSpacing),
        LanguageToggle(
          selected: selectedLocale,
          onChanged: (value) {
            appState.setLocale(Locale(value));
          },
          primaryColor: Theme.of(context).colorScheme.primary,
          outlineColor: Theme.of(context).colorScheme.outline,
          textColor: Theme.of(context).colorScheme.onSurface,
        ),
        const SizedBox(height: DesignTokens.baseSpacing),
        Text(
          loc.t("settings_city"),
          style: DesignTokens.titleM,
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
        const SizedBox(height: DesignTokens.baseSpacing),
        ListTile(
          title: Text(loc.t("settings_theme_preview")),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ThemePreviewScreen()),
            );
          },
        ),
        const SizedBox(height: DesignTokens.sectionSpacing),
        SwitchListTile(
          title: Text(loc.t("settings_admin_toggle")),
          value: appState.adminEnabled,
          onChanged: (value) => appState.setAdminEnabled(value),
        ),
        if (appState.adminEnabled) ...[
          const SizedBox(height: DesignTokens.baseSpacing),
          ListTile(
            title: Text(loc.t("settings_admin_link")),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AdminItemsPage()),
              );
            },
          ),
          const SizedBox(height: DesignTokens.baseSpacing),
          ListTile(
            title: Text(loc.t("settings_auth_test")),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AuthTestPage()),
              );
            },
          ),
        ],
      ],
    );
  }
}
