import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../widgets/primary_button.dart";
import "../widgets/max_width_center.dart";
import "city_picker_page.dart";

class LanguagePickerPage extends StatelessWidget {
  const LanguagePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final loc = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final selected = appState.locale.languageCode;

    final options = <String, String>{
      "de": loc.t("language_de"),
      "tr": loc.t("language_tr"),
      "en": loc.t("language_en"),
    };

    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        leading: canPop ? const BackButton() : null,
        title: Text(
          loc.t("language_title"),
          style: DesignTokens.titleM.copyWith(color: colorScheme.onSurface),
        ),
      ),
      body: SafeArea(
        top: false,
        child: MaxWidthCenter(
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...options.entries.map(
                  (entry) => RadioListTile<String>(
                    value: entry.key,
                    groupValue: selected,
                    activeColor: colorScheme.primary,
                    title: Text(
                      entry.value,
                      style: DesignTokens.body
                          .copyWith(color: colorScheme.onSurface),
                    ),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      appState.setLocale(Locale(value));
                    },
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  label: loc.t("language_continue"),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const CityPickerPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
