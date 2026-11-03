import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ditredi/ditredi.dart';
import 'package:dart_earcut/dart_earcut.dart';
import 'package:path_parsing/path_parsing.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:xml/xml.dart';
import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

/// Extrudes filled SVG contours into a lit mesh. Convert strokes and text to paths first.
class WantSvg3D extends StatefulWidget {
  final FutureOr<String> Function(BuildContext) svgBuilder;
  final String semanticsLabel;
  final double depth;
  final bool autoRotate, paused, glow;
  final WidgetBuilder? placeholderBuilder;
  final Widget Function(BuildContext, Object)? errorBuilder;
  WantSvg3D.asset(
    String asset, {
    super.key,
    String? package,
    required this.semanticsLabel,
    this.depth = .12,
    this.autoRotate = true,
    this.paused = false,
    this.glow = true,
    this.placeholderBuilder,
    this.errorBuilder,
  }) : svgBuilder = ((context) => DefaultAssetBundle.of(context)
           .loadString(package == null ? asset : 'packages/$package/$asset'));
  WantSvg3D.string(
    String svg, {
    super.key,
    required this.semanticsLabel,
    this.depth = .12,
    this.autoRotate = true,
    this.paused = false,
    this.glow = true,
    this.placeholderBuilder,
    this.errorBuilder,
  }) : svgBuilder = ((context) => svg);
  const WantSvg3D.builder({
    super.key,
    required this.svgBuilder,
    required this.semanticsLabel,
    this.depth = .12,
    this.autoRotate = true,
    this.paused = false,
    this.glow = true,
    this.placeholderBuilder,
    this.errorBuilder,
  });
  @override
  State<WantSvg3D> createState() => _WantSvg3DState();
}

class _WantSvg3DState extends State<WantSvg3D> {
  final _controller = DiTreDiController(
    rotationX: 8,
    rotationY: -20,
    lightStrength: .7,
    ambientLightStrength: .65,
  );
  List<Face3D>? _faces;
  Widget? _scene;
  double? _angle;
  String? _source;
  double? _depth;
  Object? _error;
  int _load = 0;
  double _manual = 0;
  bool _dragging = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _read();
  }

  @override
  void didUpdateWidget(WantSvg3D old) {
    super.didUpdateWidget(old);
    if (old.svgBuilder != widget.svgBuilder || old.depth != widget.depth) {
      _read();
    }
  }

  Future<void> _read() async {
    final load = ++_load;
    try {
      final source = await widget.svgBuilder(context);
      if (!mounted || load != _load) return;
      if (source == _source && _depth == widget.depth && _faces != null) return;
      _source = source;
      final faces = _extrude(source, widget.depth);
      setState(() {
        _faces = faces;
        _scene = ExcludeSemantics(
          child: DiTreDi(figures: faces, controller: _controller),
        );
        _angle = null;
        _source = source;
        _depth = widget.depth;
        _error = null;
      });
    } catch (error) {
      if (mounted && load == _load) {
        setState(() {
          _error = error;
          _faces = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _load++;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(context, _error!) ??
          (_source == null
              ? const SizedBox.shrink()
              : SvgPicture.string(
                  _source!,
                  semanticsLabel: widget.semanticsLabel,
                  errorBuilder: (_, error, stackTrace) =>
                      const SizedBox.shrink(),
                ));
    }
    if (_faces == null) {
      return widget.placeholderBuilder?.call(context) ??
          const SizedBox.shrink();
    }
    final reduced = WantTheme.reducedMotionOf(context);
    return Semantics(
      label: widget.semanticsLabel,
      image: true,
      child: WantViewportMotion(
        child: RepaintBoundary(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (widget.glow)
                IgnorePointer(
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: .7,
                      heightFactor: .7,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: WantTheme.of(context)
                                  .color('primary')
                                  .withValues(alpha: .25),
                              blurRadius: 70,
                              spreadRadius: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Focus(
                onKeyEvent: (node, event) {
                  if (event is! KeyDownEvent) return KeyEventResult.ignored;
                  if (event.logicalKey != LogicalKeyboardKey.arrowLeft &&
                      event.logicalKey != LogicalKeyboardKey.arrowRight) {
                    return KeyEventResult.ignored;
                  }
                  setState(
                    () => _manual +=
                        event.logicalKey == LogicalKeyboardKey.arrowLeft
                        ? -15
                        : 15,
                  );
                  return KeyEventResult.handled;
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: GestureDetector(
                    onHorizontalDragStart: (_) =>
                        setState(() => _dragging = true),
                    onHorizontalDragUpdate: (event) =>
                        setState(() => _manual += event.delta.dx * .6),
                    onHorizontalDragEnd: (_) =>
                        setState(() => _dragging = false),
                    onHorizontalDragCancel: () =>
                        setState(() => _dragging = false),
                    child: WantMotionBuilder(
                      duration: const Duration(seconds: 24),
                      paused: widget.paused || !widget.autoRotate || _dragging,
                      builder: (context, t) {
                        final phase = (t * 720).floor() / 720;
                        final angle =
                            _manual -
                            20 +
                            (reduced
                                ? 0
                                : phase * 360 +
                                      14 * math.sin(phase * math.pi * 2));
                        if (_angle != angle) {
                          _angle = angle;
                          _controller.update(rotationY: angle);
                        }
                        return _scene!;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Contours extends PathProxy {
  final contours = <List<Offset>>[];
  List<Offset>? _current;
  @override
  void moveTo(double x, double y) {
    _current = [Offset(x, y)];
    contours.add(_current!);
  }

  @override
  void lineTo(double x, double y) => _current!.add(Offset(x, y));
  @override
  void close() {}
  @override
  void cubicTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    final a = _current!.last;
    for (var i = 1; i <= 20; i++) {
      final t = i / 20, u = 1 - t;
      _current!.add(
        a * (u * u * u) +
            Offset(x1, y1) * (3 * u * u * t) +
            Offset(x2, y2) * (3 * u * t * t) +
            Offset(x3, y3) * (t * t * t),
      );
    }
  }
}

List<Face3D> _extrude(String source, double depth) {
  if (!depth.isFinite || depth <= 0 || depth > 1) {
    throw ArgumentError.value(depth, 'depth');
  }
  final root = XmlDocument.parse(source).rootElement;
  if (root.name.local != 'svg') throw const FormatException('Expected SVG');
  final box = _numbers(root.getAttribute('viewBox') ?? '0 0 100 100');
  if (box.length != 4 || box[2] <= 0 || box[3] <= 0) {
    throw const FormatException('Invalid viewBox');
  }
  final scale = 2 / math.max(box[2], box[3]);
  final faces = <Face3D>[];
  void visit(
    XmlElement node,
    vector.Matrix4 parent,
    String inheritedFill,
    String inheritedRule,
  ) {
    final transform = parent.clone()
      ..multiply(_transform(node.getAttribute('transform') ?? ''));
    final style = {
      for (final part in (node.getAttribute('style') ?? '').split(';'))
        if (part.contains(':'))
          part.split(':').first.trim(): part
              .substring(part.indexOf(':') + 1)
              .trim(),
    };
    final fill = node.getAttribute('fill') ?? style['fill'] ?? inheritedFill;
    final rule =
        node.getAttribute('fill-rule') ?? style['fill-rule'] ?? inheritedRule;
    final name = node.name.local;
    final stroke = node.getAttribute('stroke') ?? style['stroke'];
    if (stroke != null && stroke != 'none') {
      throw const FormatException(
        'Convert strokes to filled contours before extrusion',
      );
    }
    for (final effect in ['filter', 'clip-path', 'mask']) {
      if ((node.getAttribute(effect) ?? style[effect] ?? 'none') != 'none') {
        throw FormatException(
          'Convert $effect to filled contours before extrusion',
        );
      }
    }
    String? data;
    if (name == 'path') data = node.getAttribute('d');
    if (name == 'rect') {
      final x = double.tryParse(node.getAttribute('x') ?? '') ?? 0,
          y = double.tryParse(node.getAttribute('y') ?? '') ?? 0;
      final w = double.parse(node.getAttribute('width')!),
          h = double.parse(node.getAttribute('height')!);
      data = 'M$x $y h$w v$h h${-w} Z';
    }
    if (name == 'polygon') data = 'M${node.getAttribute('points')}Z';
    if (name == 'circle' || name == 'ellipse') {
      final x = double.tryParse(node.getAttribute('cx') ?? '') ?? 0,
          y = double.tryParse(node.getAttribute('cy') ?? '') ?? 0;
      final rx = double.parse(
            node.getAttribute(name == 'circle' ? 'r' : 'rx')!,
          ),
          ry = double.parse(node.getAttribute(name == 'circle' ? 'r' : 'ry')!);
      data =
          'M${x - rx} $y A$rx $ry 0 1 0 ${x + rx} $y A$rx $ry 0 1 0 ${x - rx} $y Z';
    }
    if (['image', 'text', 'filter', 'mask', 'clipPath', 'use'].contains(name)) {
      throw FormatException(
        'Convert $name to filled contours before extrusion',
      );
    }
    if (data != null && fill != 'none') {
      final proxy = _Contours();
      writeSvgPathDataToPath(data, proxy);
      final contours = proxy.contours
          .where((points) => points.length >= 3)
          .map(
            (points) => points.map((point) {
              final p = transform.transformed3(
                vector.Vector3(point.dx, point.dy, 0),
              );
              return Offset(
                (p.x - box[0] - box[2] / 2) * scale,
                -(p.y - box[1] - box[3] / 2) * scale,
              );
            }).toList(),
          )
          .toList();
      final paths = contours
          .map((points) => Path()..addPolygon(points, true))
          .toList();
      final parents = <int?>[for (var i = 0; i < contours.length; i++) null];
      for (var i = 0; i < contours.length; i++) {
        final candidates = [
          for (var j = 0; j < contours.length; j++)
            if (j != i && paths[j].contains(contours[i].first)) j,
        ];
        if (candidates.isNotEmpty) {
          candidates.sort(
            (a, b) => paths[a].getBounds().size.longestSide.compareTo(
              paths[b].getBounds().size.longestSide,
            ),
          );
          parents[i] = candidates.first;
        }
      }
      int nesting(int i) {
        var result = 0;
        final seen = <int>{};
        while (parents[i] != null && seen.add(i)) {
          result++;
          i = parents[i]!;
        }
        return result;
      }

      double signedArea(List<Offset> ring) {
        var result = 0.0;
        for (var j = 0; j < ring.length; j++) {
          final a = ring[j], b = ring[(j + 1) % ring.length];
          result += a.dx * b.dy - b.dx * a.dy;
        }
        return result;
      }

      final signs = [
        for (final ring in contours) signedArea(ring).sign.toInt(),
      ];
      int boundary(int i) {
        if (rule == 'evenodd') return nesting(i).isEven ? 1 : -1;
        var winding = 0, current = parents[i];
        final seen = <int>{};
        while (current != null && seen.add(current)) {
          winding += signs[current];
          current = parents[current];
        }
        return winding == 0
            ? 1
            : winding + signs[i] == 0
            ? -1
            : 0;
      }

      final boundaries = [
        for (var i = 0; i < contours.length; i++) boundary(i),
      ];
      int? owner(int i) {
        var current = parents[i];
        final seen = <int>{};
        while (current != null && seen.add(current)) {
          if (boundaries[current] == 1) return current;
          current = parents[current];
        }
        return null;
      }

      final color = _color(fill);
      for (var i = 0; i < contours.length; i++) {
        if (boundaries[i] != 1) continue;
        final rings = [
          contours[i],
          for (var j = 0; j < contours.length; j++)
            if (boundaries[j] == -1 && owner(j) == i) contours[j],
        ];
        final points = rings.expand((ring) => ring).toList();
        final holes = <int>[];
        var count = rings.first.length;
        for (final ring in rings.skip(1)) {
          holes.add(count);
          count += ring.length;
        }
        final indices = Earcut.triangulateRaw([
          for (final point in points) ...[point.dx, point.dy],
        ], holeIndices: holes);
        vector.Vector3 v(int index, double z) =>
            vector.Vector3(points[index].dx, points[index].dy, z);
        for (var j = 0; j < indices.length; j += 3) {
          final a = indices[j], b = indices[j + 1], c = indices[j + 2];
          faces.add(
            Face3D(
              vector.Triangle.points(v(a, depth), v(b, depth), v(c, depth)),
              color: color,
            ),
          );
          faces.add(
            Face3D(
              vector.Triangle.points(v(c, -depth), v(b, -depth), v(a, -depth)),
              color: color,
            ),
          );
        }
        for (var ringIndex = 0; ringIndex < rings.length; ringIndex++) {
          final ring = rings[ringIndex];
          var area = 0.0;
          for (var j = 0; j < ring.length; j++) {
            final a = ring[j], b = ring[(j + 1) % ring.length];
            area += a.dx * b.dy - b.dx * a.dy;
          }
          final ordered = (area > 0) == (ringIndex == 0)
              ? ring
              : ring.reversed.toList();
          for (var j = 0; j < ordered.length; j++) {
            final a = ordered[j], b = ordered[(j + 1) % ordered.length];
            final aa = vector.Vector3(a.dx, a.dy, depth),
                bb = vector.Vector3(b.dx, b.dy, depth),
                cc = vector.Vector3(b.dx, b.dy, -depth),
                dd = vector.Vector3(a.dx, a.dy, -depth);
            faces.add(Face3D(vector.Triangle.points(aa, cc, bb), color: color));
            faces.add(Face3D(vector.Triangle.points(aa, dd, cc), color: color));
          }
        }
      }
    }
    for (final child in node.childElements) {
      if (!['defs', 'title', 'desc', 'metadata'].contains(child.name.local)) {
        visit(child, transform, fill, rule);
      }
    }
  }

  visit(root, vector.Matrix4.identity(), '#000000', 'nonzero');
  if (faces.isEmpty || faces.length > 30000) {
    throw const FormatException('SVG needs a bounded filled mesh');
  }
  return faces;
}

List<double> _numbers(String source) =>
    RegExp(r'[-+]?(?:[0-9]*[.])?[0-9]+(?:[eE][-+]?[0-9]+)?')
        .allMatches(source)
        .map((match) => double.parse(match[0]!))
        .toList();
vector.Matrix4 _transform(String source) {
  final result = vector.Matrix4.identity();
  for (final match in RegExp(r'([a-zA-Z]+)\(([^)]*)\)').allMatches(source)) {
    final n = _numbers(match[2]!);
    final next = vector.Matrix4.identity();
    switch (match[1]) {
      case 'translate':
        next.setTranslationRaw(n[0], n.length > 1 ? n[1] : 0, 0);
      case 'scale':
        next.setDiagonal(
          vector.Vector4(n[0], n.length > 1 ? n[1] : n[0], 1, 1),
        );
      case 'rotate':
        if (n.length > 2) next.setTranslationRaw(n[1], n[2], 0);
        next.rotateZ(n[0] * math.pi / 180);
        if (n.length > 2) next.translateByDouble(-n[1], -n[2], 0, 1);
      case 'matrix':
        next.setEntry(0, 0, n[0]);
        next.setEntry(1, 0, n[1]);
        next.setEntry(0, 1, n[2]);
        next.setEntry(1, 1, n[3]);
        next.setTranslationRaw(n[4], n[5], 0);
      default:
        throw FormatException('Unsupported transform ${match[1]}');
    }
    result.multiply(next);
  }
  return result;
}

Color _color(String value) {
  final color = value.trim().toLowerCase();
  const named = {
    'black': 0xff000000,
    'white': 0xffffffff,
    'red': 0xffff0000,
    'green': 0xff008000,
    'blue': 0xff0000ff,
    'transparent': 0x00000000,
  };
  if (named.containsKey(color)) return Color(named[color]!);
  var hex = color.replaceFirst('#', '');
  if (hex.length == 3 || hex.length == 4) {
    hex = hex.split('').map((c) => '$c$c').join();
  }
  final parsed = int.tryParse(hex, radix: 16);
  if (parsed == null || (hex.length != 6 && hex.length != 8)) {
    throw const FormatException('Use solid hex fills for extrusion');
  }
  return Color(
    hex.length == 8
        ? ((parsed & 0xff) << 24) | (parsed >> 8)
        : 0xff000000 | parsed,
  );
}
