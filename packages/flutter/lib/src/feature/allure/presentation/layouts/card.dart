import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:sprung/sprung.dart';
import 'package:forui/forui.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantCard extends StatelessWidget {
  final bool hoverEffect;
  final Widget child;
  final Widget? title, description, actions, footer;
  final EdgeInsetsGeometry padding;
  const WantCard({
    super.key,
    required this.child,
    this.title,
    this.description,
    this.actions,
    this.footer,
    this.padding = const EdgeInsets.all(24),
    this.hoverEffect = true,
  });
  @override
  Widget build(BuildContext context) => _CardSurface(
    enabled: hoverEffect,
    child: FCard(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            if (title != null || description != null || actions != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  if (title != null || description != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          if (title != null)
                            DefaultTextStyle(
                              style: WantTheme.of(context)
                                  .forui
                                  .typography
                                  .display
                                  .lg,
                              child: title!,
                            ),
                          if (description != null)
                            DefaultTextStyle.merge(
                              style: TextStyle(
                                fontSize: 14,
                                color: WantTheme.of(context)
                                    .color('muted-foreground'),
                              ),
                              child: description!,
                            ),
                        ],
                      ),
                    ),
                  if (actions != null)
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: actions!,
                    ),
                ],
              ),
            child,
            if (footer != null)
              Align(alignment: AlignmentDirectional.centerEnd, child: footer!),
          ],
        ),
      ),
    ),
  );
}

class _CardSurface extends StatefulWidget {
  final bool enabled;
  final Widget child;
  const _CardSurface({required this.enabled, required this.child});
  @override
  State<_CardSurface> createState() => _CardSurfaceState();
}

class _CardSurfaceState extends State<_CardSurface> {
  bool _hovered = false, _focused = false;
  @override
  Widget build(BuildContext context) {
    final child = RepaintBoundary(child: widget.child);
    if (!widget.enabled || MediaQuery.highContrastOf(context)) return child;
    final reduced = WantTheme.reducedMotionOf(context);
    return WantViewportMotion(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Focus(
          canRequestFocus: false,
          onFocusChange: (value) => setState(() => _focused = value),
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: _hovered || _focused ? 1.0 : 0.0),
            duration: reduced
                ? Duration.zero
                : const Duration(milliseconds: 280),
            curve: Sprung.criticallyDamped,
            builder: (context, strength, _) => WantMotionBuilder(
              duration: const Duration(milliseconds: 2600),
              paused: !_hovered,
              builder: (context, phase) => CustomPaint(
                foregroundPainter: _CardHighlight(
                  strength,
                  reduced ? 0 : phase,
                  WantTheme.of(context).color('primary'),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardHighlight extends CustomPainter {
  final double strength, phase;
  final Color color;
  _CardHighlight(this.strength, this.phase, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    if (strength <= 0 || size.isEmpty) return;
    final rect = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(1),
      const Radius.circular(24),
    );
    canvas.drawRRect(
      rect,
      Paint()
        ..color = color.withValues(alpha: .16 * strength)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    final path = Path()..addRRect(rect);
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: .3 * strength)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    final metric = path.computeMetrics().first;
    final start = phase * metric.length, extent = metric.length * .27;
    final paint = Paint()
      ..color = color.withValues(alpha: .9 * strength)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      metric.extractPath(start, math.min(metric.length, start + extent)),
      paint,
    );
    if (start + extent > metric.length) {
      canvas.drawPath(
        metric.extractPath(0, start + extent - metric.length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_CardHighlight old) =>
      old.strength != strength || old.phase != phase || old.color != color;
}
