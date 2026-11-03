import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart'
    show CheckboxListTile, ListTileControlAffinity;

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantCheckbox extends StatelessWidget {
  final bool value, enabled, indeterminate;
  final ValueChanged<bool>? onChanged;
  final Widget? label, description, error;
  final FocusNode? focusNode;
  const WantCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.indeterminate = false,
    this.label,
    this.description,
    this.error,
    this.focusNode,
  });
  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
    child: indeterminate
        ? CheckboxListTile(
            value: null,
            tristate: true,
            onChanged: enabled && onChanged != null
                ? (_) => onChanged!(true)
                : null,
            title: label == null
                ? null
                : WantSelectable(
                    enabled: enabled && onChanged != null,
                    child: label!,
                  ),
            subtitle: error ?? description,
            focusNode: focusNode,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: WantTheme.of(context).color('primary'),
            checkColor: WantTheme.of(context).color('primary-foreground'),
          )
        : FCheckbox(
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
            error: error,
            focusNode: focusNode,
          ),
  );
}
