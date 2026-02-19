import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../widgets/max_width_center.dart";
import "../pages/camera_tab_page.dart";
import "../pages/text_search_page.dart";
import "../pages/settings_page.dart";
import "nav_keys.dart";
import "tab_navigator.dart";

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
  final _textKey = GlobalKey<TextSearchPageState>();
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
      _handleTabActivation();
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
    _textKey.currentState?.setActive(_index == HomeShell.tabText);
    _cameraKey.currentState?.setActive(_index == HomeShell.tabCamera);
    if (_index == HomeShell.tabCamera) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _cameraKey.currentState?.openCamera(force: true);
      });
    }
  }

  GlobalKey<NavigatorState> _currentNavKey() {
    return switch (_index) {
      HomeShell.tabText => NavKeys.textTab,
      HomeShell.tabCamera => NavKeys.cameraTab,
      HomeShell.tabSettings => NavKeys.settingsTab,
      _ => NavKeys.cameraTab,
    };
  }

  Future<bool> _onWillPop() async {
    final navKey = _currentNavKey();
    final navigator = navKey.currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return false;
    }
    return true;
  }

  void _onTabSelected(int value) async {
    final appState = context.read<AppState>();
    if (value == _index) {
      if (value == HomeShell.tabCamera) {
        _cameraKey.currentState?.openCamera(force: true);
        return;
      }
      final navKey = _currentNavKey();
      navKey.currentState?.popUntil((route) => route.isFirst);
      return;
    }
    setState(() {
      _index = value;
    });
    await appState.setCurrentTabIndex(value);
    _handleTabActivation();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final title = switch (_index) {
      HomeShell.tabText => loc.t("text_search_title"),
      HomeShell.tabCamera => loc.t("scan_title"),
      HomeShell.tabSettings => loc.t("settings_title"),
      _ => loc.t("scan_title"),
    };

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final shouldExit = await _onWillPop();
        if (shouldExit && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text(title, style: DesignTokens.titleM),
          actions: const [],
          flexibleSpace: Align(
            alignment: Alignment.topCenter,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.09,
                child: Image.asset(
                  "assets/uix/bg_top_abstract.png",
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ),
        body: MaxWidthCenter(
          child: IndexedStack(
            index: _index,
            children: [
              TabNavigator(
                navigatorKey: NavKeys.textTab,
                root: TextSearchPage(key: _textKey),
              ),
              TabNavigator(
                navigatorKey: NavKeys.cameraTab,
                root: CameraTabPage(key: _cameraKey),
              ),
              TabNavigator(
                navigatorKey: NavKeys.settingsTab,
                root: SettingsPage(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _onTabSelected,
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
      ),
    );
  }
}
