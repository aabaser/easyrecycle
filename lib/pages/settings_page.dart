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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cityOptions = City.defaults(
      berlinName: loc.t("city_berlin"),
      hannoverName: loc.t("city_hannover"),
    );
    final selectedLocale = appState.locale.languageCode;

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
                loc.t("settings_language"),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: DesignTokens.baseSpacing),
              LanguageToggle(
                selected: selectedLocale,
                onChanged: (value) {
                  appState.setLocale(Locale(value));
                },
                primaryColor: colorScheme.primary,
                outlineColor: colorScheme.outline,
                textColor: colorScheme.onSurface,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
        ListTile(
          title: Text(loc.t("settings_theme_preview")),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ThemePreviewScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
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
