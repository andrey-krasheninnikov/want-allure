import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantBadge extends StatelessWidget {
  final Widget child;
  final WantButtonVariant variant;
  final WantSnackbarVariant? status;
  const WantBadge({
    super.key,
    required this.child,
    this.status,
    this.variant = WantButtonVariant.primary,
  });
  @override
  Widget build(BuildContext context) {
    final role =
        status?.name ??
        switch (variant) {
          WantButtonVariant.primary => 'primary',
          WantButtonVariant.destructive => 'error',
          _ => 'secondary',
        };
    final theme = WantTheme.of(context);
    final tonal = status != null || variant == WantButtonVariant.destructive;
    final ink = theme.color(tonal ? '$role-text' : '$role-foreground');
    return FBadge(
      style: theme.forui.badgeStyles
          .resolve({FBadgeVariant.primary})
          .copyWith(
            decoration: DecorationDelta.value(
              BoxDecoration(
                color: theme.color(tonal ? 'secondary' : role),
                border: tonal
                    ? Border.all(color: ink.withValues(alpha: .32))
                    : role == 'primary' &&
                          theme.color('primary-edge') != theme.color('primary')
                    ? Border.all(color: theme.color('primary-edge'))
                    : null,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            labelTextStyle: TextStyleDelta.value(
              TextStyle(
                fontFamily: theme.forui.typography.body.sm.fontFamily,
                fontSize: 14,
                color: ink,
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
  final WantSnackbarVariant? status;
  const WantAlert({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.destructive = false,
    this.status,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: status != null || destructive,
    child: FAlert(
      title: title,
      subtitle: description,
      icon:
          icon ??
          (status == null
              ? null
              : WantIcon(
                  switch (status!) {
                    WantSnackbarVariant.error => WantIcons.error,
                    WantSnackbarVariant.warning => WantIcons.warning,
                    WantSnackbarVariant.info => WantIcons.info,
                    WantSnackbarVariant.success => WantIcons.success,
                  },
                  role: status!.name,
                  color: WantTheme.of(context).color('${status!.name}-text'),
                )),
      variant: destructive || status == WantSnackbarVariant.error
          ? FAlertVariant.destructive
          : FAlertVariant.primary,
      style: FAlertStyleDelta.delta(
        decoration: DecorationDelta.value(
          BoxDecoration(
            color: WantTheme.of(context).color('secondary'),
            borderRadius: BorderRadius.circular(
              WantTheme.of(context).fieldRadius,
            ),
          ),
        ),
      ),
    ),
  );
}
