import 'dart:math' as math;
import 'package:flutter/material.dart';

const _bands = [4, 12, 18, 22, 24, 22, 18, 12, 4];
(double, double) _angles(int slot) {
  var offset = 0;
  for (var row = 0; row < _bands.length; row++) {
    if (slot < offset + _bands[row]) {
      return (
        (row * 20 - 80) * math.pi / 180,
        (slot - offset) * math.pi * 2 / _bands[row],
      );
    }
    offset += _bands[row];
  }
  return (0, 0);
}

/// Shipboard projection of the same organized, hollow card moon as the landmark.
class ClueMoonHologram extends StatelessWidget {
  const ClueMoonHologram({
    super.key,
    required this.phase,
    required this.slot,
    required this.title,
    required this.reduced,
  });
  final double phase;
  final int? slot;
  final String title;
  final bool reduced;
  @override
  Widget build(BuildContext context) => Semantics(
    label: slot == null
        ? 'Lua de Pistas sem seleção'
        : 'Card destacado na lua: $title',
    image: true,
    child: TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: reduced ? 0 : 1100),
      curve: Curves.easeInOutCubic,
      tween: Tween(end: slot == null ? 0 : -_angles(slot!).$2),
      builder: (_, yaw, _) => CustomPaint(
        painter: _MoonPainter(
          yaw: yaw + (reduced ? 0 : math.sin(phase) * .10),
          phase: reduced ? 0 : phase,
          selected: slot,
          title: title,
        ),
        child: const SizedBox.expand(),
      ),
    ),
  );
}

class _MoonPainter extends CustomPainter {
  const _MoonPainter({
    required this.yaw,
    required this.phase,
    required this.selected,
    required this.title,
  });
  final double yaw;
  final double phase;
  final int? selected;
  final String title;
  @override
  void paint(Canvas canvas, Size size) {
    final r = math.min(size.width * .34, size.height * .36);
    final center = Offset(size.width / 2, size.height * .43);
    const ice = Color(0xFF8BDDDC);
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [ice.withValues(alpha: .10), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: r * 1.7));
    canvas.drawCircle(center, r * 1.7, glow);
    final cards =
        <({int id, double x, double y, double z, double lat, double lon})>[];
    for (var i = 0; i < 136; i++) {
      final (lat, lon) = _angles(i);
      cards.add((
        id: i,
        x: math.sin(lon + yaw) * math.cos(lat),
        y: math.sin(lat),
        z: math.cos(lon + yaw) * math.cos(lat),
        lat: lat,
        lon: lon + yaw,
      ));
    }
    cards.sort((a, b) => a.z.compareTo(b.z));
    Offset project(double x, double y, double z) {
      final perspective = 4 / (4 - z * .65);
      return center + Offset(x * r * perspective, -y * r * perspective);
    }

    for (final card in cards) {
      final active = card.id == selected;
      final expansion = active ? 1.10 : 1.0;
      final x = card.x * expansion;
      final y = card.y * expansion;
      final z = card.z * expansion;
      final rightX = math.cos(card.lon);
      final rightZ = -math.sin(card.lon);
      final upX = -math.sin(card.lon) * math.sin(card.lat);
      final upY = math.cos(card.lat);
      final upZ = -math.cos(card.lon) * math.sin(card.lat);
      final corners = [
        for (final pair in [(-1.0, 1.0), (1.0, 1.0), (1.0, -1.0), (-1.0, -1.0)])
          project(
            x + rightX * pair.$1 * .115 + upX * pair.$2 * .15,
            y + upY * pair.$2 * .15,
            z + rightZ * pair.$1 * .115 + upZ * pair.$2 * .15,
          ),
      ];
      final path = Path()..addPolygon(corners, true);
      final front = card.z > 0;
      final tint = active ? const Color(0xFFFFDF9B) : ice;
      if (active && front) {
        canvas.drawPath(
          path,
          Paint()
            ..color = tint.withValues(alpha: .35 + math.sin(phase * 8) * .08)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
        );
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = active
              ? const Color(0xFF31504E)
              : front
              ? const Color(0xFF102F3C)
              : const Color(0xFF0B1929),
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = tint.withValues(
            alpha: active
                ? 1
                : front
                ? .55
                : .17,
          )
          ..strokeWidth = active ? 1.7 : .65
          ..style = PaintingStyle.stroke,
      );
      if (front) {
        if (active && path.getBounds().width > 30) {
          final bounds = path.getBounds().deflate(5);
          final text = TextPainter(
            text: TextSpan(
              text: title,
              style: TextStyle(color: tint, fontSize: math.max(5, r * .025)),
            ),
            maxLines: 2,
            ellipsis: '…',
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: bounds.width);
          canvas.save();
          canvas.clipPath(path);
          text.paint(canvas, bounds.topLeft);
          canvas.restore();
        }
        for (final v in active ? [.5, .7, .83] : [.28, .48, .68]) {
          final a = Offset.lerp(corners[0], corners[3], v)!;
          final b = Offset.lerp(corners[1], corners[2], v)!;
          canvas.drawLine(
            Offset.lerp(a, b, .18)!,
            Offset.lerp(a, b, v == .28 ? .82 : .65)!,
            Paint()
              ..color = tint.withValues(alpha: active ? .85 : .25)
              ..strokeWidth = 1,
          );
        }
      }
    }
    final base = Offset(center.dx, size.height * .87);
    final pen = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final scale in [1.0, 1.2]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: base,
          width: r * 2 * scale,
          height: r * .24 * scale,
        ),
        pen..color = ice.withValues(alpha: scale == 1 ? .5 : .18),
      );
    }
    final label = TextPainter(
      text: TextSpan(
        text: selected == null
            ? 'ARQUIVO HOLOGRÁFICO'
            : 'PISTA LOCALIZADA · CARD EM DESTAQUE',
        style: const TextStyle(color: ice, fontSize: 9, letterSpacing: 1.5),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);
    label.paint(
      canvas,
      Offset((size.width - label.width) / 2, size.height * .94),
    );
  }

  @override
  bool shouldRepaint(_MoonPainter old) =>
      yaw != old.yaw ||
      phase != old.phase ||
      selected != old.selected ||
      title != old.title;
}
