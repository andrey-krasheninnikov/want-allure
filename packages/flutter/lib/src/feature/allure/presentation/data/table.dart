import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
                                            ? WantIcons.arrowDown
                                            : WantIcons.arrowUp,
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
