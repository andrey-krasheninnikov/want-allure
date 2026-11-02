import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import '../foundation/theme.dart';
import '../effects/motion.dart';
import 'controls.dart';

enum WantSnackbarVariant { error, warning, info, success }

typedef WantToastHandle = FToasterEntry;
const _defaultDuration = Duration(milliseconds: -1);

class WantToaster extends StatelessWidget {
  final Widget child;
  const WantToaster({super.key, required this.child});
  @override
  Widget build(BuildContext context) => FToaster(child: child);
}

class WantToast extends StatelessWidget {
  final Widget title;
  final Widget? description;
  final String closeLabel;
  final VoidCallback onClose;
  final String? actionLabel;
  final VoidCallback? onAction;
  final WantSnackbarVariant? variant;
  final String? variantLabel;
  const WantToast({
    super.key,
    required this.title,
    required this.closeLabel,
    required this.onClose,
    this.description,
    this.actionLabel,
    this.onAction,
    this.variant,
    this.variantLabel,
  }) : assert((actionLabel == null) == (onAction == null));
  @override
  Widget build(BuildContext context) {
    final theme = WantTheme.of(context);
    final icon = switch (variant) {
      WantSnackbarVariant.error => FLucideIcons.circleX,
      WantSnackbarVariant.warning => FLucideIcons.triangleAlert,
      WantSnackbarVariant.info => FLucideIcons.info,
      WantSnackbarVariant.success => FLucideIcons.circleCheck,
      null => null,
    };
    final action = actionLabel == null
        ? null
        : WantButton(
            variant: WantButtonVariant.secondary,
            onPressed: onAction,
            child: Text(actionLabel!),
          );
    return Semantics(
      container: true,
      liveRegion: true,
      label: variantLabel,
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 6, 10),
        decoration: BoxDecoration(
          color: theme.color('popover'),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: theme.color('foreground').withValues(alpha: .12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 400;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    if (icon != null)
                      WantMotionBuilder(
                        duration: const Duration(milliseconds: 420),
                        repeat: false,
                        builder: (context, t) => Transform.scale(
                          scale: WantTheme.reducedMotionOf(context)
                              ? 1
                              : .75 + .25 * Curves.easeOutBack.transform(t),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: theme.color(variant!.name),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              icon,
                              size: 18,
                              color: theme.color('${variant!.name}-foreground'),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: DefaultTextStyle.merge(
                        style: TextStyle(
                          color: theme.color('popover-foreground'),
                          fontSize: 14,
                          height: 1.4,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 4,
                          children: [
                            DefaultTextStyle.merge(
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              child: title,
                            ),
                            if (description != null)
                              DefaultTextStyle.merge(
                                style: TextStyle(
                                  color: theme.color('muted-foreground'),
                                ),
                                child: description!,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (!compact && action != null) action,
                    WantButton(
                      size: WantButtonSize.icon,
                      semanticsLabel: closeLabel,
                      variant: WantButtonVariant.secondary,
                      onPressed: onClose,
                      child: const Icon(FLucideIcons.x, size: 18),
                    ),
                  ],
                ),
                if (compact && action != null)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: action,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class WantSnackbar extends WantToast {
  const WantSnackbar({
    super.key,
    required WantSnackbarVariant variant,
    required String variantLabel,
    required super.title,
    required super.closeLabel,
    required super.onClose,
    super.description,
    super.actionLabel,
    super.onAction,
  }) : super(variant: variant, variantLabel: variantLabel);
}

FToastStyle _toastStyle(BuildContext context) =>
    WantTheme.of(context).forui.toasterStyle.toastStyles
        .resolve({FToastVariant.primary})
        .copyWith(
          constraints: BoxConstraints(
            maxWidth: (MediaQuery.sizeOf(context).width - 32).clamp(0, 440),
          ),
          motion: const FToastMotion(
            entranceDuration: Duration(milliseconds: 360),
            entranceCurve: Cubic(.16, 1, .3, 1),
            dismissDuration: Duration(milliseconds: 180),
            exitDuration: Duration(milliseconds: 180),
          ),
        );

WantToastHandle showWantToast({
  required BuildContext context,
  required Widget title,
  required String closeLabel,
  Widget? description,
  String? actionLabel,
  VoidCallback? onAction,
  Duration? duration = const Duration(seconds: 5),
}) => showRawFToast(
  context: context,
  duration: null,
  style: _toastStyle(context),
  builder: (context, entry) => _TimedToast(
    duration: duration,
    onDismiss: entry.dismiss,
    child: WantToast(
      title: title,
      description: description,
      closeLabel: closeLabel,
      onClose: entry.dismiss,
      actionLabel: actionLabel,
      onAction: onAction,
    ),
  ),
);

WantToastHandle showWantSnackbar({
  required BuildContext context,
  required WantSnackbarVariant variant,
  required String variantLabel,
  required Widget title,
  required String closeLabel,
  Widget? description,
  String? actionLabel,
  VoidCallback? onAction,
  Duration? duration = _defaultDuration,
}) {
  final resolved = duration == _defaultDuration
      ? (variant == WantSnackbarVariant.error
            ? null
            : const Duration(seconds: 5))
      : duration;
  if (resolved != null && resolved.isNegative) {
    throw ArgumentError.value(duration, 'duration');
  }
  return showRawFToast(
    context: context,
    duration: null,
    style: _toastStyle(context),
    builder: (context, entry) => _TimedToast(
      duration: resolved,
      onDismiss: entry.dismiss,
      child: WantSnackbar(
        variant: variant,
        variantLabel: variantLabel,
        title: title,
        description: description,
        closeLabel: closeLabel,
        onClose: entry.dismiss,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    ),
  );
}

class _TimedToast extends StatefulWidget {
  final Duration? duration;
  final VoidCallback onDismiss;
  final Widget child;
  const _TimedToast({
    required this.duration,
    required this.onDismiss,
    required this.child,
  });
  @override
  State<_TimedToast> createState() => _TimedToastState();
}

class _TimedToastState extends State<_TimedToast> with WidgetsBindingObserver {
  Timer? _timer;
  Duration? _remaining;
  final _watch = Stopwatch();
  bool _hovered = false, _focused = false, _active = true;
  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    WidgetsBinding.instance.addObserver(this);
  }

  void _pause() {
    _timer?.cancel();
    _timer = null;
    if (_watch.isRunning) {
      _watch.stop();
      _remaining = _remaining! - _watch.elapsed;
      _watch.reset();
    }
  }

  void _sync() {
    final paused =
        _hovered ||
        _focused ||
        !_active ||
        !TickerMode.valuesOf(context).enabled ||
        MediaQuery.accessibleNavigationOf(context);
    if (paused || _remaining == null) {
      _pause();
      return;
    }
    if (_timer == null) {
      _watch.start();
      _timer = Timer(
        _remaining!.isNegative ? Duration.zero : _remaining!,
        widget.onDismiss,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _active = state == AppLifecycleState.resumed;
    if (mounted) _sync();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _watch.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) {
      _hovered = true;
      _sync();
    },
    onExit: (_) {
      _hovered = false;
      _sync();
    },
    child: Focus(
      onFocusChange: (value) {
        _focused = value;
        _sync();
      },
      child: widget.child,
    ),
  );
}
