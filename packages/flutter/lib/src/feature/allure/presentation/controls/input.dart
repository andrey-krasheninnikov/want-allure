import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:flutter/services.dart';

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
    super.maxLines = null,
    super.textDirection,
  }) : super(keyboardType: TextInputType.multiline);
}
