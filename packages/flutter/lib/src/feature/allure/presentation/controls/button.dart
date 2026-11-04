import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:forui/forui.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

enum WantButtonVariant { primary, secondary, outline, ghost, link, destructive }

enum WantButtonSize {
  extraSmall,
  small,
  medium,
  large,
  iconExtraSmall,
  iconSmall,
  icon,
  iconLarge,
}

class WantButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final WantButtonVariant variant;
  final WantButtonSize size;
  final String? semanticsLabel;
  final FocusNode? focusNode;
  final bool autofocus, pill;
  const WantButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.variant = WantButtonVariant.primary,
    this.size = WantButtonSize.medium,
    this.semanticsLabel,
    this.focusNode,
    this.autofocus = false,
    this.pill = true,
  });
  @override
  Widget build(BuildContext context) {
    final theme = WantTheme.of(context);
    final mapped = switch (variant) {
      WantButtonVariant.primary => FButtonVariant.primary,
      WantButtonVariant.destructive => FButtonVariant.destructive,
      _ => FButtonVariant.secondary,
    };
    final role = switch (variant) {
      WantButtonVariant.primary => 'primary',
      WantButtonVariant.destructive => 'destructive',
      _ => 'secondary',
    };
    final base =
        variant == WantButtonVariant.ghost || variant == WantButtonVariant.link
        ? const Color(0x00000000)
        : theme.color(role);
    final foreground = theme.color(
      variant == WantButtonVariant.link ? 'primary-text' : '$role-foreground',
    );
    final iconOnly = size.name.startsWith('icon');
    final style = theme.forui.buttonStyles.resolve({mapped}).resolve({
      FButtonSizeVariant.md,
    });
    final decoration = BoxDecoration(
      color: base,
      borderRadius: BorderRadius.circular(pill ? 100 : 12),
      border:
          variant == WantButtonVariant.ghost ||
              variant == WantButtonVariant.link
          ? null
          : Border.all(color: theme.color('surface-highlight')),
      boxShadow: onPressed == null || variant != WantButtonVariant.primary
          ? null
          : [
              BoxShadow(
                color: theme.color('surface-shadow'),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
    );
    final buttonStyle = style.copyWith(
      decoration: FVariants.from(
        decoration,
        variants: {
          [FTappableVariant.hovered]: DecorationDelta.boxDelta(
            color: variant == WantButtonVariant.primary
                ? theme.color('primary-hover')
                : variant == WantButtonVariant.destructive
                ? base
                : theme.color('accent'),
          ),
          [FTappableVariant.pressed]: DecorationDelta.boxDelta(
            color: variant == WantButtonVariant.primary
                ? theme.color('primary-active')
                : variant == WantButtonVariant.destructive
                ? base
                : theme.color('accent'),
          ),
          [FTappableVariant.disabled]: DecorationDelta.boxDelta(
            color: base.withValues(alpha: .5),
          ),
        },
      ),
    );
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 44,
        minHeight:
            size == WantButtonSize.large || size == WantButtonSize.iconLarge
            ? 48
            : 44,
      ),
      child: FTappable(
        selectable: kIsWeb || WantWebScope.enabledOf(context),
        // Feedback animates immediately; no delayed pressed state survives dismissal.
        style: buttonStyle.tappableStyle.copyWith(
          pressedEnterDuration: Duration.zero,
          pressedExitDuration: Duration.zero,
        ),
        focusedOutlineStyle: buttonStyle.focusedOutlineStyle,
        onPress: onPressed,
        focusNode: focusNode,
        autofocus: autofocus,
        semanticsLabel: semanticsLabel,
        excludeSemantics: semanticsLabel != null,
        builder: (context, variants, content) => AnimatedContainer(
          duration: WantTheme.reducedMotionOf(context)
              ? Duration.zero
              : WantTokens.motion['feedbackMs']!,
          curve: const Cubic(.32, .72, 0, 1),
          decoration: buttonStyle.decoration.resolve(variants),
          child: content,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: iconOnly
                ? 10
                : switch (size) {
                    WantButtonSize.extraSmall => 8,
                    WantButtonSize.small => 12,
                    WantButtonSize.large => 24,
                    _ => 16,
                  },
            vertical: 10,
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: onPressed == null
                  ? foreground.withValues(alpha: .5)
                  : foreground,
            ),
            child: IconTheme(
              data: IconThemeData(
                size: size == WantButtonSize.iconExtraSmall ? 12 : 20,
                color: onPressed == null
                    ? foreground.withValues(alpha: .5)
                    : foreground,
              ),
              child: WantSelectable(
                enabled: onPressed != null,
                child: DefaultSelectionStyle.merge(
                  mouseCursor: MouseCursor.defer,
                  child: Center(widthFactor: 1, heightFactor: 1, child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
