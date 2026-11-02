import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../foundation/theme.dart';
import '../foundation/tokens.g.dart';
import '../widgets/layout.dart';
import 'motion.dart';

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
  Widget build(BuildContext context) => Semantics(
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
  Widget build(BuildContext context) => Semantics(
    label: label,
    liveRegion: true,
    child: ExcludeSemantics(
      child: WantMotionBuilder(
        duration: const Duration(milliseconds: 1600),
        paused: paused,
        builder: (context, value) => ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment(-3 + value * 6, 0),
            end: Alignment(-1 + value * 6, 0),
            colors: [
              WantTheme.of(context).color('secondary'),
              WantTheme.of(context).color('shimmer-highlight'),
              WantTheme.of(context).color('secondary'),
            ],
            stops: const [0, .5, 1],
          ).createShader(rect),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              if (variant != WantShimmerVariant.text)
                WantSkeleton(
                  width: variant == WantShimmerVariant.avatar
                      ? 56
                      : double.infinity,
                  height: variant == WantShimmerVariant.avatar ? 56 : 140,
                  borderRadius: BorderRadius.circular(
                    variant == WantShimmerVariant.avatar ? 100 : 24,
                  ),
                ),
              if (variant == WantShimmerVariant.text ||
                  variant == WantShimmerVariant.card) ...[
                const FractionallySizedBox(
                  widthFactor: 1,
                  child: WantSkeleton(),
                ),
                const FractionallySizedBox(
                  widthFactor: .8,
                  child: WantSkeleton(),
                ),
                const FractionallySizedBox(
                  widthFactor: .6,
                  child: WantSkeleton(),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

enum WantTextEffect { fade, slide, blur }

class WantAnimatedText extends StatelessWidget {
  final String text;
  final WantTextEffect effect;
  final TextStyle? style;
  final bool liveRegion;
  const WantAnimatedText(
    this.text, {
    super.key,
    this.effect = WantTextEffect.slide,
    this.style,
    this.liveRegion = false,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: liveRegion,
    child: WantTheme.reducedMotionOf(context)
        ? Text(text, style: style)
        : TweenAnimationBuilder<double>(
            key: ValueKey(text),
            tween: Tween(begin: 0, end: 1),
            duration: WantTokens.motion['transitionMs']!,
            curve: const Cubic(.32, .72, 0, 1),
            child: Text(text, style: style),
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(
                  0,
                  effect == WantTextEffect.slide ? (1 - value) * 8 : 0,
                ),
                child: ImageFiltered(
                  enabled: effect == WantTextEffect.blur && value < 1,
                  imageFilter: ui.ImageFilter.blur(
                    sigmaX: (1 - value) * 4,
                    sigmaY: (1 - value) * 4,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
  );
}

class WantGlow extends StatelessWidget {
  final Widget child;
  final bool paused;
  final Color? color;
  final BorderRadius borderRadius;
  const WantGlow({
    super.key,
    required this.child,
    this.paused = false,
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.highContrastOf(context)) return child;
    final hue = color ?? WantTheme.of(context).color('primary');
    return WantMotionBuilder(
      duration: const Duration(milliseconds: 3600),
      paused: paused,
      builder: (context, phase) => Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        boxShadow: [
                          BoxShadow(
                            color: hue.withValues(alpha: .46),
                            blurRadius: 34,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    for (final offset in [0.0, .5])
                      Builder(
                        builder: (context) {
                          final t = (phase + offset) % 1;
                          return Transform.scale(
                            scale: 1 + t * .14,
                            child: Opacity(
                              opacity: (1 - t) * .65,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: borderRadius,
                                  border: Border.all(
                                    color: hue.withValues(alpha: .75),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: hue.withValues(alpha: .45),
                                      blurRadius: 14,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

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
class WantWand extends StatefulWidget {
  final Widget child;
  final bool enabled;
  const WantWand({super.key, required this.child, this.enabled = true});
  @override
  State<WantWand> createState() => _WantWandState();
}

class _WantWandState extends State<WantWand> {
  Offset _position = Offset.zero;
  int _trigger = 0;
  @override
  Widget build(BuildContext context) => Listener(
    onPointerHover: (event) {
      if (widget.enabled &&
          event.kind == PointerDeviceKind.mouse &&
          !WantTheme.reducedMotionOf(context) &&
          !MediaQuery.highContrastOf(context)) {
        setState(() {
          _position = event.localPosition;
          _trigger++;
        });
      }
    },
    child: WantMotionBuilder(
      duration: const Duration(milliseconds: 450),
      repeat: false,
      autoplay: false,
      restartKey: _trigger,
      paused: !widget.enabled,
      builder: (context, value) => Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_trigger > 0 && value < 1)
            Positioned(
              left: _position.dx - 12,
              top: _position.dy - 12,
              width: 24,
              height: 24,
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child: Opacity(
                    opacity: .45 * (1 - value),
                    child: Transform.rotate(
                      angle: value * math.pi,
                      child: CustomPaint(
                        size: const Size(12, 12),
                        painter: _SparkPainter(
                          WantTheme.of(context).color('primary'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class _SparkPainter extends CustomPainter {
  final Color color;
  _SparkPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(6, 0)
      ..lineTo(8, 4)
      ..lineTo(12, 6)
      ..lineTo(8, 8)
      ..lineTo(6, 12)
      ..lineTo(4, 8)
      ..lineTo(0, 6)
      ..lineTo(4, 4)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SparkPainter old) => color != old.color;
}
