import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../state/app_state.dart";
import "../pages/home_shell.dart";

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.selectedIndex});

  final int selectedIndex;

  void _navigateToTab(BuildContext context, int index) {
    final appState = context.read<AppState>();
    appState.requestTab(index);
    appState.setCurrentTabIndex(index);

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (value) => _navigateToTab(context, value),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.search_outlined),
          label: loc.t("nav_text"),
        ),
        NavigationDestination(
          icon: const Icon(Icons.camera_alt_outlined),
          label: loc.t("nav_camera"),
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          label: loc.t("nav_settings"),
        ),
      ],
    );
  }
}
