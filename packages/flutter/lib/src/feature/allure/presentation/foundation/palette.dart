import 'dart:math' as math;

import 'dart:ui' show Brightness, Color;

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

enum WantPaletteStyle { smooth, contrast, neon, acid }

typedef _Rgb = (int, int, int);

_Rgb _rgb(Color color) {
  final value = color.toARGB32();
  return (value >> 16 & 255, value >> 8 & 255, value & 255);
}

Color _color(_Rgb value) => Color.fromARGB(255, value.$1, value.$2, value.$3);
const _black = (0, 0, 0), _white = (255, 255, 255);

double _clamp(double n) => n.clamp(0.0, 1.0);

double _linear(int channel) {
  final v = channel / 255;
  return v <= .04045 ? v / 12.92 : math.pow((v + .055) / 1.055, 2.4).toDouble();
}

double _luminance(_Rgb color) =>
    _linear(color.$1) * .2126 +
    _linear(color.$2) * .7152 +
    _linear(color.$3) * .0722;

double _contrast(_Rgb a, _Rgb b) {
  final x = _luminance(a), y = _luminance(b);
  return (math.max(x, y) + .05) / (math.min(x, y) + .05);
}

_Rgb _mix(_Rgb a, _Rgb b, double weight) => (
  (a.$1 + (b.$1 - a.$1) * weight).round(),
  (a.$2 + (b.$2 - a.$2) * weight).round(),
  (a.$3 + (b.$3 - a.$3) * weight).round(),
);

({double warm, double teal}) _harmonyWeights(
  double hue,
  double brandHue,
  _Rgb seed,
) {
  final angle = (hue - 25) % 360;
  const teal = 170.0 - 25;
  final brand = brandHue - 25;
  final channels = [seed.$1, seed.$2, seed.$3];
  final strength = _clamp(
    (channels.reduce(math.max) - channels.reduce(math.min)) / 48,
  );
  double ease(double t) {
    final x = _clamp(t);
    return strength * x * x * (3 - 2 * x);
  }

  return (
    warm: ease(
      angle < teal ? 1 - angle / teal : (angle - brand) / (360 - brand),
    ),
    teal: ease(math.min(angle / teal, (brand - angle) / (brand - teal))),
  );
}

_Rgb _blendStatus(
  _Rgb anchor,
  _Rgb warm,
  _Rgb teal,
  ({double warm, double teal}) weights,
) {
  int channel(int a, int w, int t) {
    final base = _linear(a);
    final value =
        base +
        weights.warm * (_linear(w) - base) +
        weights.teal * (_linear(t) - base);
    final encoded = value <= .0031308
        ? 12.92 * value
        : 1.055 * math.pow(value, 1 / 2.4) - .055;
    return (_clamp(encoded) * 255).round();
  }

  return (
    channel(anchor.$1, warm.$1, teal.$1),
    channel(anchor.$2, warm.$2, teal.$2),
    channel(anchor.$3, warm.$3, teal.$3),
  );
}

(double, double, double) _hsl(_Rgb value) {
  final r = value.$1 / 255, g = value.$2 / 255, b = value.$3 / 255;
  final min = math.min(r, math.min(g, b)), max = math.max(r, math.max(g, b));
  final delta = max - min, lightness = (max + min) / 2;
  if (delta == 0) return (0, 0, lightness);
  final segment = max == r
      ? (g - b) / delta
      : max == g
      ? 2 + (b - r) / delta
      : 4 + (r - g) / delta;
  return (
    (segment * 60 + 360) % 360,
    delta / (1 - (2 * lightness - 1).abs()),
    lightness,
  );
}

_Rgb _fromHsl(double hue, double saturation, double lightness) {
  final c = (1 - (2 * lightness - 1).abs()) * saturation;
  final segment = (hue % 360) / 60;
  final x = c * (1 - (segment % 2 - 1).abs()), m = lightness - c / 2;
  final channels = switch (segment) {
    < 1 => (c, x, 0.0),
    < 2 => (x, c, 0.0),
    < 3 => (0.0, c, x),
    < 4 => (0.0, x, c),
    < 5 => (x, 0.0, c),
    _ => (c, 0.0, x),
  };
  int byte(double value) => (_clamp(value + m) * 255).round();
  return (byte(channels.$1), byte(channels.$2), byte(channels.$3));
}

_Rgb _fit(
  double hue,
  double saturation,
  double target,
  bool Function(_Rgb) accepts,
  _Rgb fallback,
) {
  for (var step = 0; step <= 100; step++) {
    final down = _fromHsl(hue, saturation, _clamp(target - step / 100));
    if (accepts(down)) return down;
    if (step == 0) continue;
    final up = _fromHsl(hue, saturation, _clamp(target + step / 100));
    if (accepts(up)) return up;
  }
  return fallback;
}

bool isSupportedWantPrimaryColor(Color color) {
  if (color.a != 1) return false;
  final (_, saturation, lightness) = _hsl(_rgb(color));
  final range = WantTokens.primaryRange;
  const tolerance = 1e-9;
  return saturation >= range['minSaturation']! - tolerance &&
      saturation <= range['maxSaturation']! + tolerance &&
      lightness >= range['minLightness']! - tolerance &&
      lightness <= range['maxLightness']! + tolerance;
}

Map<String, Color> resolveWantPalette(
  Brightness brightness,
  Color? primaryColor,
  WantPaletteStyle style, {
  bool allowAnySeed = false,
}) {
  final dark = brightness == Brightness.dark;
  final base = dark ? WantTokens.dark : WantTokens.light;
  final seed = primaryColor ?? base['primary']!;
  if (!allowAnySeed && !isSupportedWantPrimaryColor(seed)) {
    throw ArgumentError.value(
      seed,
      'primaryColor',
      'Use an opaque color with HSL saturation 45–90% and lightness 40–70%',
    );
  }
  if (_rgb(seed) == _rgb(base['primary']!) &&
      style == WantPaletteStyle.contrast) {
    return base;
  }

  final profile = WantTokens.paletteStyles[style.name]!;
  final seedColor = _rgb(seed);
  final (hue, saturation, lightness) = _hsl(seedColor);
  final chroma = saturation == 0
      ? 0.0
      : _clamp(
          math.max(
            profile['saturationFloor']!,
            saturation * profile['saturation']!,
          ),
        );
  final surfaces = [
    'background',
    'card',
    'secondary',
    'popover',
    'accent',
  ].map((key) => _rgb(base[key]!)).toList();
  bool onSurfaces(_Rgb value, double minimum) =>
      surfaces.every((surface) => _contrast(value, surface) >= minimum);
  final opposite = dark ? _white : _black;
  final target = _clamp(lightness + profile['lightness']!);
  final graphite = _rgb(WantTokens.light['foreground']!);
  final vividSeed =
      style == WantPaletteStyle.neon &&
      saturation >= profile['saturationFloor']!;
  final intended = vividSeed ? seedColor : _fromHsl(hue, chroma, target);
  final bright =
      _contrast(seedColor, _white) < 4.5 && _contrast(intended, graphite) >= 7;
  final ink = bright ? graphite : _white;
  final minimum = bright ? 7.0 : 4.5;
  final primary = bright
      ? intended
      : _fit(
          hue,
          chroma,
          target,
          (value) => _contrast(value, ink) >= minimum && onSurfaces(value, 3),
          _fit(
            hue,
            chroma,
            target,
            (value) => _contrast(value, ink) >= minimum,
            _black,
          ),
        );
  final primaryLightness = _hsl(primary).$3;
  final edge = onSurfaces(primary, 3)
      ? primary
      : _fit(
          hue,
          chroma,
          primaryLightness,
          (value) => onSurfaces(value, 3),
          opposite,
        );
  bool readableState(_Rgb value) =>
      _contrast(value, ink) >= minimum && (bright || onSurfaces(value, 3));
  double travel(double offset) =>
      _hsl(
        _fit(
          hue,
          chroma,
          _clamp(primaryLightness + offset),
          readableState,
          primary,
        ),
      ).$3 -
      primaryLightness;
  const preferred = -.08;
  var range = travel(preferred);
  if (range.abs() < .07) {
    final reverse = travel(-preferred);
    if (reverse.abs() > range.abs()) range = reverse;
  }
  _Rgb state(double fraction) {
    final bend = fraction * (1 - _clamp(range.abs() / .08));
    return _fit(
      hue + 20 * bend,
      chroma * (1 - .24 * bend),
      primaryLightness + fraction * range,
      readableState,
      primary,
    );
  }

  final shifted = hue + profile['hueShift']!;
  final soft = _mix(
    _rgb(base['secondary']!),
    _fromHsl(shifted, chroma, primaryLightness),
    profile['softMix']!,
  );
  final text = _fit(
    hue,
    chroma,
    dark ? .76 : .34,
    (value) => onSurfaces(value, 4.5) && _contrast(value, soft) >= 4.5,
    opposite,
  );
  final ring = _fit(
    shifted,
    chroma,
    dark ? .72 : .37,
    (value) => onSurfaces(value, 3),
    opposite,
  );
  final inputMix = profile['inputMix']!;
  final input = _mix(
    _rgb(base['input']!),
    _rgb(base[inputMix < 0 ? 'background' : 'foreground']!),
    inputMix.abs(),
  );
  final statusColors = <String, Color>{};
  final brandHue = _hsl(_rgb(base['primary']!)).$1;
  final anchors = style == WantPaletteStyle.contrast
      ? base
      : WantTokens.statusPalettes[style.name]!;
  final weights = _harmonyWeights(hue, brandHue, seedColor);
  final warm = WantTokens.statusHarmonies['warm']![style.name]!;
  final teal = WantTokens.statusHarmonies['teal']![style.name]!;
  for (final role in ['success', 'info', 'warning', 'error']) {
    final surface = _blendStatus(
      _rgb(anchors[role]!),
      _rgb(warm[role]!),
      _rgb(teal[role]!),
      weights,
    );
    final (statusHue, statusSaturation, statusLightness) = _hsl(surface);
    final preferredInk = _rgb(base['$role-foreground']!);
    final inkOnFill = _contrast(surface, preferredInk) >= 4.5
        ? preferredInk
        : _contrast(surface, _black) >= _contrast(surface, _white)
        ? _black
        : _white;
    statusColors[role] = statusColors['$role-surface'] = _color(surface);
    statusColors['$role-foreground'] = _color(inkOnFill);
    statusColors['$role-text'] = _color(
      _fit(
        statusHue,
        statusSaturation,
        dark ? statusLightness : math.min(statusLightness, .32),
        (value) => onSurfaces(value, 4.5),
        opposite,
      ),
    );
  }
  return {
    ...base,
    ...statusColors,
    'destructive': statusColors['error']!,
    'destructive-foreground': statusColors['error-foreground']!,
    'destructive-text': statusColors['error-text']!,
    'primary': _color(primary),
    'primary-edge': _color(edge),
    'primary-hover': _color(state(.5)),
    'primary-active': _color(state(1)),
    'primary-foreground': _color(ink),
    'primary-text': _color(text),
    'link': _color(text),
    'primary-soft': _color(soft),
    'ring': _color(ring),
    'input': onSurfaces(input, 3) ? _color(input) : base['input']!,
  };
}
