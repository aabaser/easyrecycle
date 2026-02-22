import 'package:flutter/material.dart';

class DottedGradientDivider extends StatelessWidget {
  final double height;
  final double dotRadius;
  final List<Color> gradientColors;

  DottedGradientDivider({
    this.height = 1.0,
    this.dotRadius = 2.5,
    this.gradientColors = const [
      Colors.lightGreen,
      Colors.green,
      Colors.lightGreen,
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensures the divider spans full width
      height: height,
      child: CustomPaint(
        painter: _DottedGradientPainter(
          dotRadius: dotRadius,
          gradientColors: gradientColors,
        ),
      ),
    );
  }
}

class _DottedGradientPainter extends CustomPainter {
  final double dotRadius;
  final List<Color> gradientColors;

  _DottedGradientPainter({
    required this.dotRadius,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final double spacing = dotRadius * 3; // Spacing between dots
    double startX = 0;

    while (startX < size.width) {
      canvas.drawCircle(Offset(startX, size.height / 2), dotRadius, paint);
      startX += spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
