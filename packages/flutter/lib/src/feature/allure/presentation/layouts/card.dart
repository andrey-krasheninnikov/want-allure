import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
