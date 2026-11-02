import 'dart:math' as math;
import 'dart:ui' show SemanticsRole;

import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import '../foundation/theme.dart';
import 'controls.dart';

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
          title: Text(options.firstWhere((item) => item.value == value).label),
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

class WantPaginationLabels {
  final String navigation, previous, next, pageSize;
  final String Function(int page) page;
  final String Function(int from, int to, int total) results;
  const WantPaginationLabels({
    required this.navigation,
    required this.previous,
    required this.next,
    required this.pageSize,
    required this.page,
    required this.results,
  });
}

class WantPagination extends StatelessWidget {
  final int page, pageSize, totalItems;
  final List<int> pageSizeOptions;
  final void Function(int page, int pageSize) onChanged;
  final WantPaginationLabels labels;
  const WantPagination({
    super.key,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.onChanged,
    required this.labels,
    this.pageSizeOptions = const [10, 25, 50],
  });
  @override
  Widget build(BuildContext context) {
    final size = math.max(1, pageSize), total = math.max(0, totalItems);
    final count = math.max(1, (total / size).ceil()),
        current = page.clamp(1, math.max(1, (total / size).ceil())).toInt();
    final start = math.max(1, math.min(current - 2, count - 4));
    final sizes = {
      size,
      ...pageSizeOptions.where((value) => value > 0),
    }.toList()..sort();
    return Semantics(
      container: true,
      label: labels.navigation,
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Semantics(
            liveRegion: true,
            child: Text(
              labels.results(
                total == 0 ? 0 : (current - 1) * size + 1,
                math.min(current * size, total),
                total,
              ),
            ),
          ),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              WantButton(
                size: WantButtonSize.icon,
                semanticsLabel: labels.previous,
                variant: WantButtonVariant.secondary,
                onPressed: current == 1
                    ? null
                    : () => onChanged(current - 1, size),
                child: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? FLucideIcons.chevronRight
                      : FLucideIcons.chevronLeft,
                ),
              ),
              for (
                var value = start;
                value < start + math.min(5, count);
                value++
              )
                Semantics(
                  selected: value == current,
                  child: WantButton(
                    variant: value == current
                        ? WantButtonVariant.primary
                        : WantButtonVariant.secondary,
                    semanticsLabel: labels.page(value),
                    onPressed: () {
                      if (value != current) onChanged(value, size);
                    },
                    child: Text('$value'),
                  ),
                ),
              WantButton(
                size: WantButtonSize.icon,
                semanticsLabel: labels.next,
                variant: WantButtonVariant.secondary,
                onPressed: current == count
                    ? null
                    : () => onChanged(current + 1, size),
                child: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? FLucideIcons.chevronLeft
                      : FLucideIcons.chevronRight,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 160,
            child: WantSelect<int>(
              value: size,
              label: Text(labels.pageSize),
              options: [
                for (final value in sizes)
                  WantOption(value: value, label: '$value'),
              ],
              onChanged: (next) {
                if (next != null) onChanged(1, next);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WantTableColumn<T> {
  final String label;
  final Widget Function(T row) cellBuilder;
  final double width;
  final VoidCallback? onSort;
  final bool? ascending;
  const WantTableColumn({
    required this.label,
    required this.cellBuilder,
    this.width = 180,
    this.onSort,
    this.ascending,
  });
}

class WantTable<T> extends StatelessWidget {
  final List<T> rows;
  final List<WantTableColumn<T>> columns;
  final String caption, emptyLabel;
  final Widget? footer;
  const WantTable({
    super.key,
    required this.rows,
    required this.columns,
    required this.caption,
    required this.emptyLabel,
    this.footer,
  });
  @override
  Widget build(BuildContext context) {
    final theme = WantTheme.of(context);
    Widget cell(Widget child, {bool header = false}) => Semantics(
      role: header ? SemanticsRole.columnHeader : SemanticsRole.cell,
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
    return Semantics(
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(caption),
          if (rows.isEmpty)
            Text(emptyLabel)
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  for (var index = 0; index < columns.length; index++)
                    index: FixedColumnWidth(columns[index].width),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: theme.color('secondary')),
                    children: [
                      for (final column in columns)
                        cell(
                          column.onSort == null
                              ? Text(column.label)
                              : WantButton(
                                  onPressed: column.onSort,
                                  variant: WantButtonVariant.secondary,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(child: Text(column.label)),
                                      Icon(
                                        column.ascending == false
                                            ? FLucideIcons.arrowDown
                                            : FLucideIcons.arrowUp,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                          header: true,
                        ),
                    ],
                  ),
                  for (var index = 0; index < rows.length; index++)
                    TableRow(
                      decoration: BoxDecoration(
                        color: theme.color(
                          index.isEven ? 'card' : 'background',
                        ),
                      ),
                      children: [
                        for (final column in columns)
                          cell(column.cellBuilder(rows[index])),
                      ],
                    ),
                ],
              ),
            ),
          ?footer,
        ],
      ),
    );
  }
}

class WantProgress extends StatelessWidget {
  final double? value;
  final double max;
  final String label;
  const WantProgress({
    super.key,
    required this.label,
    this.value,
    this.max = 100,
  });
  @override
  Widget build(BuildContext context) {
    final amount = value;
    if (amount == null) return FProgress(semanticsLabel: label);
    final normalized = amount.isFinite && max.isFinite && max > 0
        ? (amount / max).clamp(0.0, 1.0)
        : 0.0;
    return FDeterminateProgress(value: normalized, semanticsLabel: label);
  }
}
