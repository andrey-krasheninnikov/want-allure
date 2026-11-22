import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantListRow extends StatelessWidget {
  final Widget child;
  final Widget? leading, trailing;
  final bool selected;
  final VoidCallback onSelected;
  const WantListRow({
    super.key,
    required this.child,
    required this.onSelected,
    this.leading,
    this.trailing,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    child: WantButton(
      pill: false,
      variant: selected ? WantButtonVariant.secondary : WantButtonVariant.ghost,
      onPressed: onSelected,
      child: Row(
        spacing: 8,
        children: [
          if (leading != null) ExcludeSemantics(child: leading!),
          Expanded(child: child),
          ?trailing,
        ],
      ),
    ),
  );
}

typedef WantSidebarItem = ({String id, String label, Widget icon, int? count});

class WantSidebar extends StatefulWidget {
  final String label, toggleLabel, closeLabel, selected;
  final List<WantSidebarItem> items;
  final bool expanded;
  final ValueChanged<String> onSelected;
  final ValueChanged<bool> onExpandedChanged;
  final Widget child;
  const WantSidebar({
    super.key,
    required this.label,
    required this.toggleLabel,
    required this.closeLabel,
    required this.items,
    required this.selected,
    required this.onSelected,
    required this.expanded,
    required this.onExpandedChanged,
    required this.child,
  });

  @override
  State<WantSidebar> createState() => _WantSidebarState();
}

class _WantSidebarState extends State<WantSidebar> {
  final _toggle = FocusNode();
  final _overlay = FocusScopeNode(
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
  );

  @override
  void dispose() {
    _toggle.dispose();
    _overlay.dispose();
    super.dispose();
  }

  void _close() {
    widget.onExpandedChanged(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !widget.expanded) _toggle.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final dock =
          box.maxWidth >= 1000 &&
          MediaQuery.textScalerOf(context).scale(16) <= 24;
      final overlay = widget.expanded && !dock;
      final rail = widget.expanded && dock ? 244.0 : 56.0;
      Widget menu(bool wide, {bool modal = false}) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 4,
            children: [
              WantIconButton(
                label: modal ? widget.closeLabel : widget.toggleLabel,
                focusNode: modal ? null : _toggle,
                autofocus: modal,
                onPressed: widget.expanded
                    ? _close
                    : () => widget.onExpandedChanged(true),
                child: WantIcon(modal ? WantIcons.x : WantIcons.list),
              ),
              for (final item in widget.items)
                if (wide)
                  WantListRow(
                    selected: item.id == widget.selected,
                    leading: item.icon,
                    trailing: item.count == null
                        ? null
                        : Text(item.count.toString()),
                    onSelected: () {
                      widget.onSelected(item.id);
                      if (modal) _close();
                    },
                    child: Text(item.label),
                  )
                else
                  WantTooltip(
                    message: item.label,
                    child: Semantics(
                      selected: item.id == widget.selected,
                      child: WantButton(
                        pill: false,
                        size: WantButtonSize.icon,
                        semanticsLabel: item.label,
                        variant: item.id == widget.selected
                            ? WantButtonVariant.secondary
                            : WantButtonVariant.ghost,
                        onPressed: () => widget.onSelected(item.id),
                        child: item.icon,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      );
      final theme = WantTheme.of(context);
      return Stack(
        children: [
          ExcludeFocus(
            excluding: overlay,
            child: ExcludeSemantics(
              excluding: overlay,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: rail,
                    child: ColoredBox(
                      color: theme.color('card'),
                      child: menu(rail > 56),
                    ),
                  ),
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ),
          if (overlay) ...[
            Positioned.fill(
              child: ModalBarrier(
                color: theme.color('foreground').withValues(alpha: .14),
                semanticsLabel: widget.closeLabel,
                onDismiss: _close,
              ),
            ),
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              width: math.max(0, math.min(244, box.maxWidth - 44)),
              child: BlockSemantics(
                child: FocusScope.withExternalFocusNode(
                  focusScopeNode: _overlay,
                  child: CallbackShortcuts(
                    bindings: {
                      const SingleActivator(LogicalKeyboardKey.escape): _close,
                    },
                    child: Semantics(
                      label: widget.label,
                      container: true,
                      child: ColoredBox(
                        color: theme.color('popover'),
                        child: menu(true, modal: true),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    },
  );
}

typedef WantPane = ({
  String id,
  double minimum,
  Widget child,
  String resizeLabel,
});

class WantSplitPane extends StatelessWidget {
  final List<WantPane> panes;
  final List<double> fractions;
  final Map<String, double>? fractionsById;
  final ValueChanged<Map<String, double>>? onFractionsChanged;
  final ValueChanged<List<double>> onChanged;
  final Widget compact;
  const WantSplitPane({
    super.key,
    required this.panes,
    required this.fractions,
    required this.onChanged,
    this.fractionsById,
    this.onFractionsChanged,
    required this.compact,
  });

  const WantSplitPane.keyed({
    super.key,
    required this.panes,
    required Map<String, double> fractions,
    required ValueChanged<Map<String, double>> onChanged,
    required this.compact,
  }) : fractionsById = fractions,
       onFractionsChanged = onChanged,
       fractions = const [],
       onChanged = _ignoreLegacyFractions;

  static void _ignoreLegacyFractions(List<double> _) {}
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      const gutter = 12.0;
      final space = box.maxWidth - (panes.length - 1) * gutter;
      final minima = panes
          .map(
            (pane) => pane.minimum.isFinite ? math.max(0.0, pane.minimum) : 0.0,
          )
          .toList();
      if (panes.length < 2 ||
          !space.isFinite ||
          space <= 0 ||
          space < minima.fold(0.0, (a, b) => a + b)) {
        return compact;
      }
      final weights = List.generate(panes.length, (i) {
        final weight = fractionsById == null
            ? (i < fractions.length ? fractions[i] : 0.0)
            : fractionsById![panes[i].id] ?? 1 / panes.length;
        return weight.isFinite ? math.max(0, weight).toDouble() : 0.0;
      });
      final total = weights.fold(0.0, (a, b) => a + b);
      final preferred = weights
          .map(
            (weight) => space * (total > 0 ? weight / total : 1 / panes.length),
          )
          .toList();
      var deficit = 0.0, surplus = 0.0;
      for (var i = 0; i < panes.length; i++) {
        deficit += math.max(0.0, minima[i] - preferred[i]);
        surplus += math.max(0.0, preferred[i] - minima[i]);
      }
      final widths = List.generate(
        panes.length,
        (i) => preferred[i] < minima[i]
            ? minima[i]
            : preferred[i] -
                  (surplus > 0
                      ? deficit * (preferred[i] - minima[i]) / surplus
                      : 0),
      );
      final rtl = Directionality.of(context) == TextDirection.rtl;
      void resize(int i, double delta) {
        final change = (rtl ? -delta : delta)
            .clamp(
              math.min(0.0, minima[i] - widths[i]),
              math.max(0.0, widths[i + 1] - minima[i + 1]),
            )
            .toDouble();
        final next = [
          for (var j = 0; j < widths.length; j++)
            (widths[j] +
                    (j == i
                        ? change
                        : j == i + 1
                        ? -change
                        : 0)) /
                space,
        ];
        onChanged(next);
        onFractionsChanged?.call({
          for (var j = 0; j < panes.length; j++) panes[j].id: next[j],
        });
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < panes.length; i++) ...[
            SizedBox(
              key: ValueKey(('pane', panes[i].id)),
              width: widths[i],
              child: panes[i].child,
            ),
            if (i < panes.length - 1)
              _PaneHandle(
                key: ValueKey(('separator', panes[i].id)),
                width: gutter,
                height: box.hasBoundedHeight ? box.maxHeight : 240,
                label: panes[i].resizeLabel,
                value: widths[i],
                minimum: minima[i],
                maximum: widths[i] + widths[i + 1] - minima[i + 1],
                onDelta: (delta) => resize(i, delta),
              ),
          ],
        ],
      );
    },
  );
}

class _PaneHandle extends StatefulWidget {
  final double width, height, value, minimum, maximum;
  final String label;
  final ValueChanged<double> onDelta;
  const _PaneHandle({
    super.key,
    required this.width,
    required this.height,
    required this.label,
    required this.value,
    required this.minimum,
    required this.maximum,
    required this.onDelta,
  });

  @override
  State<_PaneHandle> createState() => _PaneHandleState();
}

class _PaneHandleState extends State<_PaneHandle> {
  final _focus = FocusNode();
  bool _hover = false, _drag = false;
  double _offset = 0;
  ValueChanged<double>? _resizeFromStart;

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = WantTheme.of(context);
    final forward = Directionality.of(context) == TextDirection.rtl
        ? -16.0
        : 16.0;
    return Semantics(
      label: widget.label,
      value: widget.value.round().toString(),
      increasedValue: math
          .min(widget.maximum, widget.value + 16)
          .round()
          .toString(),
      decreasedValue: math
          .max(widget.minimum, widget.value - 16)
          .round()
          .toString(),
      onIncrease: widget.maximum - widget.value > .01
          ? () => widget.onDelta(forward)
          : null,
      onDecrease: widget.value - widget.minimum > .01
          ? () => widget.onDelta(-forward)
          : null,
      child: Focus(
        focusNode: _focus,
        onFocusChange: (_) => setState(() {}),
        onKeyEvent: (_, event) {
          if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
            return KeyEventResult.ignored;
          }
          final key = event.logicalKey;
          if (key != LogicalKeyboardKey.arrowLeft &&
              key != LogicalKeyboardKey.arrowRight) {
            return KeyEventResult.ignored;
          }
          widget.onDelta(key == LogicalKeyboardKey.arrowLeft ? -16 : 16);
          return KeyEventResult.handled;
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (_) {
              _focus.requestFocus();
              _offset = 0;
              _resizeFromStart = widget.onDelta;
              setState(() => _drag = true);
            },
            onHorizontalDragUpdate: (event) {
              _offset += event.delta.dx;
              _resizeFromStart?.call(_offset);
            },
            onHorizontalDragEnd: (_) => setState(() => _drag = false),
            onHorizontalDragCancel: () => setState(() => _drag = false),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: Center(
                child: Container(
                  width: _drag || _focus.hasFocus ? 4 : 2,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: theme.color(
                      _focus.hasFocus || _drag
                          ? 'ring'
                          : _hover
                          ? 'primary'
                          : 'input',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef WantSearchFilter = ({
  String id,
  String label,
  String removeLabel,
  VoidCallback onRemove,
});

class WantSearchToolbar extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;
  final List<Widget> actions;
  final List<WantSearchFilter> filters;
  const WantSearchToolbar({
    super.key,
    required this.controller,
    required this.label,
    required this.onChanged,
    this.actions = const [],
    this.filters = const [],
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, bounds) {
      final input = WantInput(
        controller: controller,
        label: Text(label),
        onChanged: onChanged,
      );
      final buttons = Wrap(spacing: 8, runSpacing: 8, children: actions);
      final sideBySide =
          bounds.maxWidth >= 640 &&
          MediaQuery.textScalerOf(context).scale(16) <= 24;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          if (sideBySide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 8,
              children: [
                Expanded(child: input),
                Flexible(child: buttons),
              ],
            )
          else ...[
            input,
            buttons,
          ],
          if (filters.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final filter in filters)
                  WantButton(
                    key: ValueKey(filter.id),
                    semanticsLabel: filter.removeLabel,
                    variant: WantButtonVariant.secondary,
                    onPressed: filter.onRemove,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Text(filter.label),
                        const WantIcon(WantIcons.x, size: 16),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      );
    },
  );
}
