import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../l10n/l10n.dart";
import "../pages/admin_items_page.dart";
import "../state/app_state.dart";
import "../theme/app_theme.dart";
import "admin_login_page.dart";

class EasyRecycleAdminApp extends StatelessWidget {
  const EasyRecycleAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return MaterialApp(
      title: "Easy Recycle Admin",
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
      home: const _AdminGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _AdminGate extends StatelessWidget {
  const _AdminGate();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    if (appState.hasValidAdminSession) {
      return const AdminItemsPage();
    }
    return const AdminLoginPage();
  }
}
