import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

/// A decorative shader surface. Supply bounded constraints, for example Positioned.fill.
class WantLightningBackground extends StatelessWidget {
  final bool paused;
  final List<Color>? colors;
  const WantLightningBackground({super.key, this.paused = false, this.colors})
    : assert(colors == null || colors.length == 2);
  @override
  Widget build(BuildContext context) {
    final theme = WantTheme.of(context);
    final primary = colors?[0] ?? theme.color('primary');
    final warning = colors?[1] ?? theme.color('warning');
    final fallback = CustomPaint(
      painter: _LightningPainter(null, 0, primary, warning),
      child: const SizedBox.expand(),
    );
    return IgnorePointer(
      child: ExcludeSemantics(
        child: WantViewportMotion(
          child: MediaQuery.highContrastOf(context)
              ? const SizedBox.expand()
              : WantTheme.reducedMotionOf(context)
              ? fallback
              : WantShaderSurface(
                  asset: 'lightning.frag',
                  fallback: fallback,
                  builder: (context, shader) => WantMotionBuilder(
                    duration: const Duration(seconds: 9),
                    paused: paused,
                    builder: (context, phase) => CustomPaint(
                      painter: _LightningPainter(
                        shader,
                        phase * 9,
                        primary,
                        warning,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _LightningPainter extends CustomPainter {
  final ui.FragmentShader? shader;
  final double time;
  final Color primary, warning;
  _LightningPainter(this.shader, this.time, this.primary, this.warning);
  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    if (shader case final program?) {
      // Quiet intervals need no fragment work.
      if (time > 1.8 && (time < 4.5 || time > 6.3)) return;
      final values = [
        size.width,
        size.height,
        time,
        primary.r,
        primary.g,
        primary.b,
        primary.a,
        warning.r,
        warning.g,
        warning.b,
        warning.a,
      ];
      for (var i = 0; i < values.length; i++) {
        program.setFloat(i, values[i]);
      }
      canvas.drawRect(Offset.zero & size, Paint()..shader = program);
    } else {
      for (var side = 0; side < 2; side++) {
        final path = Path();
        for (var i = 0; i <= 12; i++) {
          final x =
              size.width * ((side == 0 ? .24 : .76) + (i.isEven ? -.04 : .04));
          final y = size.height * i / 12;
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        canvas.drawPath(
          path,
          Paint()
            ..color = (side == 0 ? primary : warning).withValues(alpha: .12)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_LightningPainter old) =>
      old.time != time ||
      old.shader != shader ||
      old.primary != primary ||
      old.warning != warning;
}
