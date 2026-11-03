import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart' show Theme;

/// Semantic Want colors and the corresponding ForUI theme.
@immutable
class WantThemeData {
  final Map<String, Color> colors;
  final FThemeData forui;

  const WantThemeData({required this.colors, required this.forui});

  factory WantThemeData.light({Map<String, Color> overrides = const {}}) =>
      WantThemeData._create(Brightness.light, {
        ...WantTokens.light,
        ...overrides,
      });

  factory WantThemeData.dark({Map<String, Color> overrides = const {}}) =>
      WantThemeData._create(Brightness.dark, {
        ...WantTokens.dark,
        ...overrides,
      });

  factory WantThemeData._create(
    Brightness brightness,
    Map<String, Color> values,
  ) {
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
      border: values['border'],
    );
    const fallbacks = [
      'packages/want_allure/Noto Sans JP',
      'packages/want_allure/Noto Sans Arabic',
    ];
    final typography = FTypography(
      display: FTypeface.inherit(
        colors: colors,
        touch: true,
        fontFamily: 'packages/want_allure/Days One',
        fontFamilyFallback: fallbacks,
      ),
      body: FTypeface.inherit(
        colors: colors,
        touch: true,
        fontFamily: 'packages/want_allure/Manrope',
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
            sm: BorderRadius.circular(12),
            md: BorderRadius.circular(12),
            lg: BorderRadius.circular(24),
            xl: BorderRadius.circular(32),
          ),
          tappableStyle: FTappableStyle(
            cursor: FVariants(
              SystemMouseCursors.click,
              variants: {
                [FTappableVariant.disabled]: SystemMouseCursors.basic,
              },
            ),
            pressedEnterDuration: WantTokens.motion['feedbackMs']!,
            pressedExitDuration: WantTokens.motion['feedbackMs']!,
            motion: FTappableMotion(
              bounceDownDuration: WantTokens.motion['feedbackMs']!,
              bounceUpDuration: WantTokens.motion['feedbackMs']!,
              bounceDownCurve: const Cubic(.32, .72, 0, 1),
              bounceUpCurve: const Cubic(.32, .72, 0, 1),
            ),
          ),
          focusedOutlineStyle: FFocusedOutlineStyle(
            color: colors.primary,
            width: 2,
            spacing: 3,
            borderRadius: BorderRadius.circular(12),
          ),
        );
    final theme = FThemeData(
      colors: colors,
      typography: typography,
      style: style,
      touch: true,
    );
    return WantThemeData(
      colors: Map.unmodifiable(values),
      forui: theme.copyWith(
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
          motion: FPopoverMotion(
            entranceDuration: WantTokens.motion['transitionMs']!,
            exitDuration: WantTokens.motion['transitionMs']!,
          ),
        ),
        cardStyle: theme.cardStyle.copyWith(
          decoration: DecorationDelta.value(
            BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
    );
  }

  Color color(String role) =>
      colors[role] ??
      (throw ArgumentError.value(role, 'role', 'Unknown Want color'));
}

/// Applies Want and ForUI styles without owning navigation or saved preferences.
class WantTheme extends StatefulWidget {
  final WantThemeData data;
  final bool reduceTransparency;
  final bool? reduceMotion;
  final Widget child;

  const WantTheme({
    super.key,
    required this.data,
    required this.child,
    this.reduceTransparency = false,
    this.reduceMotion,
  });

  static WantThemeData of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<_WantInheritedTheme>();
    if (inherited == null) {
      throw FlutterError('Want components require a WantTheme ancestor.');
    }
    return inherited.data;
  }

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
    final data = widget.data,
        reduceMotion = widget.reduceMotion,
        reduceTransparency = widget.reduceTransparency,
        child = widget.child;
    final features =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
    final reduced =
        reduceMotion ??
        (MediaQuery.maybeOf(context)?.disableAnimations == true ||
            features.disableAnimations ||
            features.reduceMotion);
    return _WantInheritedTheme(
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
          data: data.forui.toApproximateMaterialTheme(),
          child: DefaultTextStyle(
            style: data.forui.typography.body.sm.copyWith(
              fontSize: 16,
              height: 1.7,
            ),
            child: child,
          ),
        ),
      ),
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
