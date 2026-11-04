import 'dart:math' as math;

import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:forui/forui.dart';

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
  final Object Function(T row)? rowKey;
  final Object? transitionKey;
  const WantTable({
    super.key,
    required this.rows,
    required this.columns,
    required this.caption,
    required this.emptyLabel,
    this.footer,
    this.rowKey,
    this.transitionKey,
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
                color: theme.color('foreground'),
                fontFeatures: const [FontFeature.tabularFigures()],
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
              WantViewportMotion(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
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
                          decoration: BoxDecoration(color: theme.color('card')),
                          children: [
                            for (final column in columns)
                              cell(
                                column.onSort == null
                                    ? Text(column.label)
                                    : Semantics(
                                        button: true,
                                        label: column.sortLabel ?? column.label,
                                        child: FTappable(
                                          onPress: column.onSort,
                                          selectable:
                                              kIsWeb ||
                                              WantWebScope.enabledOf(context),
                                          focusedOutlineStyle: theme
                                              .forui
                                              .buttonStyles
                                              .resolve({
                                                FButtonVariant.secondary,
                                              })
                                              .resolve({FButtonSizeVariant.md})
                                              .focusedOutlineStyle,
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              minHeight: 44,
                                              minWidth: 44,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: WantSelectable(
                                                    child: Text(column.label),
                                                  ),
                                                ),
                                                Icon(
                                                  column.ascending == false
                                                      ? WantIcons.arrowDown
                                                      : WantIcons.arrowUp,
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                column,
                                header: true,
                              ),
                          ],
                        ),
                        for (var index = 0; index < rows.length; index++)
                          TableRow(
                            children: [
                              for (final column in columns)
                                _WantTableReveal(
                                  key: ValueKey((
                                    transitionKey,
                                    rowKey?.call(rows[index]) ?? index,
                                    columns.indexOf(column),
                                  )),
                                  index: index,
                                  enabled: transitionKey != null,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                    ),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: theme.color(
                                          index.isEven ? 'secondary' : 'muted',
                                        ),
                                        borderRadius:
                                            BorderRadiusDirectional.only(
                                              topStart: Radius.circular(
                                                column == columns.first
                                                    ? 12
                                                    : 0,
                                              ),
                                              bottomStart: Radius.circular(
                                                column == columns.first
                                                    ? 12
                                                    : 0,
                                              ),
                                              topEnd: Radius.circular(
                                                column == columns.last ? 12 : 0,
                                              ),
                                              bottomEnd: Radius.circular(
                                                column == columns.last ? 12 : 0,
                                              ),
                                            ),
                                      ),
                                      child: cell(
                                        column.cellBuilder(rows[index]),
                                        column,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
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

class _WantTableReveal extends StatefulWidget {
  final Widget child;
  final int index;
  final bool enabled;
  const _WantTableReveal({
    super.key,
    required this.child,
    required this.index,
    required this.enabled,
  });
  @override
  State<_WantTableReveal> createState() => _WantTableRevealState();
}

class _WantTableRevealState extends State<_WantTableReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  )..forward();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || WantTheme.reducedMotionOf(context)) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final start = math.min(widget.index, 8) * .065;
        final value = Curves.easeOutCubic.transform(
          ((_controller.value - start) / (1 - start)).clamp(0.0, 1.0),
        );
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }
}
