import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:wordly/src/core/resources/resources.dart';

const List<Color> _confettiPalette = [
  AppColors.green,
  AppColors.yellow,
  AppColors.orange,
  AppColors.blue,
  Colors.pinkAccent,
  Colors.purpleAccent,
];

/// Shows a full-screen confetti celebration above everything.
void showConfettiBurst(BuildContext context, {int particles = 90}) {
  final OverlayState overlay = Overlay.of(context, rootOverlay: true);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => IgnorePointer(
      child: ConfettiBurst(particleCount: particles, onFinished: () => entry.remove()),
    ),
  );
  overlay.insert(entry);
}

class const ConfettiBurst({required final int particleCount, final VoidCallback? onFinished, super.key})
    extends StatefulWidget {
  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState() extends State<ConfettiBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onFinished?.call();
        }
      });
    _particles = List.generate(widget.particleCount, (_) => _randomParticle(_random));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(elapsed: _controller.value * 2800, particles: _particles),
        ),
      ),
    );
  }
}

class _Particle({
  required final double startX,
  required final double delay,
  required final double speed,
  required final double swayAmplitude,
  required final double swayFrequency,
  required final double spin,
  required final double size,
  required final Color color,
  required final bool isCircle,
}) {
  // Purely data holder: no members, fields come from the primary constructor.
}

_Particle _randomParticle(math.Random r) {
  return _Particle(
    startX: r.nextDouble(),
    delay: r.nextDouble() * 250,
    speed: 1.1 + r.nextDouble() * 0.7,
    swayAmplitude: 0.06 * (0.3 + r.nextDouble()),
    swayFrequency: (math.pi * 2) * (0.6 + r.nextDouble() * 1.2),
    spin: (r.nextDouble() - 0.5) * 10,
    size: 6 + r.nextDouble() * 7,
    color: _confettiPalette[r.nextInt(_confettiPalette.length)],
    isCircle: r.nextBool(),
  );
}

class _ConfettiPainter({required final double elapsed, required final List<_Particle> particles})
    extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (final _Particle p in particles) {
      final double t = ((elapsed - p.delay) / 1000).clamp(0.0, double.infinity);
      if (t <= 0) {
        continue;
      }
      final double x = p.startX * size.width + math.sin(p.swayFrequency * t) * p.swayAmplitude * size.width;
      final double y = (p.speed * t - 1 / 12) * size.height;
      final paint = Paint()..color = p.color;
      canvas
        ..save()
        ..translate(x, y)
        ..rotate(p.spin * t);
      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.45),
            const Radius.circular(1.5),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.elapsed != elapsed;
}
