import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
