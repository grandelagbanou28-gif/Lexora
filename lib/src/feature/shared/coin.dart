import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A gold coin used to display the token balance.
class const Coin({final double size = 20, final double opacity = 1, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CoinPainter(opacity)),
    );
  }
}

final class _CoinPainter(final double opacity) extends CustomPainter {
  static const Color _edge = Color(0xFF6D4308);
  static const Color _bodyMid = Color(0xFFFBBF24);
  static const Color _bodyLight = Color(0xFFFFE082);
  static const Color _bodyDark = Color(0xFFC77800);
  static const Color _ring = Color(0xFF9A650F);
  static const Color _emblem = Color(0xFF8B5A00);
  static const Color _shade = Color(0xFF5C3A00);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.shortestSide / 2;

    final gradient = RadialGradient(
      colors: [_bodyLight, _bodyMid, _bodyDark].map((c) => c.withValues(alpha: opacity)).toList(growable: false),
      stops: const [0, 0.55, 1],
    );
    canvas
      ..drawCircle(center, radius, Paint()..color = _edge.withValues(alpha: opacity))
      ..drawCircle(
        center,
        radius - 1,
        Paint()..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius)),
      )
      ..drawCircle(
        center,
        radius * 0.72,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.09
          ..color = _ring.withValues(alpha: opacity),
      )
      ..drawPath(
        _star(center, outer: radius * 0.50, inner: radius * 0.20),
        Paint()..color = _emblem.withValues(alpha: opacity),
      )
      ..drawCircle(
        center.translate(-radius * 0.20, -radius * 0.26),
        radius * 0.55,
        Paint()
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
          ..color = Colors.white.withValues(alpha: 0.45 * opacity),
      )
      ..drawCircle(
        center.translate(radius * 0.16, radius * 0.30),
        radius * 0.6,
        Paint()
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
          ..color = _shade.withValues(alpha: 0.35 * opacity),
      );
  }

  Path _star(Offset center, {required double outer, required double inner}) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final pointRadius = i.isEven ? outer : inner;
      final double angle = -math.pi / 2 + i * math.pi / 5;
      final Offset point = center + Offset(math.cos(angle), math.sin(angle)) * pointRadius;
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    return path..close();
  }

  @override
  bool shouldRepaint(_CoinPainter oldDelegate) => oldDelegate.opacity != opacity;
}
