import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../widgets/max_width_center.dart";
import "camera_tab_page.dart";
import "text_search_page.dart";
import "settings_page.dart";

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  static const int tabText = 0;
  static const int tabCamera = 1;
  static const int tabSettings = 2;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final _cameraKey = GlobalKey<CameraTabPageState>();
  late int _index;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _index = appState.currentTabIndex;
    appState.addListener(_handleAppState);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleTabActivation();
    });
  }

  @override
  void dispose() {
    context.read<AppState>().removeListener(_handleAppState);
    super.dispose();
  }

  void _handleAppState() {
    if (!mounted) {
      return;
    }
    final appState = context.read<AppState>();
    final requestedTab = appState.consumeRequestedTab();
    if (requestedTab != null && requestedTab != _index) {
      setState(() {
        _index = requestedTab;
      });
      appState.setCurrentTabIndex(_index);
    }

    final shouldOpenCamera = appState.consumeCameraScanRequest();
    if (shouldOpenCamera) {
      if (_index != HomeShell.tabCamera) {
        setState(() {
          _index = HomeShell.tabCamera;
        });
        appState.setCurrentTabIndex(_index);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _cameraKey.currentState?.openCamera(force: true);
        });
      } else {
        _cameraKey.currentState?.openCamera(force: true);
      }
    }
  }

  void _handleTabActivation() {
    if (_index == HomeShell.tabCamera) {
      _cameraKey.currentState?.handleTabSelected();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final appState = context.watch<AppState>();
    final title = switch (_index) {
      HomeShell.tabText => loc.t("text_search_title"),
      HomeShell.tabCamera => loc.t("scan_title"),
      HomeShell.tabSettings => loc.t("settings_title"),
      _ => loc.t("scan_title"),
    };

    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(title, style: DesignTokens.titleM),
        actions: const [],
      ),
      body: MaxWidthCenter(
        child: IndexedStack(
          index: _index,
          children: [
            const TextSearchPage(),
            CameraTabPage(key: _cameraKey),
            const SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) async {
          setState(() {
            _index = value;
          });
          await appState.setCurrentTabIndex(value);
          _handleTabActivation();
        },
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
      ),
    );
  }
}
