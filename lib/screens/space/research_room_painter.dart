import 'package:flutter/material.dart';

class ResearchRoomPainter extends CustomPainter {
  const ResearchRoomPainter();
  @override
  void paint(Canvas c, Size s) {
    final rect = Offset.zero & s;
    c.drawRect(
      rect,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(.35, -.2),
          radius: 1.1,
          colors: [Color(0xFF1B3447), Color(0xFF050B18)],
        ).createShader(rect),
    );
    final pen = Paint()
      ..color = const Color(0x333D8E9C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 0; i < 8; i++) {
      final x = s.width * i / 7;
      c.drawLine(
        Offset(s.width * .5, s.height * .65),
        Offset(x, s.height),
        pen,
      );
    }
    for (final y in [.76, .84, .95]) {
      c.drawLine(Offset(0, s.height * y), Offset(s.width, s.height * y), pen);
    }
    for (final right in [false, true]) {
      final x = right ? s.width : 0.0;
      final sign = right ? -1 : 1;
      final p = Path()
        ..moveTo(x, 0)
        ..lineTo(x + sign * s.width * .07, s.height * .13)
        ..lineTo(x + sign * s.width * .07, s.height * .82)
        ..lineTo(x, s.height)
        ..close();
      c.drawPath(p, Paint()..color = const Color(0xD9040D19));
      c.drawPath(p, pen);
      c.drawLine(
        Offset(x, s.height * .06),
        Offset(x + sign * s.width * .07, s.height * .17),
        Paint()
          ..color = const Color(0x8872D5CE)
          ..strokeWidth = 2,
      );
    }
    c.drawOval(
      Rect.fromCenter(
        center: Offset(s.width * .5, s.height * .08),
        width: s.width * .7,
        height: s.height * .13,
      ),
      pen,
    );
  }

  @override
  bool shouldRepaint(ResearchRoomPainter old) => false;
}
