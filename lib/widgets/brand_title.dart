import "package:flutter/material.dart";

class BrandTitle extends StatelessWidget {
  const BrandTitle({super.key, this.textStyle});

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final baseStyle = textStyle ??
        Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            );
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: baseStyle,
        children: const [
          TextSpan(
            text: "Easy ",
            style: TextStyle(color: Color(0xFF4338CA)),
          ),
          TextSpan(
            text: "Recycle",
            style: TextStyle(color: Color(0xFF0B1220)),
          ),
          TextSpan(
            text: "•",
            style: TextStyle(color: Color(0xFF22D3EE)),
          ),
        ],
      ),
    );
  }
}
