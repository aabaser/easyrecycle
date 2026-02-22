import 'package:flutter/material.dart';

class NavigationUtil {
  void navigateToPage(BuildContext context, Widget? destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination!),
    );
  }

  /// Navigate back to the previous screen.
  ///
  /// If there is a previous screen on the navigation stack, this function pops
  /// the current screen off the stack and returns to the previous screen. If a
  /// [result] is provided, it will be passed back to the previous screen.
  void finish(BuildContext context, [Object? result]) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
    }
  }

  /// Navigates to a new screens.
  ///
  /// The `routeName` parameter specifies the name of the screens to navigate to.
  /// The `arguments` parameter (optional) provides additional arguments to pass to the new screens.
  static void navigateTo(BuildContext context, String routeName,
      {Object? arguments}) {
    try {
      Navigator.pushNamed(context, routeName, arguments: arguments);
    } catch (error) {
      debugPrint('Navigation Error: $error');
      // Handle the error as needed
    }
  }

  /// Navigates to a new screens asynchronously and returns a result from the destination screen.
  ///
  /// The `routeName` parameter specifies the name of the screens to navigate to.
  /// The `arguments` parameter (optional) provides additional arguments to pass to the new screens.
  ///
  /// Returns the result returned from the destination screen, if any.
  static Future<dynamic> navigateToAsync(BuildContext context, String routeName,
      {Object? arguments}) async {
    try {
      return await Navigator.pushNamed(context, routeName,
          arguments: arguments);
    } catch (error) {
      debugPrint('Navigation Error: $error');
      return null; // Handle the error as needed
    }
  }

  /// Navigates to a new screens and replaces the current screens in the navigation stack.
  ///
  /// The `routeName` parameter specifies the name of the screens to navigate to.
  /// The `arguments` parameter (optional) provides additional arguments to pass to the new screens.
  static void navigateToReplacement(BuildContext context, String routeName,
      {Object? arguments}) {
    try {
      Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
    } catch (error) {
      debugPrint('Navigation Error: $error');
      // Handle the error as needed
    }
  }

  /// Navigates to a new screens and removes all previous routes from the navigation stack.
  ///
  /// The `routeName` parameter specifies the name of the screens to navigate to.
  /// The `arguments` parameter (optional) provides additional arguments to pass to the new screens.
  static void navigateToAndRemoveUntil(BuildContext context, String routeName,
      {Object? arguments}) {
    try {
      Navigator.pushNamedAndRemoveUntil(
        context,
        routeName,
        (Route<dynamic> route) => false, // Remove all previous routes
        arguments: arguments,
      );
    } catch (error) {
      debugPrint('Navigation Error: $error');
      // Handle the error as needed
    }
  }

  /// Navigates back to the previous screens and optionally returns a result to the calling screen.
  ///
  /// The `context` parameter specifies the BuildContext of the current screen.
  /// The `result` parameter (optional) is the value to be returned as the result of the previous screens.
  static void navigateBack(BuildContext context, {Object? result}) {
    try {
      Navigator.pop(context, result);
    } catch (error) {
      debugPrint('Navigation Error: $error');
      // Handle the error as needed
    }
  }
}
