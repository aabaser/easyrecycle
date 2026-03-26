import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../models/city.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";
import "../widgets/city_pills.dart";
import "../widgets/max_width_center.dart";
import "../pages/camera_tab_page.dart";
import "../pages/recycle_centers_page.dart";
import "../pages/text_search_page.dart";
import "nav_keys.dart";
import "tab_navigator.dart";

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  static const int tabText = 0;
  static const int tabCamera = 1;
  static const int tabRecycleCenters = 2;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final _cameraKey = GlobalKey<CameraTabPageState>();
  final _textKey = GlobalKey<TextSearchPageState>();
  late int _index;
  late int _lastCitySelectionVersion;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _index = _sanitizeTabIndex(appState.currentTabIndex);
    _lastCitySelectionVersion = appState.citySelectionVersion;
    appState.addListener(_handleAppState);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (appState.currentTabIndex != _index) {
        appState.setCurrentTabIndex(_index);
      }
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
    if (appState.citySelectionVersion != _lastCitySelectionVersion) {
      _lastCitySelectionVersion = appState.citySelectionVersion;
      _resetCityScopedUiState();
    }
    final requestedTabRaw = appState.consumeRequestedTab();
    final requestedTab =
        requestedTabRaw == null ? null : _sanitizeTabIndex(requestedTabRaw);
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

  void _resetCityScopedUiState() {
    _textKey.currentState?.resetForCityChange();
    _cameraKey.currentState?.resetForCityChange();
    NavKeys.textTab.currentState?.popUntil((route) => route.isFirst);
    NavKeys.cameraTab.currentState?.popUntil((route) => route.isFirst);
    NavKeys.recycleCentersTab.currentState?.popUntil((route) => route.isFirst);
  }

  void _handleTabActivation() {
    _textKey.currentState?.setActive(_index == HomeShell.tabText);
    _cameraKey.currentState?.setActive(_index == HomeShell.tabCamera);
  }

  int _sanitizeTabIndex(int value) {
    if (value < HomeShell.tabText || value > HomeShell.tabRecycleCenters) {
      return HomeShell.tabCamera;
    }
    return value;
  }

  GlobalKey<NavigatorState> _currentNavKey() {
    return switch (_index) {
      HomeShell.tabText => NavKeys.textTab,
      HomeShell.tabCamera => NavKeys.cameraTab,
      HomeShell.tabRecycleCenters => NavKeys.recycleCentersTab,
      _ => NavKeys.cameraTab,
    };
  }

  Future<bool> _onWillPop() async {
    if (_index == HomeShell.tabCamera &&
        (_cameraKey.currentState?.handleBackPress() ?? false)) {
      return false;
    }
    final navKey = _currentNavKey();
    final navigator = navKey.currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return false;
    }
    return true;
  }

  Future<void> _exitApp() async {
    if (kIsWeb) {
      return;
    }
    await SystemNavigator.pop();
  }

  Future<void> _openQuickSettings(
    BuildContext context,
    AppLocalizations loc,
    AppState appState,
    List<City> cityOptions,
  ) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: colorScheme.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.t("settings_city"),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                CityPills(
                  cities: cityOptions,
                  selectedCityId: appState.selectedCity?.id,
                  onSelected: (city) {
                    appState.setSelectedCity(city);
                    Navigator.of(sheetContext).pop();
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Dark Mode"),
                  value: appState.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    appState.setThemeMode(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onTabSelected(int value) async {
    value = _sanitizeTabIndex(value);
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
    final appState = context.watch<AppState>();
    final recycleTabLabel =
        switch (Localizations.localeOf(context).languageCode) {
      "de" => "Recyclinghof",
      "tr" => "Merkez",
      _ => "Center",
    };
    final cityOptions = City.defaults(
      berlinName: loc.t("city_berlin"),
      hannoverName: loc.t("city_hannover"),
    );
    final title = switch (_index) {
      HomeShell.tabText => loc.t("text_search_title"),
      HomeShell.tabCamera => loc.t("scan_title"),
      HomeShell.tabRecycleCenters => loc.t("find_recycling_center"),
      _ => loc.t("scan_title"),
    };

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final shouldExit = await _onWillPop();
        if (shouldExit && context.mounted) {
          await _exitApp();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: null,
          title: Text(title, style: DesignTokens.titleM),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              onPressed: () {
                _openQuickSettings(context, loc, appState, cityOptions);
              },
            ),
          ],
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
                navigatorKey: NavKeys.recycleCentersTab,
                root: const RecycleCentersPage(showAppBar: false),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _onTabSelected,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.search_rounded),
              label: loc.t("nav_text"),
            ),
            NavigationDestination(
              icon: const Icon(Icons.camera_alt_rounded),
              label: loc.t("nav_camera"),
            ),
            NavigationDestination(
              icon: const Icon(Icons.location_on_rounded),
              label: recycleTabLabel,
            ),
          ],
        ),
      ),
    );
  }
}
