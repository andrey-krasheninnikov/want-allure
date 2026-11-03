import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantBadge extends StatelessWidget {
  final Widget child;
  final WantButtonVariant variant;
  const WantBadge({
    super.key,
    required this.child,
    this.variant = WantButtonVariant.primary,
  });
  @override
  Widget build(BuildContext context) {
    final role = switch (variant) {
      WantButtonVariant.primary => 'primary',
      WantButtonVariant.destructive => 'error',
      _ => 'secondary',
    };
    final theme = WantTheme.of(context);
    return FBadge(
      style: theme.forui.badgeStyles
          .resolve({FBadgeVariant.primary})
          .copyWith(
            decoration: DecorationDelta.value(
              BoxDecoration(
                color: theme.color(role),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            labelTextStyle: TextStyleDelta.value(
              TextStyle(
                fontFamily: 'packages/want_allure/Manrope',
                fontSize: 14,
                color: theme.color('$role-foreground'),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      child: child,
    );
  }
}

class WantAlert extends StatelessWidget {
  final Widget title;
  final Widget? description, icon;
  final bool destructive;
  const WantAlert({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.destructive = false,
  });
  @override
  Widget build(BuildContext context) => FAlert(
    title: title,
    subtitle: description,
    icon: icon,
    variant: destructive ? FAlertVariant.destructive : FAlertVariant.primary,
    style: FAlertStyleDelta.delta(
      decoration: DecorationDelta.value(
        BoxDecoration(
          color: WantTheme.of(context).color('secondary'),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
