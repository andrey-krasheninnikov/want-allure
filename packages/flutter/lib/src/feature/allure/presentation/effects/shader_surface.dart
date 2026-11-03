import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// Loads package shaders once; each surface owns its mutable shader instance.
class WantShaderSurface extends StatefulWidget {
  final String asset;
  final Widget fallback;
  final Widget Function(BuildContext context, ui.FragmentShader shader) builder;
  const WantShaderSurface({
    super.key,
    required this.asset,
    required this.fallback,
    required this.builder,
  });
  @override
  State<WantShaderSurface> createState() => _WantShaderSurfaceState();
}

class _WantShaderSurfaceState extends State<WantShaderSurface> {
  static final _programs = <String, Future<ui.FragmentProgram>>{};
  ui.FragmentShader? _shader;
  int _request = 0;

  Future<void> _load() async {
    final request = ++_request;
    final asset = 'packages/want_allure/shaders/${widget.asset}';
    try {
      final program = await _programs.putIfAbsent(
        asset,
        () => ui.FragmentProgram.fromAsset(asset),
      );
      if (!mounted || request != _request) return;
      setState(() => _shader = program.fragmentShader());
    } catch (_) {
      _programs.remove(asset);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(WantShaderSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset) {
      _shader?.dispose();
      _shader = null;
      _load();
    }
  }

  @override
  void dispose() {
    _request++;
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: _shader == null
        ? widget.fallback
        : widget.builder(context, _shader!),
  );
}
