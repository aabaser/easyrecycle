import "package:flutter/material.dart";

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 44,
    this.zoom = 4.0,
    this.alignment = const Alignment(-0.07, 0.05),
  });

  final double size;
  final double zoom;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRect(
        child: Align(
          alignment: alignment,
          child: Transform.scale(
            scale: zoom,
            child: Image.asset(
              "assets/logo/app_logo_mark_512.png",
              width: size,
              height: size,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
