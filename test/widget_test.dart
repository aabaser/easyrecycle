import "package:easy_recycle_flutter/theme/app_theme.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("App theme smoke test", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: Center(child: Text("Easy Recycle"))),
      ),
    );

    expect(find.text("Easy Recycle"), findsOneWidget);
  });
}
