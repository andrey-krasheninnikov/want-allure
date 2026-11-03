import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantConfetti extends StatelessWidget {
  final Widget child;
  final int trigger;
  const WantConfetti({super.key, required this.child, required this.trigger});
  @override
  Widget build(BuildContext context) => WantMotionBuilder(
    duration: WantTokens.motion['confettiMs']!,
    repeat: false,
    autoplay: false,
    restartKey: trigger,
    paused: MediaQuery.highContrastOf(context),
    builder: (context, value) => Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: CustomPaint(
                painter: _ConfettiPainter(value, WantTheme.of(context).colors),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ConfettiPainter extends CustomPainter {
  final double t;
  final Map<String, Color> colors;
  _ConfettiPainter(this.t, this.colors);
  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0 || t >= 1) return;
    final center = size.center(Offset.zero), paint = Paint();
    final palette = ['primary', 'success', 'info', 'warning', 'error'];
    for (var i = 0; i < 24; i++) {
      final angle = i * math.pi * 2 / 24;
      final position =
          center +
          Offset(
            math.cos(angle) * t * 140,
            math.sin(angle) * t * 100 + 100 * t * t,
          );
      paint.color = colors[palette[i % palette.length]]!.withValues(
        alpha: 1 - t,
      );
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(angle + t * 6);
      canvas.drawRect(const Rect.fromLTWH(-3, -2, 6, 4), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) =>
      old.t != t || old.colors != colors;
}

/// Wrap an interactive control to opt into pointer sparks.
