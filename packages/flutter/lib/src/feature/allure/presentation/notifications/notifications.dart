import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:toastification/toastification.dart';

enum WantSnackbarVariant { error, warning, info, success }

typedef WantToastHandle = FToasterEntry;
const _defaultDuration = Duration(milliseconds: -1);

class WantToaster extends StatelessWidget {
  final Widget child;
  const WantToaster({super.key, required this.child});
  @override
  Widget build(BuildContext context) => _WantToasterHost(child: child);
}

class _WantToasterHost extends StatefulWidget {
  final Widget child;
  const _WantToasterHost({required this.child});
  @override
  State<_WantToasterHost> createState() => _WantToasterState();
}

class _WantToasterState extends State<_WantToasterHost> {
  final Toastification _toasts = Toastification();
  final _handles = <_ToastHandle>{};

  @override
  void dispose() {
    for (final handle in _handles.toList()) {
      handle._remove();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ToastificationConfigProvider(
    config: const ToastificationConfig(
      itemWidth: 400,
      maxToastLimit: 5,
      marginBuilder: _toastMargin,
    ),
    child: _ToasterScope(state: this, child: widget.child),
  );
}

EdgeInsetsGeometry _toastMargin(
  BuildContext context,
  AlignmentGeometry alignment,
) => const EdgeInsets.all(16);

class _ToasterScope extends InheritedWidget {
  final _WantToasterState state;
  const _ToasterScope({required this.state, required super.child});
  @override
  bool updateShouldNotify(_ToasterScope oldWidget) => state != oldWidget.state;
}

class _ToastHandle with FToasterEntry {
  final _WantToasterState owner;
  ToastificationItem? item;
  VoidCallback? animateClose;
  bool _showing = true, _removed = false;
  _ToastHandle(this.owner);
  @override
  bool get showing => _showing && !_removed;
  @override
  void dismiss() {
    if (!showing) return;
    _showing = false;
    if (animateClose case final close?) {
      close();
    }
  }

  void _remove() {
    if (_removed) return;
    _removed = true;
    _showing = false;
    owner._handles.remove(this);
    if (item case final toast?) {
      owner._toasts.dismiss(toast, showRemoveAnimation: false);
    }
  }

  void _attach(VoidCallback close) {
    animateClose = close;
    if (!_showing) WidgetsBinding.instance.addPostFrameCallback((_) => close());
  }
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
      WantSnackbarVariant.error => WantIcons.error,
      WantSnackbarVariant.warning => WantIcons.warning,
      WantSnackbarVariant.info => WantIcons.information,
      WantSnackbarVariant.success => WantIcons.success,
      null => null,
    };
    final action = actionLabel == null
        ? null
        : WantButton(
            variant: WantButtonVariant.ghost,
            onPressed: onAction,
            child: Text(actionLabel!),
          );
    return Semantics(
      container: true,
      liveRegion: true,
      label: variantLabel,
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 8, 6, 8),
        decoration: BoxDecoration(
          color: theme.color('popover'),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.color('surface-highlight')),
          boxShadow: [
            BoxShadow(
              color: theme.color('surface-shadow'),
              blurRadius: WantTokens.material['overlayBlurPx']!,
              offset: Offset(0, WantTokens.material['overlayOffsetYPx']!),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 380;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    if (icon != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: WantMotionBuilder(
                          duration: const Duration(milliseconds: 420),
                          repeat: false,
                          builder: (context, t) => Transform.scale(
                            scale: WantTheme.reducedMotionOf(context)
                                ? 1
                                : .75 + .25 * Curves.easeOutBack.transform(t),
                            child: Opacity(
                              opacity: WantTheme.reducedMotionOf(context)
                                  ? 1
                                  : Curves.easeOut.transform(t),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: theme.color(variant!.name),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: WantIcon(
                                    icon,
                                    size: 18,
                                    color: theme.color(
                                      '${variant!.name}-foreground',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: DefaultTextStyle.merge(
                          style: TextStyle(
                            color: theme.color('popover-foreground'),
                            fontSize: 16,
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
                                    fontSize: 14,
                                    height: 1.55,
                                  ),
                                  child: description!,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!compact && action != null) action,
                    WantButton(
                      size: WantButtonSize.icon,
                      semanticsLabel: closeLabel,
                      variant: WantButtonVariant.ghost,
                      onPressed: onClose,
                      child: WantIcon(
                        WantIcons.x,
                        size: 16,
                        color: theme.color('muted-foreground'),
                      ),
                    ),
                  ],
                ),
                if (compact && action != null)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: icon == null ? 0 : 42,
                      ),
                      child: action,
                    ),
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

WantToastHandle _showToast({
  required BuildContext context,
  required Duration? duration,
  required Widget Function(VoidCallback dismiss) builder,
}) {
  if (duration != null && duration.isNegative) {
    throw ArgumentError.value(duration, 'duration');
  }
  final owner = context
      .dependOnInheritedWidgetOfExactType<_ToasterScope>()
      ?.state;
  if (owner == null) {
    throw FlutterError('Notifications require a WantToaster ancestor.');
  }
  final overlay = Navigator.of(context).overlay!;
  final handle = _ToastHandle(owner);
  owner._handles.add(handle);
  final themes = InheritedTheme.capture(from: context, to: overlay.context);
  handle.item = owner._toasts.showCustom(
    context: context,
    overlayState: overlay,
    alignment: AlignmentDirectional.topEnd,
    autoCloseDuration: null,
    animationDuration: Duration.zero,
    animationBuilder: (context, animation, alignment, child) => child,
    builder: (context, item) => themes.wrap(
      ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: (MediaQuery.sizeOf(context).width - 32).clamp(0, 400),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _ToastTransition(
            handle: handle,
            child: _TimedToast(
              duration: duration,
              onDismiss: handle.dismiss,
              child: _SwipeToast(
                handle: handle,
                child: builder(handle.dismiss),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  // Reconcile this batch after its deferred manager admission.
  final handles = owner._handles.toList();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    for (final entry in handles) {
      final item = entry.item;
      if (item != null &&
          owner._toasts.findToastificationItem(item.id) == null) {
        entry._remove();
      }
    }
  });
  WidgetsBinding.instance.scheduleFrame();
  return handle;
}

class _SwipeToast extends StatelessWidget {
  final _ToastHandle handle;
  final Widget child;
  const _SwipeToast({required this.handle, required this.child});
  @override
  Widget build(BuildContext context) {
    Widget swipe(Axis axis, DismissDirection direction, Widget child) =>
        Dismissible(
          key: ValueKey((handle, axis)),
          direction: direction,
          movementDuration: WantTheme.reducedMotionOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 180),
          resizeDuration: null,
          onDismissed: (_) => handle._remove(),
          child: child,
        );
    return swipe(
      Axis.horizontal,
      DismissDirection.startToEnd,
      swipe(Axis.vertical, DismissDirection.up, child),
    );
  }
}

class _ToastTransition extends StatefulWidget {
  final _ToastHandle handle;
  final Widget child;
  const _ToastTransition({required this.handle, required this.child});
  @override
  State<_ToastTransition> createState() => _ToastTransitionState();
}

class _ToastTransitionState extends State<_ToastTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 360),
    reverseDuration: const Duration(milliseconds: 180),
  );
  @override
  void initState() {
    super.initState();
    widget.handle._attach(_close);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (WantTheme.reducedMotionOf(context)) {
      _motion.value = 1;
    } else if (!_motion.isAnimating &&
        _motion.value == 0 &&
        widget.handle.showing) {
      _motion.forward();
    }
  }

  Future<void> _close() async {
    if (!mounted || widget.handle._removed) return;
    if (!WantTheme.reducedMotionOf(context)) {
      try {
        await _motion.reverse().orCancel;
      } on TickerCanceled {
        // Replacing the view must not cancel removal of its overlay entry.
      }
    }
    widget.handle._remove();
  }

  @override
  void dispose() {
    // List reordering can replace this view while its toast still exists.
    if (widget.handle.animateClose == _close) {
      widget.handle.animateClose = null;
    }
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _motion,
    child: widget.child,
    builder: (context, child) {
      final t = const Cubic(.16, 1, .3, 1).transform(_motion.value);
      return Opacity(
        opacity: _motion.value,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * -14),
          child: Transform.scale(
            scale: .97 + .03 * t,
            alignment: Alignment.topCenter,
            child: child,
          ),
        ),
      );
    },
  );
}

WantToastHandle showWantToast({
  required BuildContext context,
  required Widget title,
  required String closeLabel,
  Widget? description,
  String? actionLabel,
  VoidCallback? onAction,
  Duration? duration = const Duration(seconds: 5),
}) => _showToast(
  context: context,
  duration: duration,
  builder: (dismiss) => WantToast(
    title: title,
    description: description,
    closeLabel: closeLabel,
    onClose: dismiss,
    actionLabel: actionLabel,
    onAction: onAction,
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
  return _showToast(
    context: context,
    duration: resolved,
    builder: (dismiss) => WantSnackbar(
      variant: variant,
      variantLabel: variantLabel,
      title: title,
      description: description,
      closeLabel: closeLabel,
      onClose: dismiss,
      actionLabel: actionLabel,
      onAction: onAction,
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
  bool _hovered = false, _pressed = false, _focused = false, _active = true;
  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _active =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
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
        _pressed ||
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
  Widget build(BuildContext context) => Listener(
    onPointerDown: (_) {
      _pressed = true;
      _sync();
    },
    onPointerUp: (_) {
      _pressed = false;
      _sync();
    },
    onPointerCancel: (_) {
      _pressed = false;
      _sync();
    },
    child: MouseRegion(
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
    ),
  );
}
