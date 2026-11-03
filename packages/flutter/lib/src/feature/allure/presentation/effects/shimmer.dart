import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

enum WantShimmerVariant { block, text, avatar, card }

class WantShimmer extends StatelessWidget {
  final String label;
  final WantShimmerVariant variant;
  final bool paused;
  const WantShimmer({
    super.key,
    required this.label,
    this.variant = WantShimmerVariant.block,
    this.paused = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = WantTheme.of(context);
    final height = switch (variant) {
      WantShimmerVariant.avatar => 56.0,
      WantShimmerVariant.text => 84.0,
      WantShimmerVariant.card => 236.0,
      WantShimmerVariant.block => 140.0,
    };
    Widget paint(ui.FragmentShader? shader, double phase) => CustomPaint(
      painter: _ShimmerPainter(
        variant,
        phase,
        theme.color('secondary'),
        theme.color('shimmer-highlight'),
        shader,
      ),
      child: const SizedBox.expand(),
    );
    final fallback = paint(null, 0);
    return WantViewportMotion(
      child: Semantics(
        label: label,
        liveRegion: true,
        child: ExcludeSemantics(
          child: SizedBox(
            width: variant == WantShimmerVariant.avatar ? 56 : double.infinity,
            height: height,
            child:
                WantTheme.reducedMotionOf(context) ||
                    MediaQuery.highContrastOf(context)
                ? fallback
                : WantShaderSurface(
                    asset: 'shimmer.frag',
                    fallback: fallback,
                    builder: (context, shader) => WantMotionBuilder(
                      duration: const Duration(milliseconds: 1800),
                      paused: paused,
                      builder: (context, phase) => paint(shader, phase),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  final WantShimmerVariant variant;
  final double phase;
  final Color base, highlight;
  final ui.FragmentShader? shader;
  _ShimmerPainter(
    this.variant,
    this.phase,
    this.base,
    this.highlight,
    this.shader,
  );
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = base;
    if (shader case final shader?) {
      final values = [
        size.width,
        size.height,
        phase,
        0.0,
        base.r,
        base.g,
        base.b,
        base.a,
        highlight.r,
        highlight.g,
        highlight.b,
        highlight.a,
      ];
      for (var i = 0; i < values.length; i++) {
        shader.setFloat(i, values[i]);
      }
      paint.shader = shader;
    }
    void shape(Rect rect, double radius) => canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
    if (variant == WantShimmerVariant.avatar) {
      shape(Offset.zero & size, 100);
    } else {
      if (variant != WantShimmerVariant.text) {
        shape(Rect.fromLTWH(0, 0, size.width, 140), 24);
      }
      if (variant == WantShimmerVariant.text ||
          variant == WantShimmerVariant.card) {
        final top = variant == WantShimmerVariant.card ? 152.0 : 0.0;
        for (var i = 0; i < 3; i++) {
          shape(
            Rect.fromLTWH(0, top + i * 32, size.width * (1 - i * .2), 20),
            10,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) =>
      phase != old.phase ||
      variant != old.variant ||
      base != old.base ||
      highlight != old.highlight ||
      shader != old.shader;
}
