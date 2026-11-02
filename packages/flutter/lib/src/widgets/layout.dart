import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import '../foundation/theme.dart';
import '../foundation/tokens.g.dart';
import 'controls.dart';
import 'typography.dart';

class WantCard extends StatelessWidget {
  final Widget child;
  final Widget? title, description, actions, footer;
  final EdgeInsetsGeometry padding;
  const WantCard({
    super.key,
    required this.child,
    this.title,
    this.description,
    this.actions,
    this.footer,
    this.padding = const EdgeInsets.all(24),
  });
  @override
  Widget build(BuildContext context) => FCard(
    child: Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          if (title != null || description != null || actions != null)
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 16,
              runSpacing: 12,
              children: [
                if (title != null || description != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      if (title != null)
                        DefaultTextStyle(
                          style: WantTheme.of(context)
                              .forui
                              .typography
                              .display
                              .lg,
                          child: title!,
                        ),
                      if (description != null)
                        DefaultTextStyle.merge(
                          style: TextStyle(
                            fontSize: 14,
                            color: WantTheme.of(context)
                                .color('muted-foreground'),
                          ),
                          child: description!,
                        ),
                    ],
                  ),
                ?actions,
              ],
            ),
          child,
          ?footer,
        ],
      ),
    ),
  );
}

class WantWindow extends StatelessWidget {
  final String title;
  final String? kicker;
  final Widget? actions;
  final Widget child;
  const WantWindow({
    super.key,
    required this.title,
    required this.child,
    this.kicker,
    this.actions,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    spacing: 24,
    children: [
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 16,
        runSpacing: 12,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              if (kicker != null)
                WantTypography(
                  kicker!,
                  variant: WantTypographyVariant.overline,
                  colorRole: 'muted-foreground',
                ),
              WantTypography(title, variant: WantTypographyVariant.h1),
            ],
          ),
          ?actions,
        ],
      ),
      child,
    ],
  );
}

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

class WantSeparator extends StatelessWidget {
  final double space;
  final Axis axis;
  const WantSeparator({
    super.key,
    this.space = 24,
    this.axis = Axis.horizontal,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    height: axis == Axis.horizontal ? space : null,
    width: axis == Axis.vertical ? space : null,
  );
}

class WantSkeleton extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius borderRadius;
  const WantSkeleton({
    super.key,
    this.width,
    this.height = 20,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: WantTheme.of(context).color('secondary'),
        borderRadius: borderRadius,
      ),
    ),
  );
}

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

class WantAccordionItem {
  final Widget title, child;
  const WantAccordionItem({required this.title, required this.child});
}

class WantAccordion extends StatelessWidget {
  final List<WantAccordionItem> items;
  final bool multiple;
  const WantAccordion({super.key, required this.items, this.multiple = false});
  @override
  Widget build(BuildContext context) => FAccordion(
    control: FAccordionControl.managed(max: multiple ? null : 1),
    children: [
      for (final item in items)
        FAccordionItem(title: item.title, child: item.child),
    ],
  );
}

class WantTab {
  final Widget label, child;
  const WantTab({required this.label, required this.child});
}

class WantTabs extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final List<WantTab> tabs;
  const WantTabs({
    super.key,
    required this.value,
    required this.onChanged,
    required this.tabs,
  });
  @override
  Widget build(BuildContext context) => FTabs(
    control: FTabControl.lifted(
      index: value,
      onChange: onChanged,
      motion: FTabMotion(
        duration: WantTokens.motion['transitionMs']!,
        curve: const Cubic(.32, .72, 0, 1),
      ),
    ),
    scrollable: true,
    children: [
      for (final tab in tabs)
        FTabEntry(
          label: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
            child: Center(child: tab.label),
          ),
          child: tab.child,
        ),
    ],
  );
}

class WantNavigationItem {
  final Widget label;
  final VoidCallback? onPressed;
  final bool current;
  final List<WantMenuItem> children;
  const WantNavigationItem({
    required this.label,
    this.onPressed,
    this.current = false,
    this.children = const [],
  });
}

class WantNavigationMenu extends StatelessWidget {
  final String semanticsLabel;
  final List<WantNavigationItem> items;
  const WantNavigationMenu({
    super.key,
    required this.semanticsLabel,
    required this.items,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticsLabel,
    container: true,
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          item.children.isEmpty
              ? Semantics(
                  selected: item.current,
                  child: WantButton(
                    variant: item.current
                        ? WantButtonVariant.primary
                        : WantButtonVariant.secondary,
                    onPressed: item.onPressed,
                    child: item.label,
                  ),
                )
              : WantDropdownMenu(label: item.label, items: item.children),
      ],
    ),
  );
}

class WantBreadcrumbItem {
  final Widget label;
  final VoidCallback? onPressed;
  const WantBreadcrumbItem({required this.label, this.onPressed});
}

class WantBreadcrumb extends StatelessWidget {
  final List<WantBreadcrumbItem> items;
  final String semanticsLabel;
  const WantBreadcrumb({
    super.key,
    required this.items,
    required this.semanticsLabel,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticsLabel,
    container: true,
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 8,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            ExcludeSemantics(
              child: Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? FLucideIcons.chevronLeft
                    : FLucideIcons.chevronRight,
                size: 16,
              ),
            ),
          Semantics(
            selected: i == items.length - 1,
            child: items[i].onPressed == null
                ? ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 44,
                      minHeight: 44,
                    ),
                    child: WantBadge(
                      variant: WantButtonVariant.secondary,
                      child: items[i].label,
                    ),
                  )
                : WantButton(
                    variant: WantButtonVariant.secondary,
                    onPressed: items[i].onPressed,
                    child: items[i].label,
                  ),
          ),
        ],
      ],
    ),
  );
}

class WantMenuItem {
  final Widget label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool disabled;
  const WantMenuItem({
    required this.label,
    this.onPressed,
    this.icon,
    this.disabled = false,
  });
}

class WantDropdownMenu extends StatelessWidget {
  final Widget label;
  final List<WantMenuItem> items;
  const WantDropdownMenu({super.key, required this.label, required this.items});
  @override
  Widget build(BuildContext context) => FPopoverMenu(
    menuBuilder: (context, controller, _) => [
      FItemGroup(
        children: [
          for (final item in items)
            FItem(
              title: item.label,
              prefix: item.icon,
              enabled: !item.disabled,
              onPress: item.disabled
                  ? null
                  : () {
                      controller.hide();
                      item.onPressed?.call();
                    },
            ),
        ],
      ),
    ],
    builder: (context, controller, _) => WantButton(
      onPressed: controller.toggle,
      variant: WantButtonVariant.secondary,
      child: label,
    ),
  );
}

class WantPopover extends StatelessWidget {
  final Widget child;
  final Widget Function(BuildContext, VoidCallback close) contentBuilder;
  final Widget Function(BuildContext, VoidCallback toggle, Widget child)
  triggerBuilder;
  const WantPopover({
    super.key,
    required this.child,
    required this.contentBuilder,
    required this.triggerBuilder,
  });
  @override
  Widget build(BuildContext context) => FPopover(
    popoverBuilder: (context, controller) => Padding(
      padding: const EdgeInsets.all(16),
      child: contentBuilder(context, controller.hide),
    ),
    builder: (context, controller, child) =>
        triggerBuilder(context, controller.toggle, child!),
    child: child,
  );
}

class WantTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  const WantTooltip({super.key, required this.message, required this.child});
  @override
  Widget build(BuildContext context) =>
      FTooltip(tipBuilder: (context, _) => Text(message), child: child);
}

class WantDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? actions;
  const WantDialog({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });
  @override
  Widget build(BuildContext context) => FDialog(
    animation: ModalRoute.of(context)?.animation,
    semanticsLabel: title,
    builder: (context, style) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 20,
        children: [
          WantTypography(title, variant: WantTypographyVariant.h3),
          child,
          ?actions,
        ],
      ),
    ),
  );
}

Future<T?> showWantDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool dismissible = true,
  String? barrierLabel,
}) => showFDialog<T>(
  context: context,
  barrierDismissible: dismissible,
  barrierLabel: barrierLabel,
  builder: (context, style, animation) => builder(context),
);

enum WantSheetSide { top, right, bottom, left }

class WantSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? actions;
  const WantSheet({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    namesRoute: true,
    label: title,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20,
          children: [
            WantTypography(title, variant: WantTypographyVariant.h3),
            child,
            ?actions,
          ],
        ),
      ),
    ),
  );
}

Future<T?> showWantSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  WantSheetSide side = WantSheetSide.bottom,
  String? barrierLabel,
}) => showFSheet<T>(
  context: context,
  builder: builder,
  useSafeArea: true,
  barrierLabel: barrierLabel,
  side: switch (side) {
    WantSheetSide.top => FLayout.ttb,
    WantSheetSide.bottom => FLayout.btt,
    WantSheetSide.left => FLayout.ltr,
    WantSheetSide.right => FLayout.rtl,
  },
);

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
