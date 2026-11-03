import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantLabel extends StatelessWidget {
  final Widget child;
  final FocusNode? focusNode;
  const WantLabel({super.key, required this.child, this.focusNode});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: focusNode?.requestFocus,
    child: DefaultTextStyle.merge(
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      child: child,
    ),
  );
}

class WantField extends StatelessWidget {
  final Widget child;
  final Widget? label, description, error;
  final FocusNode? focusNode;
  const WantField({
    super.key,
    required this.child,
    this.label,
    this.description,
    this.error,
    this.focusNode,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    spacing: 8,
    children: [
      if (label != null) WantLabel(focusNode: focusNode, child: label!),
      child,
      if (error != null || description != null)
        Semantics(
          liveRegion: error != null,
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: 14,
              color: WantTheme.of(context)
                  .color(error == null ? 'muted-foreground' : 'error-text'),
            ),
            child: error ?? description!,
          ),
        ),
    ],
  );
}

class WantFieldGroup extends StatelessWidget {
  final List<Widget> children;
  final Widget? legend;
  const WantFieldGroup({super.key, required this.children, this.legend});
  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [?legend, ...children],
    ),
  );
}
