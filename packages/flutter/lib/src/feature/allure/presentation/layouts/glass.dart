import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantGlass extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  const WantGlass({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });
  @override
  Widget build(BuildContext context) {
    final opaque =
        WantTheme.reducedTransparencyOf(context) ||
        MediaQuery.highContrastOf(context);
    final surface = WantTheme.of(context).color('secondary');
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        enabled: !opaque,
        filter: ui.ImageFilter.compose(
          outer: ui.ColorFilter.matrix(
            _saturationMatrix(WantTokens.glassSaturation),
          ),
          inner: ui.ImageFilter.blur(
            sigmaX: WantTokens.glassBlur,
            sigmaY: WantTokens.glassBlur,
          ),
        ),
        child: ColoredBox(
          color: opaque
              ? surface
              : surface.withValues(alpha: WantTokens.glassOpacity),
          child: child,
        ),
      ),
    );
  }
}

List<double> _saturationMatrix(double saturation) {
  final r = .2126 * (1 - saturation),
      g = .7152 * (1 - saturation),
      b = .0722 * (1 - saturation);
  return [
    r + saturation,
    g,
    b,
    0,
    0,
    r,
    g + saturation,
    b,
    0,
    0,
    r,
    g,
    b + saturation,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];
}
