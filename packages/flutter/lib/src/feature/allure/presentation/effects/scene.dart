import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantThreadsBackground extends StatefulWidget {
  final bool paused;
  final Widget child;
  const WantThreadsBackground({
    super.key,
    this.paused = false,
    required this.child,
  });

  @override
  State<WantThreadsBackground> createState() => _WantThreadsBackgroundState();
}

class _WantThreadsBackgroundState extends State<WantThreadsBackground> {
  Offset _pointer = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final protected =
        MediaQuery.highContrastOf(context) ||
        WantTheme.reducedMotionOf(context);
    final paused = widget.paused || protected;
    final color = WantTheme.of(context).color('primary');
    return LayoutBuilder(
      builder: (context, box) => MouseRegion(
        onHover: paused || !box.hasBoundedWidth || !box.hasBoundedHeight
            ? null
            : (event) => setState(() {
                _pointer = Offset(
                  event.localPosition.dx / box.maxWidth - .5,
                  event.localPosition.dy / box.maxHeight - .5,
                );
              }),
        onExit: (_) {
          if (_pointer != Offset.zero) setState(() => _pointer = Offset.zero);
        },
        child: Stack(
          children: [
            if (!MediaQuery.highContrastOf(context))
              Positioned.fill(
                child: IgnorePointer(
                  child: WantShaderSurface(
                    asset: 'threads.frag',
                    fallback: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withValues(alpha: .06),
                            color.withValues(alpha: .16),
                          ],
                        ),
                      ),
                    ),
                    builder: (context, shader) => WantViewportMotion(
                      child: WantMotionBuilder(
                        duration: const Duration(seconds: 8),
                        paused: paused,
                        builder: (context, phase) => CustomPaint(
                          painter: _ThreadsPainter(
                            shader,
                            color,
                            paused ? Offset.zero : _pointer,
                            phase,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            widget.child,
          ],
        ),
      ),
    );
  }
}

class _ThreadsPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final Color color;
  final Offset pointer;
  final double phase;
  const _ThreadsPainter(this.shader, this.color, this.pointer, this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, pointer.dx)
      ..setFloat(3, pointer.dy)
      ..setFloat(4, phase * math.pi * 2)
      ..setFloat(5, color.r)
      ..setFloat(6, color.g)
      ..setFloat(7, color.b);
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_ThreadsPainter old) =>
      shader != old.shader ||
      color != old.color ||
      pointer != old.pointer ||
      phase != old.phase;
}

class WantLogoWave extends StatelessWidget {
  final Widget child;
  final Object pulse;
  final bool paused;
  const WantLogoWave({
    super.key,
    required this.child,
    required this.pulse,
    this.paused = false,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.highContrastOf(context) ||
        WantTheme.reducedMotionOf(context) ||
        paused) {
      return child;
    }
    return WantViewportMotion(
      child: TweenAnimationBuilder<double>(
        key: ValueKey(pulse),
        tween: Tween(begin: -1, end: 2),
        duration: const Duration(milliseconds: 1000),
        child: child,
        builder: (context, t, child) => ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) =>
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color(0x00ffffff),
                  Color(0xaaffffff),
                  Color(0x00ffffff),
                ],
              ).createShader(
                Rect.fromLTWH(
                  bounds.left + bounds.width * t,
                  bounds.top,
                  bounds.width,
                  bounds.height,
                ),
              ),
          child: child,
        ),
      ),
    );
  }
}
