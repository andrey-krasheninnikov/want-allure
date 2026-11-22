import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantIconButton extends StatelessWidget {
  final String label;
  final Widget child;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final bool autofocus;
  const WantIconButton({
    super.key,
    required this.label,
    required this.child,
    required this.onPressed,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) => WantButton(
    semanticsLabel: label,
    onPressed: onPressed,
    focusNode: focusNode,
    autofocus: autofocus,
    size: WantButtonSize.icon,
    variant: WantButtonVariant.ghost,
    pill: false,
    transparent: true,
    child: child,
  );
}

enum _CopyState { idle, pending, copied, error }

class WantCopyAction extends StatefulWidget {
  final String label, copiedLabel, errorLabel;
  final Future<void> Function() onCopy;
  final Widget? child;
  const WantCopyAction({
    super.key,
    required this.label,
    required this.copiedLabel,
    required this.errorLabel,
    required this.onCopy,
    this.child,
  });

  @override
  State<WantCopyAction> createState() => _WantCopyActionState();
}

class _WantCopyActionState extends State<WantCopyAction> {
  var _state = _CopyState.idle;
  Timer? _timer;

  Future<void> _copy() async {
    if (_state == _CopyState.pending) return;
    _timer?.cancel();
    setState(() => _state = _CopyState.pending);
    try {
      await widget.onCopy();
      if (!mounted) return;
      setState(() => _state = _CopyState.copied);
      _timer = Timer(
        const Duration(seconds: 3),
        () => setState(() => _state = _CopyState.idle),
      );
    } catch (_) {
      if (mounted) setState(() => _state = _CopyState.error);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final copied = _state == _CopyState.copied;
    final glyph = SizedBox.square(
      dimension: 24,
      child: AnimatedSwitcher(
        duration: WantTheme.reducedMotionOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 180),
        child: WantIcon(
          copied ? WantIcons.circleCheck : WantIcons.copy,
          key: ValueKey(copied),
          color: copied ? WantTheme.of(context).color('success-text') : null,
        ),
      ),
    );
    final content = widget.child;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          container: copied,
          explicitChildNodes: copied,
          liveRegion: copied,
          label: copied ? widget.copiedLabel : null,
          child: content == null
              ? WantIconButton(
                  label: widget.label,
                  onPressed: _copy,
                  child: glyph,
                )
              : WantButton(
                  variant: WantButtonVariant.ghost,
                  pill: false,
                  transparent: true,
                  semanticsLabel: widget.label,
                  onPressed: _copy,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      Flexible(child: content),
                      glyph,
                    ],
                  ),
                ),
        ),
        if (_state == _CopyState.error)
          Semantics(
            liveRegion: true,
            child: WantTypography(
              widget.errorLabel,
              colorRole: 'error-text',
              variant: WantTypographyVariant.small,
            ),
          ),
      ],
    );
  }
}
