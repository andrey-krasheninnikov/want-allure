import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
