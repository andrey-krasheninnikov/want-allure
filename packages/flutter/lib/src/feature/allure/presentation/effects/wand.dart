import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
