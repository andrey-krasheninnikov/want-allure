import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';
import 'package:flutter/widgets.dart';

enum WantTypographyVariant {
  display,
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  lead,
  body,
  small,
  caption,
  label,
  overline,
  mono,
  code,
  codeBlock,
  quote,
}

class WantTypography extends StatelessWidget {
  final String text;
  final WantTypographyVariant variant;
  final TextAlign align;
  final String? colorRole;
  final bool liveRegion;
  final int? headingLevel;
  const WantTypography(
    this.text, {
    super.key,
    this.variant = WantTypographyVariant.body,
    this.align = TextAlign.start,
    this.colorRole,
    this.liveRegion = false,
    this.headingLevel,
  });

  @override
  Widget build(BuildContext context) {
    final key = variant == WantTypographyVariant.codeBlock
        ? 'code-block'
        : variant.name;
    final token = WantTokens.typography[key]!;
    final progress = ((MediaQuery.sizeOf(context).width - 320) / 1120).clamp(
      0.0,
      1.0,
    );
    final size = token.min + (token.max - token.min) * progress;
    final technical = token.font == 'mono';
    final style = TextStyle(
      fontFamily: technical
          ? 'monospace'
          : 'packages/want_allure/${token.font == 'display' ? 'Days One' : 'Manrope'}',
      fontFamilyFallback: WantTheme.of(context)
          .forui
          .typography
          .body
          .lg
          .fontFamilyFallback,
      fontSize: size,
      fontVariations: [FontVariation('wght', token.weight)],
      fontWeight:
          FontWeight.values[((token.weight / 100).round() - 1).clamp(0, 8)],
      height: token.lineHeight,
      letterSpacing: token.tracking * size,
      color: WantTheme.of(context).color(colorRole ?? 'foreground'),
    );
    final level =
        headingLevel ??
        switch (variant) {
          WantTypographyVariant.display || WantTypographyVariant.h1 => 1,
          WantTypographyVariant.h2 => 2,
          WantTypographyVariant.h3 => 3,
          WantTypographyVariant.h4 => 4,
          WantTypographyVariant.h5 => 5,
          WantTypographyVariant.h6 => 6,
          _ => 0,
        };
    assert(level >= 0 && level <= 6);
    return Semantics(
      headingLevel: level == 0 ? null : level,
      liveRegion: liveRegion,
      child: Text(
        text,
        style: style,
        textAlign: align,
        textDirection: technical ? TextDirection.ltr : null,
      ),
    );
  }
}

class WantProse extends StatelessWidget {
  final Widget child;
  const WantProse({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.topStart,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
      child: DefaultTextStyle.merge(
        style: const TextStyle(fontSize: 16, height: 1.7),
        child: child,
      ),
    ),
  );
}
