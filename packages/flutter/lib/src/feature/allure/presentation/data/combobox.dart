import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantCombobox<T> extends StatelessWidget {
  final T? value;
  final List<WantOption<T>> options;
  final ValueChanged<T?>? onChanged;
  final Widget label;
  final String emptyLabel, searchHint;
  final bool enabled, filterLocally, loading;
  final TextEditingController? queryController;
  final ValueChanged<String>? onQueryChanged;
  final Widget? loadingIndicator, error, retryAction;
  final String Function(T)? valueLabel;

  const WantCombobox({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.label,
    required this.emptyLabel,
    required this.searchHint,
    this.enabled = true,
    this.queryController,
    this.onQueryChanged,
    this.filterLocally = true,
    this.loading = false,
    this.loadingIndicator,
    this.error,
    this.retryAction,
    this.valueLabel,
  });
  Iterable<WantOption<T>> _matches(String query) {
    if (loading || error != null) return [];
    final text = query.trim().toLowerCase();
    return filterLocally
        ? options.where((item) => item.label.toLowerCase().contains(text))
        : options;
  }

  @override
  Widget build(BuildContext context) => FSelect<T>.searchBuilder(
    format: (value) =>
        valueLabel?.call(value) ??
        options.where((item) => item.value == value).firstOrNull?.label ??
        '',
    filter: (query) => _matches(query).map((item) => item.value),
    contentBuilder: (context, query, values) => [
      for (final item in _matches(query))
        FSelectItem<T>(
          title: WantSelectable(
            enabled: !item.disabled,
            child: Text(item.label),
          ),
          value: item.value,
          enabled: !item.disabled,
        ),
    ],
    control: FSelectControl.lifted(
      value: value,
      onChange: (value) => onChanged?.call(value),
    ),
    label: label,
    hint: searchHint,
    enabled: enabled && onChanged != null,
    searchFieldProperties: FSelectSearchFieldProperties(
      hint: searchHint,
      control: FTextFieldControl.managed(controller: queryController),
      onChange: (value) => onQueryChanged?.call(value.text),
    ),
    contentEmptyBuilder: (context, style) => Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: error != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [error!, ?retryAction],
              )
            : loading
            ? loadingIndicator ?? WantLoader(label: searchHint)
            : Text(emptyLabel),
      ),
    ),
  );
}
