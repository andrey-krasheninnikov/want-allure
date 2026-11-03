import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

enum WantLoaderVariant { spinner, dots, bars, orbit }

enum WantLoaderSize { small, medium, large }

class WantLoader extends StatelessWidget {
  final String label;
  final WantLoaderVariant variant;
  final WantLoaderSize size;
  final bool paused;
  const WantLoader({
    super.key,
    required this.label,
    this.variant = WantLoaderVariant.spinner,
    this.size = WantLoaderSize.medium,
    this.paused = false,
  });
  @override
  Widget build(BuildContext context) => WantViewportMotion(
    child: Semantics(
      label: label,
      liveRegion: true,
      child: ExcludeSemantics(
        child: WantMotionBuilder(
          duration: const Duration(milliseconds: 1200),
          paused: paused,
          builder: (context, value) => SizedBox.square(
            dimension: switch (size) {
              WantLoaderSize.small => 20,
              WantLoaderSize.medium => 32,
              WantLoaderSize.large => 48,
            },
            child: CustomPaint(
              painter: _LoaderPainter(
                value,
                variant,
                WantTheme.of(context).color('primary'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _LoaderPainter extends CustomPainter {
  final double phase;
  final WantLoaderVariant variant;
  final Color color;
  _LoaderPainter(this.phase, this.variant, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero), radius = size.shortestSide * .38;
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * .09
      ..strokeCap = StrokeCap.round;
    if (variant == WantLoaderVariant.spinner) {
      paint.style = PaintingStyle.stroke;
      canvas.drawCircle(
        center,
        radius,
        paint..color = color.withValues(alpha: .18),
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        phase * math.pi * 2,
        math.pi * 1.25,
        false,
        paint..color = color,
      );
    } else if (variant == WantLoaderVariant.orbit) {
      for (var i = 0; i < 3; i++) {
        final angle = phase * math.pi * 2 + i * math.pi * 2 / 3;
        canvas.drawCircle(
          center + Offset(math.cos(angle), math.sin(angle)) * radius,
          size.width * (.07 + i * .015),
          paint..color = color.withValues(alpha: .4 + i * .3),
        );
      }
    } else {
      final count = variant == WantLoaderVariant.bars ? 5 : 3;
      for (var i = 0; i < count; i++) {
        final wave = (math.sin((phase - i * .15) * math.pi * 2) + 1) / 2;
        paint.color = color.withValues(alpha: .35 + wave * .65);
        final x = size.width * (i + .5) / count;
        if (variant == WantLoaderVariant.bars) {
          final height = size.height * (.25 + wave * .6);
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(x, center.dy),
                width: size.width / count * .55,
                height: height,
              ),
              const Radius.circular(4),
            ),
            paint,
          );
        } else {
          canvas.drawCircle(
            Offset(x, center.dy - wave * size.height * .12),
            size.width * .09,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_LoaderPainter old) =>
      phase != old.phase || variant != old.variant || color != old.color;
}
