import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

/// A single-line password field with consumer-supplied visibility labels.
///
/// Autofill and input-assistance features are disabled by default, including
/// while the password is visible. Consumers own validation and clipboard policy.
class WantPasswordInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue, hint;
  final Widget? label, description, error;
  final String showPasswordLabel, hidePasswordLabel;
  final ValueChanged<String>? onChanged, onSubmitted;
  final FocusNode? focusNode;
  final bool enabled, readOnly, autofocus;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;
  final bool autocorrect, enableSuggestions;
  final bool enableIMEPersonalizedLearning, stylusHandwritingEnabled;
  final SmartDashesType smartDashesType;
  final SmartQuotesType smartQuotesType;

  /// Null disables Flutter autofill; an empty iterable does not disable it.
  final Iterable<String>? autofillHints;
  final bool enableInteractiveSelection;
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  const WantPasswordInput({
    super.key,
    this.controller,
    this.initialValue,
    this.hint,
    this.label,
    this.description,
    this.error,
    required this.showPasswordLabel,
    required this.hidePasswordLabel,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.keyboardType = TextInputType.visiblePassword,
    this.textInputAction,
    this.inputFormatters,
    this.textDirection,
    this.autocorrect = false,
    this.enableSuggestions = false,
    this.enableIMEPersonalizedLearning = false,
    this.stylusHandwritingEnabled = false,
    this.smartDashesType = SmartDashesType.disabled,
    this.smartQuotesType = SmartQuotesType.disabled,
    this.autofillHints,
    this.enableInteractiveSelection = true,
    this.contextMenuBuilder = FTextField.defaultContextMenuBuilder,
  });

  @override
  State<WantPasswordInput> createState() => _WantPasswordInputState();
}

class _WantPasswordInputState extends State<WantPasswordInput> {
  bool _obscured = true;
  late String _lastText;

  @override
  void initState() {
    super.initState();
    _lastText = widget.controller?.text ?? widget.initialValue ?? '';
  }

  @override
  void didUpdateWidget(WantPasswordInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _lastText = widget.controller?.text ?? widget.initialValue ?? '';
    }
  }

  void _changed(TextEditingValue value) {
    if (value.text == _lastText) return;
    _lastText = value.text;
    widget.onChanged?.call(value.text);
  }

  @override
  Widget build(BuildContext context) => FTextField(
    control: FTextFieldControl.managed(
      controller: widget.controller,
      initial: widget.controller == null && widget.initialValue != null
          ? TextEditingValue(text: widget.initialValue!)
          : null,
      onChange: _changed,
    ),
    hint: widget.hint,
    label: widget.label,
    description: widget.description,
    error: widget.error,
    focusNode: widget.focusNode,
    enabled: widget.enabled,
    readOnly: widget.readOnly,
    autofocus: widget.autofocus,
    obscureText: _obscured,
    keyboardType: widget.keyboardType,
    textInputAction: widget.textInputAction,
    inputFormatters: widget.inputFormatters,
    onSubmit: widget.onSubmitted,
    textDirection: widget.textDirection,
    autocorrect: widget.autocorrect,
    enableSuggestions: widget.enableSuggestions,
    enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
    stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
    smartDashesType: widget.smartDashesType,
    smartQuotesType: widget.smartQuotesType,
    autofillHints: widget.autofillHints,
    enableInteractiveSelection: widget.enableInteractiveSelection,
    contextMenuBuilder: widget.contextMenuBuilder,
    suffixBuilder: (context, style, variants) => TextFieldTapRegion(
      child: WantButton(
        variant: WantButtonVariant.ghost,
        size: WantButtonSize.icon,
        pill: false,
        semanticsLabel: _obscured
            ? widget.showPasswordLabel
            : widget.hidePasswordLabel,
        onPressed: widget.enabled
            ? () => setState(() => _obscured = !_obscured)
            : null,
        child: WantIcon(_obscured ? WantIcons.eye : WantIcons.eyeClosed),
      ),
    ),
  );
}
