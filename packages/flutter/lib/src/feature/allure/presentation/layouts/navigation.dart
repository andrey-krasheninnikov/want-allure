import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
            ExcludeSemantics(child: Icon(WantIcons.chevronRight, size: 16)),
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
