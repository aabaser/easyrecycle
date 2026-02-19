import "package:easy_recycle_flutter/models/city.dart";
import "package:easy_recycle_flutter/models/scan_result.dart";
import "package:easy_recycle_flutter/pages/camera_tab_page.dart";
import "package:easy_recycle_flutter/pages/result_page.dart";
import "package:easy_recycle_flutter/pages/text_search_page.dart";
import "package:easy_recycle_flutter/screens/landing/landing_screen.dart";
import "package:easy_recycle_flutter/state/app_state.dart";
import "package:easy_recycle_flutter/theme/app_theme.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:provider/provider.dart";

void main() {
  Future<void> pumpWithState(
    WidgetTester tester,
    Widget child, {
    Size size = const Size(390, 844),
  }) async {
    final appState = AppState()
      ..selectedCity = City(id: "berlin", name: "Berlin");
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          home: Scaffold(body: child),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  final mockFoundResult = ScanResult(
    state: ScanState.found,
    itemId: "id-1",
    itemName: "Lampe",
    confidence: ConfidenceLevel.medium,
    description: "Mock description",
    disposalMethod: "Restmüll",
    disposalSteps: const ["Step 1", "Step 2"],
    categories: const ["hausmuell"],
    disposalLabels: const ["Restabfall-Tonne"],
    bestOption: null,
    otherOptions: const [],
    warnings: const [],
    similarItems: const [],
    imageBytes: null,
    imageUrl: null,
    searchMode: SearchMode.text,
    queryText: "lampe",
  );

  testWidgets("golden_login_screen", (tester) async {
    await pumpWithState(tester, const LandingScreen());
    await expectLater(
      find.byType(LandingScreen),
      matchesGoldenFile("goldens/login_screen.png"),
    );
  }, skip: true);

  testWidgets("golden_camera_screen", (tester) async {
    await pumpWithState(tester, const CameraTabPage());
    await expectLater(
      find.byType(CameraTabPage),
      matchesGoldenFile("goldens/camera_screen.png"),
    );
  }, skip: true);

  testWidgets("golden_search_screen", (tester) async {
    await pumpWithState(tester, const TextSearchPage());
    await expectLater(
      find.byType(TextSearchPage),
      matchesGoldenFile("goldens/search_screen.png"),
    );
  }, skip: true);

  testWidgets("golden_results_screen", (tester) async {
    await pumpWithState(tester, ResultPage(result: mockFoundResult));
    await expectLater(
      find.byType(ResultPage),
      matchesGoldenFile("goldens/results_screen.png"),
    );
  }, skip: true);

  testWidgets("golden_detail_screen", (tester) async {
    await pumpWithState(tester, ResultPage(result: mockFoundResult));
    await expectLater(
      find.byType(ResultPage),
      matchesGoldenFile("goldens/detail_screen.png"),
    );
  }, skip: true);
}
