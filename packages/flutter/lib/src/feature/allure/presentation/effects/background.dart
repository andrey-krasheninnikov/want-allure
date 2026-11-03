import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class WantBackgroundController extends ChangeNotifier {
  bool _paused;
  int _wave = 0;
  WantBackgroundController({this._paused = false});
  bool get paused => _paused;
  void pause() {
    if (!_paused) {
      _paused = true;
      notifyListeners();
    }
  }

  void resume() {
    if (_paused) {
      _paused = false;
      notifyListeners();
    }
  }

  void toggle() => _paused ? resume() : pause();
  void triggerWave() {
    if (!_paused) {
      _wave++;
      notifyListeners();
    }
  }
}

class WantBackgroundMotion extends StatefulWidget {
  final WantBackgroundController controller;
  final Widget child;
  final String pauseLabel, resumeLabel;
  final Duration minimumWaveDelay, maximumWaveDelay;
  const WantBackgroundMotion({
    super.key,
    required this.controller,
    required this.child,
    required this.pauseLabel,
    required this.resumeLabel,
    this.minimumWaveDelay = const Duration(seconds: 8),
    this.maximumWaveDelay = const Duration(seconds: 18),
  });
  @override
  State<WantBackgroundMotion> createState() => _WantBackgroundMotionState();
}

class _WantBackgroundMotionState extends State<WantBackgroundMotion>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _wave;
  Timer? _timer;
  bool _active = true, _running = false;
  int _request = 0;
  final _random = math.Random();
  void _validate() {
    if (widget.minimumWaveDelay.isNegative ||
        widget.maximumWaveDelay < widget.minimumWaveDelay ||
        widget.maximumWaveDelay.inMilliseconds > 2147483647) {
      throw ArgumentError(
        'Wave delays must be ordered and within 0–2147483647 ms.',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _validate();
    _active =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    _wave =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) _schedule();
          });
    _request = widget.controller._wave;
    widget.controller.addListener(_controlChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  void _schedule() {
    _timer?.cancel();
    _timer = null;
    if (!_running) return;
    final min = widget.minimumWaveDelay.inMilliseconds,
        range =
            widget.maximumWaveDelay.inMilliseconds -
            widget.minimumWaveDelay.inMilliseconds;
    _timer = Timer(
      Duration(milliseconds: min + (_random.nextDouble() * range).round()),
      () {
        if (_running && mounted) _wave.forward(from: 0);
      },
    );
  }

  void _sync() {
    final running =
        _active &&
        !widget.controller.paused &&
        TickerMode.valuesOf(context).enabled &&
        !WantTheme.reducedMotionOf(context) &&
        !MediaQuery.highContrastOf(context);
    final changed = running != _running;
    _running = running;
    if (!running) {
      _timer?.cancel();
      _timer = null;
      _wave.stop(canceled: false);
    } else if (changed || _timer == null && !_wave.isAnimating) {
      if (_wave.value > 0 && _wave.value < 1) {
        _wave.forward();
      } else {
        _schedule();
      }
    }
  }

  void _controlChanged() {
    if (!mounted) return;
    _sync();
    if (_request != widget.controller._wave) {
      _request = widget.controller._wave;
      if (_running) {
        _timer?.cancel();
        _timer = null;
        _wave.forward(from: 0);
      }
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(WantBackgroundMotion old) {
    super.didUpdateWidget(old);
    _validate();
    if (old.controller != widget.controller) {
      old.controller.removeListener(_controlChanged);
      widget.controller.addListener(_controlChanged);
      _request = widget.controller._wave;
    }
    if (old.minimumWaveDelay != widget.minimumWaveDelay ||
        old.maximumWaveDelay != widget.maximumWaveDelay) {
      _timer?.cancel();
      _timer = null;
    }
    _sync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _active = state == AppLifecycleState.resumed;
    if (mounted) setState(_sync);
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.controller.removeListener(_controlChanged);
    WidgetsBinding.instance.removeObserver(this);
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final height = constraints.maxHeight.isFinite
          ? constraints.maxHeight
          : MediaQuery.sizeOf(context).height;
      final available =
          !WantTheme.reducedMotionOf(context) &&
          !MediaQuery.highContrastOf(context);
      return Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          if (!MediaQuery.highContrastOf(context))
            Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child: WantShaderSurface(
                    asset: 'sphere.frag',
                    fallback: CustomPaint(
                      painter: _BackgroundPainter(
                        0,
                        0,
                        WantTheme.of(context).color('primary'),
                      ),
                    ),
                    builder: (context, shader) => WantMotionBuilder(
                      duration: Duration(
                        milliseconds: math.max(
                          28000,
                          (height / 30 * 1000).round(),
                        ),
                      ),
                      paused: !_running,
                      builder: (context, phase) => AnimatedBuilder(
                        animation: _wave,
                        builder: (context, _) => CustomPaint(
                          painter: _BackgroundPainter(
                            phase,
                            _wave.value,
                            WantTheme.of(context).color('primary'),
                            shader: shader,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          widget.child,
          if (available)
            PositionedDirectional(
              end: 16,
              bottom: 16,
              child: WantButton(
                variant: WantButtonVariant.secondary,
                onPressed: widget.controller.toggle,
                child: Text(
                  widget.controller.paused
                      ? widget.resumeLabel
                      : widget.pauseLabel,
                ),
              ),
            ),
        ],
      );
    },
  );
}

class _BackgroundPainter extends CustomPainter {
  final double phase, wave;
  final Color color;
  final ui.FragmentShader? shader;
  _BackgroundPainter(this.phase, this.wave, this.color, {this.shader});
  @override
  void paint(Canvas canvas, Size size) {
    if (shader case final shader?) {
      final values = [
        size.width,
        size.height,
        phase,
        wave,
        color.r,
        color.g,
        color.b,
        color.a,
        1.0,
        1.0,
        1.0,
        1.0,
      ];
      for (var i = 0; i < values.length; i++) {
        shader.setFloat(i, values[i]);
      }
      canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
      return;
    }
    final center = Offset(
      size.width * (.5 + .25 * math.sin(phase * math.pi * 2)),
      size.height * (.5 + .4 * math.cos(phase * math.pi * 2)),
    );
    final radius = math.min(size.width, size.height) * .65;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color.withValues(alpha: .24), color.withValues(alpha: 0)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
    if (wave > 0 && wave < 1) {
      final r = size.longestSide * wave;
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..color = color.withValues(alpha: math.sin(wave * math.pi) * .24)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 40
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
      );
    }
  }

  @override
  bool shouldRepaint(_BackgroundPainter old) =>
      phase != old.phase ||
      wave != old.wave ||
      color != old.color ||
      shader != old.shader;
}
