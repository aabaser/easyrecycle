import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:provider/provider.dart";

import "l10n/l10n.dart";
import "l10n/app_localizations.dart";
import "state/app_state.dart";
import "theme/app_theme.dart";
import "pages/language_picker_page.dart";

class EasyRecycleApp extends StatelessWidget {
  const EasyRecycleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return MaterialApp(
      title: "Easy Recycle",
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: appState.themeMode,
      locale: appState.locale,
      supportedLocales: L10n.supportedLocales,
      localeResolutionCallback: L10n.resolve,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const LanguagePickerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
