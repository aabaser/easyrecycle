import "package:flutter/material.dart";

class BrandTitle extends StatelessWidget {
  const BrandTitle({super.key, this.textStyle});

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseStyle = textStyle ??
        Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            );
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(
            text: "Easy ",
            style: TextStyle(color: colorScheme.secondary),
          ),
          TextSpan(
            text: "Recycle",
            style: TextStyle(color: colorScheme.onSurface),
          ),
          TextSpan(
            text: "•",
            style: TextStyle(color: colorScheme.tertiary),
          ),
        ],
      ),
    );
  }
}
