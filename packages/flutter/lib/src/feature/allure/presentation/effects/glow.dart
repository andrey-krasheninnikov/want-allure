import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
    return WantViewportMotion(
      child: WantMotionBuilder(
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
      ),
    );
  }
}
