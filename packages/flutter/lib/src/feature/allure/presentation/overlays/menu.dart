import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
              title: WantSelectable(enabled: !item.disabled, child: item.label),
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
