import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
    label: text,
    excludeSemantics: true,
    liveRegion: liveRegion,
    child: WantTheme.reducedMotionOf(context)
        ? Text(text, style: style)
        : TweenAnimationBuilder<double>(
            key: ValueKey(text),
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 360),
            curve: const Cubic(.16, 1, .3, 1),
            child: Text(text, style: style),
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(
                  0,
                  effect == WantTextEffect.slide ? (1 - value) * 4 : 0,
                ),
                child: ImageFiltered(
                  enabled: effect == WantTextEffect.blur && value < 1,
                  imageFilter: ui.ImageFilter.blur(
                    sigmaX: (1 - value) * 2,
                    sigmaY: (1 - value) * 2,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
  );
}
