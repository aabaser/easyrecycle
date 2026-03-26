import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../navigation/home_shell.dart";
import "../pages/recycle_centers_page.dart";
import "../state/app_state.dart";

void openRecycleCentersTab(
  BuildContext context, {
  required String cityCode,
  int? typCode,
  String? disposalPositive,
}) {
  final appState = context.read<AppState>();
  appState.requestRecycleCenterFilter(
    cityCode: cityCode,
    typCode: typCode,
    disposalPositive: disposalPositive,
  );
  appState.requestTab(HomeShell.tabRecycleCenters);
  Navigator.of(context).popUntil((route) => route.isFirst);
}

Future<void> pushRecycleCentersPage(
  BuildContext context, {
  required String cityCode,
  int? typCode,
  String? disposalPositive,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => RecycleCentersPage(
        cityCode: cityCode,
        initialTypeCode: typCode,
        initialDisposalPositive: disposalPositive,
      ),
    ),
  );
}
