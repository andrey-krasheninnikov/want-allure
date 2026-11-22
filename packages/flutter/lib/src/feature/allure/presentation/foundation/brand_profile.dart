import 'package:flutter/widgets.dart';
import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

enum WantDensity { comfortable, compact }

enum WantSurface { flat, soft, glass }

enum WantMotion { standard, quiet, off }

/// Local resources owned by the host application. Unknown IDs use kit defaults.
@immutable
class WantBrandResources {
  final Map<String, String> fonts;
  final Map<String, IconData> icons;
  final Map<String, WidgetBuilder> logos;
  const WantBrandResources({
    this.fonts = const {},
    this.icons = const {},
    this.logos = const {},
  });
}

/// Portable presentation settings. IDs refer to the host's resource registry.
@immutable
class WantBrandProfileV1 {
  final Color? brandColor;
  final WantPaletteStyle paletteStyle;
  final WantTypographyPreset typographyPreset;
  final WantDensity density;
  final WantSurface surface;
  final WantMotion motion;
  final Map<String, Color> light, dark;
  final Map<String, double> radii;
  final Map<String, String> fonts, icons, logos;
  const WantBrandProfileV1._({
    this.brandColor,
    this.paletteStyle = WantPaletteStyle.contrast,
    this.typographyPreset = WantTypographyPreset.brand,
    this.density = WantDensity.comfortable,
    this.surface = WantSurface.soft,
    this.motion = WantMotion.standard,
    this.light = const {},
    this.dark = const {},
    this.radii = const {},
    this.fonts = const {},
    this.icons = const {},
    this.logos = const {},
  });
  static const defaults = WantBrandProfileV1._();

  factory WantBrandProfileV1.fromJson(Map<Object?, Object?> json) {
    Map<String, Object?> object(
      Object? value,
      String path, [
      Iterable<String>? keys,
    ]) {
      if (value is! Map) throw FormatException('Expected object at $path');
      for (final key in value.keys) {
        if (key is! String ||
            key.isEmpty ||
            (keys != null && !keys.contains(key))) {
          throw FormatException('Unknown key $path.$key');
        }
      }
      return Map<String, Object?>.from(value);
    }

    const fields = [
      'schemaVersion',
      'brandColor',
      'paletteStyle',
      'typographyPreset',
      'colors',
      'radii',
      'density',
      'surface',
      'fonts',
      'icons',
      'logos',
      'motion',
    ];
    object(json, 'profile', fields);
    if (json['schemaVersion'] != 1) {
      throw const FormatException('Expected schemaVersion 1');
    }
    T choice<T extends Enum>(String key, List<T> values, T fallback) {
      if (!json.containsKey(key)) return fallback;
      return values.where((v) => v.name == json[key]).firstOrNull ??
          (throw FormatException('Invalid $key'));
    }

    Color hex(Object? value, String key) {
      if (value is! String || !RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(value)) {
        throw FormatException('Expected #RRGGBB for $key');
      }
      return Color(0xff000000 | int.parse(value.substring(1), radix: 16));
    }

    Map<String, Object?> optional(String key, [Iterable<String>? keys]) =>
        json.containsKey(key) ? object(json[key], key, keys) : {};
    Map<String, String> ids(String key, [List<String>? keys]) =>
        Map.unmodifiable(
          optional(key, keys).map((name, id) {
            if (id is! String ||
                id.trim() != id ||
                id.isEmpty ||
                id.runes.length > 128 ||
                name.trim() != name ||
                name.runes.length > 128) {
              throw FormatException('Invalid $key.$name');
            }
            return MapEntry(name, id);
          }),
        );
    final colors = optional('colors', ['light', 'dark']);
    Map<String, Color> roles(String mode) => !colors.containsKey(mode)
        ? const {}
        : Map.unmodifiable(
            object(colors[mode], 'colors.$mode', WantTokens.light.keys).map(
              (key, value) => MapEntry(key, hex(value, 'colors.$mode.$key')),
            ),
          );
    final profile = WantBrandProfileV1._(
      brandColor: json.containsKey('brandColor')
          ? hex(json['brandColor'], 'brandColor')
          : null,
      paletteStyle: choice(
        'paletteStyle',
        WantPaletteStyle.values,
        WantPaletteStyle.contrast,
      ),
      typographyPreset: choice(
        'typographyPreset',
        WantTypographyPreset.values,
        WantTypographyPreset.brand,
      ),
      density: choice('density', WantDensity.values, WantDensity.comfortable),
      surface: choice('surface', WantSurface.values, WantSurface.soft),
      motion: choice('motion', WantMotion.values, WantMotion.standard),
      light: roles('light'),
      dark: roles('dark'),
      radii: Map.unmodifiable(
        optional('radii', ['field', 'panel', 'media', 'action']).map((
          key,
          value,
        ) {
          if (value is! num || !value.isFinite || value < 0 || value > 999) {
            throw FormatException('Invalid radii.$key');
          }
          return MapEntry(key, value.toDouble());
        }),
      ),
      fonts: ids('fonts', [
        'display',
        'body',
        'mono',
        'ja',
        'zh',
        'ar',
        'hi',
        'he',
      ]),
      icons: ids('icons'),
      logos: ids('logos', ['light', 'dark', 'mark']),
    );
    for (final mode in Brightness.values) {
      if ((mode == Brightness.dark ? profile.dark : profile.light).isNotEmpty) {
        profile.palette(mode);
      }
    }
    return profile;
  }

  /// Serializes effective settings, omitting default values and empty maps.
  Map<String, Object?> toJson() {
    String hex(Color color) =>
        '#${(color.toARGB32() & 0xffffff).toRadixString(16).padLeft(6, '0').toUpperCase()}';
    Map<String, String> colors(Map<String, Color> roles) =>
        roles.map((role, color) => MapEntry(role, hex(color)));
    return {
      'schemaVersion': 1,
      if (brandColor case final seed?) 'brandColor': hex(seed),
      if (paletteStyle != defaults.paletteStyle)
        'paletteStyle': paletteStyle.name,
      if (typographyPreset != defaults.typographyPreset)
        'typographyPreset': typographyPreset.name,
      if (light.isNotEmpty || dark.isNotEmpty)
        'colors': {
          if (light.isNotEmpty) 'light': colors(light),
          if (dark.isNotEmpty) 'dark': colors(dark),
        },
      if (radii.isNotEmpty) 'radii': {...radii},
      if (density != defaults.density) 'density': density.name,
      if (surface != defaults.surface) 'surface': surface.name,
      if (fonts.isNotEmpty) 'fonts': {...fonts},
      if (icons.isNotEmpty) 'icons': {...icons},
      if (logos.isNotEmpty) 'logos': {...logos},
      if (motion != defaults.motion) 'motion': motion.name,
    };
  }

  Map<String, Color> palette(Brightness brightness) {
    final overrides = brightness == Brightness.dark ? dark : light;
    final values = {
      ...resolveWantPalette(
        brightness,
        brandColor,
        paletteStyle,
        allowAnySeed: true,
      ),
      ...overrides,
    };
    void pair(String a, String b, double minimum) {
      if (!overrides.containsKey(a) && !overrides.containsKey(b)) return;
      final x = values[a]!.computeLuminance(),
          y = values[b]!.computeLuminance();
      final ratio = x > y ? (x + .05) / (y + .05) : (y + .05) / (x + .05);
      if (ratio < minimum) {
        throw FormatException(
          'colors.${brightness.name}.${overrides.containsKey(a) ? a : b}: insufficient contrast between $a and $b',
        );
      }
    }

    for (final surface in [
      'background',
      'card',
      'popover',
      'secondary',
      'accent',
    ]) {
      for (final ink in [
        'primary-text',
        'link',
        'success-text',
        'info-text',
        'warning-text',
        'error-text',
        'destructive-text',
      ]) {
        pair(ink, surface, 4.5);
      }
      for (final control in ['primary-edge', 'ring', 'input']) {
        pair(control, surface, 3);
      }
    }
    for (final role in [
      'card',
      'popover',
      'primary',
      'secondary',
      'accent',
      'muted',
      'destructive',
      'success',
      'info',
      'warning',
      'error',
    ]) {
      pair('$role-foreground', role, 4.5);
    }
    pair('foreground', 'background', 4.5);
    pair('primary-text', 'primary-soft', 4.5);
    for (final role in ['success', 'info', 'error', 'warning']) {
      pair('$role-foreground', '$role-surface', 4.5);
    }
    for (final state in ['primary-hover', 'primary-active']) {
      pair('primary-foreground', state, 4.5);
    }
    return Map.unmodifiable(values);
  }
}
