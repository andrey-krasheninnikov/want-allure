import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
        FAccordionItem(
          title: WantSelectable(child: item.title),
          child: item.child,
        ),
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
            child: WantSelectable(child: Center(child: tab.label)),
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
              : WantDropdownMenu(
                  label: WantSelectable(child: item.label),
                  items: item.children,
                ),
      ],
    ),
  );
}
