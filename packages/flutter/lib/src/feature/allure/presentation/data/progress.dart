import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantProgress extends StatelessWidget {
  final double? value;
  final double max;
  final String label;
  const WantProgress({
    super.key,
    required this.label,
    this.value,
    this.max = 100,
  });
  @override
  Widget build(BuildContext context) {
    final amount = value;
    if (amount == null) {
      return WantViewportMotion(
        child: RepaintBoundary(
          child: SizedBox(
            width: double.infinity,
            child: FProgress(semanticsLabel: label),
          ),
        ),
      );
    }
    final normalized = amount.isFinite && max.isFinite && max > 0
        ? (amount / max).clamp(0.0, 1.0)
        : 0.0;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: normalized, end: normalized),
      duration: WantTheme.reducedMotionOf(context)
          ? Duration.zero
          : WantTokens.motion['transitionMs']!,
      curve: const Cubic(.32, .72, 0, 1),
      builder: (context, value, child) =>
          FDeterminateProgress(value: value, semanticsLabel: label),
    );
  }
}
