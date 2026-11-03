import 'dart:math' as math;

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantTableColumn<T> {
  final String label;
  final String? sortLabel;
  final AlignmentGeometry alignment;
  final Widget Function(T row) cellBuilder;
  final double width;
  final VoidCallback? onSort;
  final bool? ascending;
  const WantTableColumn({
    required this.label,
    required this.cellBuilder,
    this.sortLabel,
    this.alignment = AlignmentDirectional.centerStart,
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
    Widget cell(
      Widget child,
      WantTableColumn<T> column, {
      bool header = false,
    }) => Semantics(
      role: header ? SemanticsRole.columnHeader : SemanticsRole.cell,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Align(
            alignment: column.alignment,
            child: DefaultTextStyle.merge(
              style: TextStyle(
                fontSize: header ? 14 : 16,
                fontWeight: header ? FontWeight.w600 : FontWeight.normal,
                color: theme.color(header ? 'muted-foreground' : 'foreground'),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
    final totalWidth = columns.fold<double>(
      0,
      (sum, column) => sum + column.width,
    );
    return LayoutBuilder(
      builder: (context, constraints) => Semantics(
        container: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            WantTypography(
              caption,
              variant: WantTypographyVariant.small,
              colorRole: 'muted-foreground',
            ),
            if (rows.isEmpty)
              Text(emptyLabel)
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      for (var index = 0; index < columns.length; index++)
                        index: FixedColumnWidth(
                          constraints.maxWidth.isFinite && totalWidth > 0
                              ? math.max(
                                  columns[index].width,
                                  constraints.maxWidth *
                                      columns[index].width /
                                      totalWidth,
                                )
                              : columns[index].width,
                        ),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: theme.color('secondary'),
                        ),
                        children: [
                          for (final column in columns)
                            cell(
                              column.onSort == null
                                  ? Text(column.label)
                                  : WantButton(
                                      onPressed: column.onSort,
                                      variant: WantButtonVariant.ghost,
                                      semanticsLabel:
                                          column.sortLabel ?? column.label,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(child: Text(column.label)),
                                          Icon(
                                            column.ascending == false
                                                ? WantIcons.arrowDown
                                                : WantIcons.arrowUp,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                              column,
                              header: true,
                            ),
                        ],
                      ),
                      for (var index = 0; index < rows.length; index++)
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.color(
                              index.isEven ? 'card' : 'secondary',
                            ),
                          ),
                          children: [
                            for (final column in columns)
                              cell(column.cellBuilder(rows[index]), column),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ?footer,
          ],
        ),
      ),
    );
  }
}
