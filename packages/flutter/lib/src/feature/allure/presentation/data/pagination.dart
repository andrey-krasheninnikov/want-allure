import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
                child: Icon(WantIcons.chevronLeft),
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
                child: Icon(WantIcons.chevronRight),
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
