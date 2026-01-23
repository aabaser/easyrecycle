import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class MaxWidthCenter extends StatelessWidget {
  const MaxWidthCenter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return child;
    }
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: child,
      ),
    );
  }
}
