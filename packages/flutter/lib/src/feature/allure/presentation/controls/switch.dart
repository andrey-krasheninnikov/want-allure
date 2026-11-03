import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

class WantSwitch extends StatelessWidget {
  final bool value, enabled;
  final ValueChanged<bool>? onChanged;
  final Widget? label, description;
  final FocusNode? focusNode;
  const WantSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.label,
    this.description,
    this.focusNode,
  });
  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
    child: FSwitch(
      value: value,
      onChange: onChanged,
      enabled: enabled && onChanged != null,
      label: label == null
          ? null
          : WantSelectable(
              enabled: enabled && onChanged != null,
              child: label!,
            ),
      description: description,
      focusNode: focusNode,
    ),
  );
}
