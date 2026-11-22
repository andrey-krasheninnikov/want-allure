import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart'
    show Theme, ThemeData, OutlineInputBorder;

/// Semantic Want colors and the corresponding ForUI theme.
@immutable
class WantThemeData {
  final Map<String, Color> colors;
  final FThemeData forui;
  final WantTypographyPreset typographyPreset;

  final WantBrandProfileV1 profile;
  final WantBrandResources resources;

  Color get brandColor =>
      profile.brandColor ?? originalPrimary ?? WantTokens.light['primary']!;
  final Color? originalPrimary;
  double get fieldRadius => profile.radii['field'] ?? 12;
  double get panelRadius => profile.radii['panel'] ?? 24;
  double get mediaRadius => profile.radii['media'] ?? 24;
  double get actionRadius => profile.radii['action'] ?? 999;
  bool get compact => profile.density == WantDensity.compact;
  String? font(String role) => resources.fonts[profile.fonts[role]];

  factory WantThemeData.fromProfile(
    WantBrandProfileV1 profile, {
    required Brightness brightness,
    Locale? locale,
    WantBrandResources resources = const WantBrandResources(),
  }) => WantThemeData._create(
    brightness,
    const {},
    locale,
    profile.brandColor,
    profile.paletteStyle,
    profile.typographyPreset,
    profile,
    resources,
  );

  const WantThemeData({
    this.originalPrimary,
    this.profile = WantBrandProfileV1.defaults,
    this.resources = const WantBrandResources(),
    required this.colors,
    required this.forui,
    this.typographyPreset = WantTypographyPreset.brand,
  });

  factory WantThemeData.light({
    Map<String, Color> overrides = const {},
    Locale? locale,
    Color? primaryColor,
    WantPaletteStyle paletteStyle = WantPaletteStyle.contrast,
    WantTypographyPreset typographyPreset = WantTypographyPreset.brand,
  }) => WantThemeData._create(
    Brightness.light,
    overrides,
    locale,
    primaryColor,
    paletteStyle,
    typographyPreset,
  );

  factory WantThemeData.dark({
    Map<String, Color> overrides = const {},
    Locale? locale,
    Color? primaryColor,
    WantPaletteStyle paletteStyle = WantPaletteStyle.contrast,
    WantTypographyPreset typographyPreset = WantTypographyPreset.brand,
  }) => WantThemeData._create(
    Brightness.dark,
    overrides,
    locale,
    primaryColor,
    paletteStyle,
    typographyPreset,
  );

  factory WantThemeData._create(
    Brightness brightness,
    Map<String, Color> overrides,
    Locale? locale,
    Color? primaryColor,
    WantPaletteStyle paletteStyle,
    WantTypographyPreset typographyPreset, [
    WantBrandProfileV1? brand,
    WantBrandResources resources = const WantBrandResources(),
  ]) {
    final values = {
      ...brand?.palette(brightness) ??
          resolveWantPalette(brightness, primaryColor, paletteStyle),
      'ring': ?overrides['primary'],
      'primary-edge': ?overrides['primary'],
      ...overrides,
    };
    final fieldRadius = brand?.radii['field'] ?? 12.0;
    final panelRadius = brand?.radii['panel'] ?? 24.0;
    String? font(String? role) => resources.fonts[brand?.fonts[role]];
    final ring = values['ring']!;
    final base = brightness == Brightness.dark
        ? FColors.neutralDark
        : FColors.neutralLight;
    final colors = base.copyWith(
      background: values['background'],
      foreground: values['foreground'],
      primary: values['primary'],
      primaryForeground: values['primary-foreground'],
      secondary: values['secondary'],
      secondaryForeground: values['secondary-foreground'],
      muted: values['muted'],
      mutedForeground: values['muted-foreground'],
      destructive: values['destructive'],
      destructiveForeground: values['destructive-foreground'],
      error: values['error-text'],
      errorForeground: values['error-foreground'],
      card: values['card'],
      border: values['input'],
    );
    final language = locale?.languageCode;
    final preset = WantTokens.typographyPresets[typographyPreset.name]!;
    final scriptFamily = switch (language) {
      'zh' => 'Noto Sans SC',
      'hi' => 'Noto Sans Devanagari',
      'he' => 'Noto Sans Hebrew',
      'ar' => 'Noto Sans Arabic',
      'ja' => 'Noto Sans JP',
      _ => null,
    };
    final localized = typographyPreset != WantTypographyPreset.brand;
    final display =
        preset.localDisplay[language] ??
        (localized ? scriptFamily : null) ??
        preset.display;
    final body =
        (localized ? scriptFamily : null) ??
        (language == 'ru' && typographyPreset == WantTypographyPreset.humanist
            ? 'Manrope'
            : preset.body);
    final fallbacks = [
      ?font(language),
      'packages/want_allure/${scriptFamily ?? 'Noto Sans JP'}',
      'packages/want_allure/Noto Sans SC',
      'packages/want_allure/Noto Sans Devanagari',
      'packages/want_allure/Noto Sans Hebrew',
      'packages/want_allure/Noto Sans JP',
      'packages/want_allure/Noto Sans Arabic',
    ];
    final typography = FTypography(
      display: FTypeface.inherit(
        colors: colors,
        touch: true,
        fontFamily:
            font(language) ??
            font('display') ??
            'packages/want_allure/$display',
        fontFamilyFallback: fallbacks,
      ),
      body: FTypeface.inherit(
        colors: colors,
        touch: true,
        fontFamily:
            font(language) ?? font('body') ?? 'packages/want_allure/$body',
        fontFamilyFallback: fallbacks,
      ),
    );
    final style =
        FStyle.inherit(
          colors: colors,
          typography: typography,
          touch: true,
        ).copyWith(
          borderRadius: FBorderRadius(
            sm: BorderRadius.circular(fieldRadius),
            md: BorderRadius.circular(fieldRadius),
            lg: BorderRadius.circular(panelRadius),
            xl: BorderRadius.circular(32),
          ),
          tappableStyle: FTappableStyle(
            cursor: FVariants(
              SystemMouseCursors.click,
              variants: {
                [FTappableVariant.disabled]: SystemMouseCursors.basic,
              },
            ),
            pressedEnterDuration: brand?.motion == WantMotion.off
                ? Duration.zero
                : WantTokens.motion['feedbackMs']!,
            pressedExitDuration: brand?.motion == WantMotion.off
                ? Duration.zero
                : WantTokens.motion['feedbackMs']!,
            motion: FTappableMotion(
              bounceDownDuration: WantTokens.motion['feedbackMs']!,
              bounceUpDuration: WantTokens.motion['feedbackMs']!,
              bounceDownCurve: const Cubic(.32, .72, 0, 1),
              bounceUpCurve: const Cubic(.32, .72, 0, 1),
            ),
          ),
          focusedOutlineStyle: FFocusedOutlineStyle(
            color: ring,
            width: 2,
            spacing: 3,
            borderRadius: BorderRadius.circular(fieldRadius),
          ),
        );
    final edge = values['primary-edge']!;
    final smallControls = edge == colors.primary
        ? null
        : FThemeData(
            colors: colors.copyWith(
              primary: edge,
              primaryForeground: edge.computeLuminance() > .179
                  ? const Color(0xFF000000)
                  : const Color(0xFFFFFFFF),
            ),
            typography: typography,
            style: style,
            touch: true,
          );
    final theme = FThemeData(
      colors: colors,
      checkboxStyle: smallControls?.checkboxStyle,
      radioStyle: smallControls?.radioStyle,
      switchStyle: smallControls?.switchStyle,
      sliderStyles: smallControls?.sliderStyles,
      progressStyle: smallControls?.progressStyle,
      determinateProgressStyle: smallControls?.determinateProgressStyle,
      typography: typography,
      style: style,
      touch: true,
    );
    BoxDecoration surface(String role, {bool overlay = false}) => BoxDecoration(
      color: values[role],
      borderRadius: BorderRadius.circular(panelRadius),
      border: Border.all(color: values['surface-highlight']!),
      boxShadow: brand?.surface == WantSurface.flat
          ? []
          : [
              BoxShadow(
                color: values['surface-shadow']!,
                blurRadius: WantTokens
                    .material[overlay ? 'overlayBlurPx' : 'shadowBlurPx']!,
                offset: Offset(
                  0,
                  WantTokens.material[overlay
                      ? 'overlayOffsetYPx'
                      : 'shadowOffsetYPx']!,
                ),
              ),
            ],
    );
    FTextFieldStyle field(FTextFieldStyle original) => original.copyWith(
      color: FVariants(
        colors.secondary,
        variants: {
          [FTextFieldVariant.hovered]: colors.card,
          [FTextFieldVariant.focused]: colors.card,
          [FTextFieldVariant.disabled]: colors.disable(colors.secondary),
        },
      ),
      contentPadding: EdgeInsetsGeometryDelta.value(
        EdgeInsets.symmetric(
          horizontal: 16,
          vertical: brand?.density == WantDensity.compact ? 8 : 12,
        ),
      ),
      border: FVariants(
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
          borderSide: BorderSide(color: values['input']!),
        ),
        variants: {
          [FTextFieldVariant.focused]: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fieldRadius),
            borderSide: BorderSide(color: ring, width: 2),
          ),
          [FTextFieldVariant.error]: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fieldRadius),
            borderSide: BorderSide(color: values['error-text']!),
          ),
          [FTextFieldVariant.disabled]: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fieldRadius),
            borderSide: BorderSide(color: colors.border),
          ),
        },
      ),
    );
    return WantThemeData(
      profile: brand ?? WantBrandProfileV1.defaults,
      originalPrimary: primaryColor,
      resources: resources,
      colors: Map.unmodifiable(values),
      typographyPreset: typographyPreset,
      forui: theme.copyWith(
        textFieldStyles: FTextFieldSizeStyles(
          FVariants(
            field(theme.textFieldStyles.md),
            variants: {
              [FTextFieldSizeVariant.sm]: field(theme.textFieldStyles.sm),
              [FTextFieldSizeVariant.lg]: field(theme.textFieldStyles.lg),
            },
          ),
        ),
        dialogStyle: theme.dialogStyle.copyWith(
          decoration: DecorationDelta.value(surface('popover', overlay: true)),
        ),
        tabsStyle: theme.tabsStyle.copyWith(
          minHeight: 44,
          decoration: DecorationDelta.value(
            BoxDecoration(
              color: colors.secondary,
              borderRadius: BorderRadius.circular(fieldRadius),
            ),
          ),
          indicatorDecoration: DecorationDelta.value(
            BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: values['surface-highlight']!),
            ),
          ),
        ),
        accordionStyle: theme.accordionStyle.copyWith(
          motion: FAccordionMotion(
            expandDuration: const Duration(milliseconds: 280),
            collapseDuration: const Duration(milliseconds: 220),
            expandCurve: const Cubic(.32, .72, 0, 1),
          ),
        ),
        dialogRouteStyle: theme.dialogRouteStyle.copyWith(
          motion: FDialogRouteMotion(
            entranceDuration: WantTokens.motion['transitionMs']!,
            exitDuration: WantTokens.motion['transitionMs']!,
          ),
        ),
        modalSheetStyle: theme.modalSheetStyle.copyWith(
          motion: FModalSheetMotion(
            expandDuration: WantTokens.motion['transitionMs']!,
            collapseDuration: WantTokens.motion['transitionMs']!,
          ),
        ),
        popoverStyle: theme.popoverStyle.copyWith(
          decoration: DecorationDelta.value(surface('popover', overlay: true)),
          motion: FPopoverMotion(
            entranceDuration: WantTokens.motion['transitionMs']!,
            exitDuration: WantTokens.motion['transitionMs']!,
          ),
        ),
        cardStyle: theme.cardStyle.copyWith(
          decoration: DecorationDelta.value(surface('card')),
        ),
      ),
    );
  }

  Color color(String role) {
    if (colors[role] case final value?) return value;
    final defaults = forui.colors.brightness == Brightness.dark
        ? WantTokens.dark
        : WantTokens.light;
    return switch (role) {
      'surface-highlight' => colors['glass-highlight'] ?? defaults[role]!,
      'surface-shadow' => defaults[role]!,
      'primary-text' => colors['link'] ?? forui.colors.primary,
      'primary-edge' => colors['ring'] ?? forui.colors.primary,
      'primary-soft' => forui.colors.secondary,
      _ => throw ArgumentError.value(role, 'role', 'Unknown Want color'),
    };
  }
}

/// Applies Want and ForUI styles without owning navigation or saved preferences.
class WantTheme extends StatefulWidget {
  final WantThemeData data;
  final bool reduceTransparency, animateTransitions;
  final bool? reduceMotion;
  final Widget child;

  const WantTheme({
    super.key,
    required this.data,
    required this.child,
    this.reduceTransparency = false,
    this.reduceMotion,
    this.animateTransitions = false,
  });

  static WantThemeData of(BuildContext context) {
    return maybeOf(context) ??
        (throw FlutterError('Want components require a WantTheme ancestor.'));
  }

  static WantThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_WantInheritedTheme>()?.data;

  static bool reducedMotionOf(BuildContext context) {
    final settings = context
        .dependOnInheritedWidgetOfExactType<_WantInheritedTheme>();
    return settings?.reduceMotion ??
        (MediaQuery.disableAnimationsOf(context) ||
            MediaQuery.accessibleNavigationOf(context));
  }

  static bool reducedTransparencyOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_WantInheritedTheme>()
          ?.reduceTransparency ??
      false;

  @override
  State<WantTheme> createState() => _WantThemeState();
}

class _WantThemeState extends State<WantTheme> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAccessibilityFeatures() {
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = widget.reduceMotion,
        reduceTransparency = widget.reduceTransparency,
        child = widget.child;
    final features =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
    final reduced =
        reduceMotion == true ||
        WantTheme.maybeOf(context)?.profile.motion == WantMotion.off ||
        widget.data.profile.motion == WantMotion.off ||
        MediaQuery.maybeOf(context)?.accessibleNavigation == true ||
        (MediaQuery.maybeOf(context)?.disableAnimations == true ||
            features.disableAnimations ||
            features.reduceMotion);
    Widget themed(WantThemeData data, ThemeData material, Widget content) =>
        _WantInheritedTheme(
          data: data,
          reduceMotion: reduced,
          reduceTransparency: reduceTransparency,
          child: FTheme(
            data: data.forui,
            accessibility: FAccessibility(
              accessibleNavigation: features.accessibleNavigation,
              motion: reduced
                  ? FAccessibilityMotion.disabled
                  : FAccessibilityMotion.all,
              focusHighlight: true,
            ),
            child: Theme(
              data: material,
              child: DefaultTextStyle(
                style: data.forui.typography.body.sm.copyWith(
                  fontSize: 16,
                  height: 1.7,
                ),
                child: content,
              ),
            ),
          ),
        );
    final material = widget.data.forui.toApproximateMaterialTheme();
    if (!widget.animateTransitions) return themed(widget.data, material, child);
    return TweenAnimationBuilder<_ThemeFrame>(
      tween: _WantThemeTween((data: widget.data, material: material)),
      duration: reduced ? Duration.zero : const Duration(milliseconds: 360),
      curve: Curves.easeInOutCubic,
      child: child,
      builder: (context, frame, child) =>
          themed(frame.data, frame.material, child!),
    );
  }
}

typedef _ThemeFrame = ({WantThemeData data, ThemeData material});

class _WantThemeTween extends Tween<_ThemeFrame> {
  _WantThemeTween(_ThemeFrame target) : super(end: target);

  @override
  _ThemeFrame lerp(double t) {
    if (t <= 0) return begin!;
    if (t >= 1) return end!;
    final start = begin!.data, target = end!.data;
    return (
      data: WantThemeData(
        colors: {
          for (final entry in target.colors.entries)
            entry.key: Color.lerp(
              start.colors[entry.key] ?? entry.value,
              entry.value,
              t,
            )!,
        },
        forui: FThemeData.lerp(start.forui, target.forui, t),
        typographyPreset: target.typographyPreset,
        profile: target.profile,
        originalPrimary: target.originalPrimary,
        resources: target.resources,
      ),
      material: ThemeData.lerp(begin!.material, end!.material, t),
    );
  }
}

class _WantInheritedTheme extends InheritedTheme {
  final WantThemeData data;
  final bool reduceMotion, reduceTransparency;
  const _WantInheritedTheme({
    required this.data,
    required this.reduceMotion,
    required this.reduceTransparency,
    required super.child,
  });
  @override
  bool updateShouldNotify(_WantInheritedTheme old) =>
      data != old.data ||
      reduceMotion != old.reduceMotion ||
      reduceTransparency != old.reduceTransparency;
  @override
  Widget wrap(BuildContext context, Widget child) => _WantInheritedTheme(
    data: data,
    reduceMotion: reduceMotion,
    reduceTransparency: reduceTransparency,
    child: child,
  );
}

/// Captures caller-owned locale and direction before a route leaves its subtree.
Widget Function(Widget) captureWantOverlayEnvironment(
  BuildContext from,
  BuildContext to,
) {
  final dir = Directionality.maybeOf(from);
  final local = from.findAncestorWidgetOfExactType<Localizations>();
  final target = to.findAncestorWidgetOfExactType<Localizations>();
  final locale = Localizations.maybeLocaleOf(from);
  return (child) {
    final content = dir == null
        ? child
        : Directionality(textDirection: dir, child: child);
    return local != null && locale != null && !identical(local, target)
        ? Localizations(
            locale: locale,
            delegates: local.delegates,
            child: content,
          )
        : content;
  };
}

class WantDirectionProvider extends StatelessWidget {
  final TextDirection direction;
  final Widget child;
  const WantDirectionProvider({
    super.key,
    required this.direction,
    required this.child,
  });
  @override
  Widget build(BuildContext context) =>
      Directionality(textDirection: direction, child: child);
}
