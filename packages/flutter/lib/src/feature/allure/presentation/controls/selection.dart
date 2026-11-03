import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:flutter/services.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

@immutable
class WantOption<T> {
  final T value;
  final String label;
  final bool disabled;
  const WantOption({
    required this.value,
    required this.label,
    this.disabled = false,
  });
}

class WantRadioGroup<T> extends StatefulWidget {
  final T? value;
  final List<WantOption<T>> options;
  final ValueChanged<T>? onChanged;
  final String semanticsLabel;
  const WantRadioGroup({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.semanticsLabel,
  });
  @override
  State<WantRadioGroup<T>> createState() => _WantRadioGroupState<T>();
}

class _WantRadioGroupState<T> extends State<WantRadioGroup<T>> {
  final _nodes = <FocusNode>[];
  void _resize() {
    while (_nodes.length > widget.options.length) {
      _nodes.removeLast().dispose();
    }
    while (_nodes.length < widget.options.length) {
      _nodes.add(FocusNode());
    }
  }

  @override
  void initState() {
    super.initState();
    _resize();
  }

  @override
  void didUpdateWidget(covariant WantRadioGroup<T> old) {
    super.didUpdateWidget(old);
    _resize();
  }

  @override
  void dispose() {
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  KeyEventResult _key(int index, KeyEvent event) {
    if (widget.onChanged == null ||
        event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    var delta = key == LogicalKeyboardKey.arrowDown
        ? 1
        : key == LogicalKeyboardKey.arrowUp
        ? -1
        : 0;
    if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowRight) {
      delta =
          (key == LogicalKeyboardKey.arrowRight ? 1 : -1) *
          (Directionality.of(context) == TextDirection.rtl ? -1 : 1);
    }
    if (delta == 0) return KeyEventResult.ignored;
    for (var step = 1; step <= widget.options.length; step++) {
      final next = (index + delta * step) % widget.options.length;
      if (!widget.options[next].disabled) {
        _nodes[next].requestFocus();
        widget.onChanged!(widget.options[next].value);
        break;
      }
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.options.indexWhere(
      (option) => option.value == widget.value && !option.disabled,
    );
    final tabIndex = selected < 0
        ? widget.options.indexWhere((option) => !option.disabled)
        : selected;
    for (var index = 0; index < _nodes.length; index++) {
      _nodes[index].skipTraversal = index != tabIndex;
    }
    return Semantics(
      label: widget.semanticsLabel,
      container: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < widget.options.length; index++)
            Focus(
              canRequestFocus: false,
              skipTraversal: true,
              onKeyEvent: (_, event) => _key(index, event),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: FRadio(
                  // Recreate ForUI's zero-duration AnimatedSize when selection changes.
                  key: WantTheme.reducedMotionOf(context)
                      ? ValueKey(widget.options[index].value == widget.value)
                      : null,
                  focusNode: _nodes[index],
                  label: WantSelectable(
                    enabled:
                        !widget.options[index].disabled &&
                        widget.onChanged != null,
                    child: Text(widget.options[index].label),
                  ),
                  value: widget.options[index].value == widget.value,
                  enabled:
                      !widget.options[index].disabled &&
                      widget.onChanged != null,
                  onChange: (selected) {
                    if (selected) {
                      widget.onChanged?.call(widget.options[index].value);
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class WantSelect<T> extends StatelessWidget {
  final T? value;
  final List<WantOption<T>> options;
  final ValueChanged<T?>? onChanged;
  final Widget? label;
  final String? hint;
  final bool enabled;
  const WantSelect({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.label,
    this.hint,
    this.enabled = true,
  });
  @override
  Widget build(BuildContext context) => FSelect<T>.rich(
    format: (value) =>
        options.where((item) => item.value == value).firstOrNull?.label ?? '',
    control: FSelectControl.lifted(
      value: value,
      onChange: (value) => onChanged?.call(value),
    ),
    label: label,
    hint: hint,
    enabled: enabled && onChanged != null,
    children: [
      for (final option in options)
        FSelectItem<T>(
          title: WantSelectable(
            enabled: !option.disabled,
            child: Text(option.label),
          ),
          value: option.value,
          enabled: !option.disabled,
        ),
    ],
  );
}
