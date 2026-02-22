import 'package:flutter/material.dart';

class MyText {
  static TextStyle? display4(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle? display3(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle? display2(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle? display1(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle? headline(BuildContext context) {
    //return Theme.of(context).textTheme.headlineSmall;
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontSize: 20,
        );
  }

  static TextStyle? title(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium;
  }

  static TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontSize: 18,
        );
  }

  static TextStyle? subhead(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall;
  }

  static TextStyle? body2(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium;
  }

  static TextStyle? body1(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium;
  }

  static TextStyle? caption(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall;
  }

  static TextStyle? button(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(letterSpacing: 1);
  }

  static TextStyle? subtitle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall;
  }

  static TextStyle? overline(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall;
  }
}
