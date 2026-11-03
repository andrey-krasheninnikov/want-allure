import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';
import 'package:flutter/widgets.dart';

class WantMotionBuilder extends StatefulWidget {
  final Duration duration;
  final bool paused, repeat, autoplay;
  final Object? restartKey;
  final Widget Function(BuildContext context, double value) builder;
  const WantMotionBuilder({
    super.key,
    required this.duration,
    required this.builder,
    this.paused = false,
    this.repeat = true,
    this.autoplay = true,
    this.restartKey,
  });
  @override
  State<WantMotionBuilder> createState() => _WantMotionBuilderState();
}

class _WantMotionBuilderState extends State<WantMotionBuilder>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller;
  bool _active = true, _started = false;
  @override
  void initState() {
    super.initState();
    _active =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    WidgetsBinding.instance.addObserver(this);
  }

  bool get _allowed =>
      _active &&
      !widget.paused &&
      TickerMode.valuesOf(context).enabled &&
      !WantTheme.reducedMotionOf(context);
  void _sync() {
    if (!_allowed) {
      _controller.stop(canceled: false);
      return;
    }
    if (widget.repeat) {
      if (!_controller.isAnimating) _controller.repeat();
    } else if ((_started || widget.autoplay) && _controller.value < 1) {
      _started = true;
      _controller.forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(WantMotionBuilder old) {
    super.didUpdateWidget(old);
    final durationChanged = old.duration != widget.duration;
    _controller.duration = widget.duration;
    if (durationChanged &&
        widget.repeat &&
        _controller.isAnimating &&
        _allowed) {
      _controller.repeat(period: widget.duration);
    }
    if (old.restartKey != widget.restartKey) {
      _controller.value = 0;
      _started = true;
    }
    _sync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _active = state == AppLifecycleState.resumed;
    if (mounted) _sync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => widget.builder(context, _controller.value),
    ),
  );
}
