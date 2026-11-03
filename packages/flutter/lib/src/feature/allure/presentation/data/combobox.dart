import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantCombobox<T> extends StatelessWidget {
  final T? value;
  final List<WantOption<T>> options;
  final ValueChanged<T?>? onChanged;
  final Widget label;
  final String emptyLabel, searchHint;
  final bool enabled;
  const WantCombobox({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.label,
    required this.emptyLabel,
    required this.searchHint,
    this.enabled = true,
  });
  @override
  Widget build(BuildContext context) => FSelect<T>.searchBuilder(
    format: (value) =>
        options.where((item) => item.value == value).firstOrNull?.label ?? '',
    filter: (query) => options
        .where(
          (item) =>
              item.label.toLowerCase().contains(query.trim().toLowerCase()),
        )
        .map((item) => item.value),
    contentBuilder: (context, query, values) => [
      for (final value in values)
        FSelectItem<T>(
          title: WantSelectable(
            enabled: !options
                .firstWhere((item) => item.value == value)
                .disabled,
            child: Text(
              options.firstWhere((item) => item.value == value).label,
            ),
          ),
          value: value,
          enabled: !options.firstWhere((item) => item.value == value).disabled,
        ),
    ],
    control: FSelectControl.lifted(
      value: value,
      onChange: (value) => onChanged?.call(value),
    ),
    label: label,
    hint: searchHint,
    enabled: enabled && onChanged != null,
    searchFieldProperties: FSelectSearchFieldProperties(hint: searchHint),
    contentEmptyBuilder: (context, style) => Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(emptyLabel),
      ),
    ),
  );
}
