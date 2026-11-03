import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantContactAction {
  final String title;
  final String? detail, semanticsLabel;
  final Widget? icon;
  final VoidCallback onPressed;
  const WantContactAction({
    required this.title,
    required this.onPressed,
    this.detail,
    this.semanticsLabel,
    this.icon,
  });
}

class WantContactCard extends StatelessWidget {
  final String name;
  final String? subtitle;
  final List<WantContactAction> actions;
  const WantContactCard({
    super.key,
    required this.name,
    required this.actions,
    this.subtitle,
  });
  @override
  Widget build(BuildContext context) => WantCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        Row(
          spacing: 12,
          children: [
            ExcludeSemantics(
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: WantTheme.of(context).color('secondary'),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  name
                      .trim()
                      .split(RegExp(r'\s+'))
                      .where((part) => part.isNotEmpty)
                      .take(2)
                      .map((part) => String.fromCharCode(part.runes.first))
                      .join()
                      .toUpperCase(),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (subtitle != null)
                    WantTypography(
                      subtitle!,
                      variant: WantTypographyVariant.small,
                      colorRole: 'muted-foreground',
                    ),
                ],
              ),
            ),
          ],
        ),
        for (final action in actions)
          DecoratedBox(
            decoration: BoxDecoration(
              color: WantTheme.of(context).color('secondary'),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 8, 10),
              child: Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        Text(action.title),
                        if (action.detail != null)
                          Text(
                            action.detail!,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontSize: 14,
                              color: WantTheme.of(context)
                                  .color('muted-foreground'),
                            ),
                          ),
                      ],
                    ),
                  ),
                  WantTooltip(
                    message: action.semanticsLabel ?? action.title,
                    child: WantButton(
                      size: WantButtonSize.icon,
                      variant: WantButtonVariant.ghost,
                      semanticsLabel: action.semanticsLabel ?? action.title,
                      onPressed: action.onPressed,
                      child:
                          action.icon ??
                          const WantIcon(WantIcons.arrowUpRight, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}
