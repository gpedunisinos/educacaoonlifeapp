import 'dart:math' as math;

import 'package:flutter/material.dart';

class StarfieldBackground extends StatelessWidget {
  const StarfieldBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: _StarfieldPainter(),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  const _StarfieldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.black;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final starPaint = Paint()..style = PaintingStyle.fill;
    const starCount = 220;

    for (var i = 0; i < starCount; i++) {
      final xFactor = (math.sin(i * 12.9898) * 43758.5453).abs() % 1;
      final yFactor = (math.sin(i * 78.233) * 12345.6789).abs() % 1;
      final radiusFactor = (math.sin(i * 3.117) * 9631.417).abs() % 1;
      final alphaFactor = (math.sin(i * 5.173) * 7411.39).abs() % 1;

      final dx = xFactor * size.width;
      final dy = yFactor * size.height;
      final radius = 0.6 + (radiusFactor * 1.8);
      final alpha = 0.4 + (alphaFactor * 0.6);

      starPaint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(Offset(dx, dy), radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
