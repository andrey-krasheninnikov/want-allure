import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:material_ui/material_ui.dart'
    show CheckboxListTile, ListTileControlAffinity;

import '../foundation/theme.dart';

enum WantButtonVariant { primary, secondary, outline, ghost, link, destructive }

enum WantButtonSize {
  extraSmall,
  small,
  medium,
  large,
  iconExtraSmall,
  iconSmall,
  icon,
  iconLarge,
}

class WantButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final WantButtonVariant variant;
  final WantButtonSize size;
  final String? semanticsLabel;
  final FocusNode? focusNode;
  final bool autofocus, pill;
  const WantButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.variant = WantButtonVariant.primary,
    this.size = WantButtonSize.medium,
    this.semanticsLabel,
    this.focusNode,
    this.autofocus = false,
    this.pill = true,
  });
  @override
  Widget build(BuildContext context) {
    final theme = WantTheme.of(context);
    final mapped = switch (variant) {
      WantButtonVariant.primary => FButtonVariant.primary,
      WantButtonVariant.destructive => FButtonVariant.destructive,
      _ => FButtonVariant.secondary,
    };
    final role = switch (variant) {
      WantButtonVariant.primary => 'primary',
      WantButtonVariant.destructive => 'destructive',
      _ => 'secondary',
    };
    final base =
        variant == WantButtonVariant.ghost || variant == WantButtonVariant.link
        ? const Color(0x00000000)
        : theme.color(role);
    final foreground = theme.color(
      variant == WantButtonVariant.link ? 'link' : '$role-foreground',
    );
    final iconOnly = size.name.startsWith('icon');
    final style = theme.forui.buttonStyles.resolve({mapped}).resolve({
      FButtonSizeVariant.md,
    });
    final decoration = BoxDecoration(
      color: base,
      borderRadius: BorderRadius.circular(pill ? 100 : 12),
    );
    final buttonStyle = style.copyWith(
      decoration: FVariants.from(
        decoration,
        variants: {
          [
            FTappableVariant.hovered,
            FTappableVariant.pressed,
          ]: DecorationDelta.boxDelta(
            color: variant == WantButtonVariant.primary
                ? theme.color('primary-hover')
                : theme.color('accent'),
          ),
          [FTappableVariant.disabled]: DecorationDelta.boxDelta(
            color: base.withValues(alpha: .5),
          ),
        },
      ),
    );
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 44,
        minHeight:
            size == WantButtonSize.large || size == WantButtonSize.iconLarge
            ? 48
            : 44,
      ),
      child: FButton.raw(
        variant: mapped,
        style: buttonStyle,
        onPress: onPressed,
        focusNode: focusNode,
        autofocus: autofocus,
        semanticsLabel: semanticsLabel,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: iconOnly
                ? 10
                : switch (size) {
                    WantButtonSize.extraSmall => 8,
                    WantButtonSize.small => 12,
                    WantButtonSize.large => 24,
                    _ => 16,
                  },
            vertical: 10,
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: onPressed == null
                  ? foreground.withValues(alpha: .5)
                  : foreground,
            ),
            child: IconTheme(
              data: IconThemeData(
                size: size == WantButtonSize.iconExtraSmall ? 12 : 20,
                color: onPressed == null
                    ? foreground.withValues(alpha: .5)
                    : foreground,
              ),
              child: Center(widthFactor: 1, heightFactor: 1, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class WantInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue, hint;
  final Widget? label, description, error;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool enabled, obscureText, readOnly, autofocus;
  final int? minLines, maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;
  const WantInput({
    super.key,
    this.controller,
    this.initialValue,
    this.hint,
    this.label,
    this.description,
    this.error,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.minLines,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.textDirection,
  });
  @override
  Widget build(BuildContext context) => FTextField(
    control: FTextFieldControl.managed(
      controller: controller,
      initial: controller == null && initialValue != null
          ? TextEditingValue(text: initialValue!)
          : null,
      onChange: onChanged == null ? null : (value) => onChanged!(value.text),
    ),
    hint: hint,
    label: label,
    description: description,
    error: error,
    focusNode: focusNode,
    enabled: enabled,
    obscureText: obscureText,
    readOnly: readOnly,
    autofocus: autofocus,
    minLines: minLines,
    maxLines: maxLines,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    inputFormatters: inputFormatters,
    onSubmit: onSubmitted,
    textDirection: textDirection,
  );
}

class WantTextarea extends WantInput {
  const WantTextarea({
    super.key,
    super.controller,
    super.initialValue,
    super.hint,
    super.label,
    super.description,
    super.error,
    super.onChanged,
    super.focusNode,
    super.enabled,
    super.readOnly,
    super.autofocus,
    super.minLines = 4,
    super.maxLines,
    super.textDirection,
  }) : super(keyboardType: TextInputType.multiline);
}

class WantLabel extends StatelessWidget {
  final Widget child;
  final FocusNode? focusNode;
  const WantLabel({super.key, required this.child, this.focusNode});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: focusNode?.requestFocus,
    child: DefaultTextStyle.merge(
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      child: child,
    ),
  );
}

class WantField extends StatelessWidget {
  final Widget child;
  final Widget? label, description, error;
  final FocusNode? focusNode;
  const WantField({
    super.key,
    required this.child,
    this.label,
    this.description,
    this.error,
    this.focusNode,
  });
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    spacing: 8,
    children: [
      if (label != null) WantLabel(focusNode: focusNode, child: label!),
      child,
      if (error != null || description != null)
        Semantics(
          liveRegion: error != null,
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: 14,
              color: WantTheme.of(context)
                  .color(error == null ? 'muted-foreground' : 'error-text'),
            ),
            child: error ?? description!,
          ),
        ),
    ],
  );
}

class WantFieldGroup extends StatelessWidget {
  final List<Widget> children;
  final Widget? legend;
  const WantFieldGroup({super.key, required this.children, this.legend});
  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [?legend, ...children],
    ),
  );
}

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
            title: label,
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
            label: label,
            description: description,
            error: error,
            focusNode: focusNode,
          ),
  );
}

class WantSwitch extends StatelessWidget {
  final bool value, enabled;
  final ValueChanged<bool>? onChanged;
  final Widget? label, description;
  final FocusNode? focusNode;
  const WantSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.label,
    this.description,
    this.focusNode,
  });
  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
    child: FSwitch(
      value: value,
      onChange: onChanged,
      enabled: enabled && onChanged != null,
      label: label,
      description: description,
      focusNode: focusNode,
    ),
  );
}

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
                  label: Text(widget.options[index].label),
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
          title: Text(option.label),
          value: option.value,
          enabled: !option.disabled,
        ),
    ],
  );
}
