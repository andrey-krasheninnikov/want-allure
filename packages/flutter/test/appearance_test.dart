import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_allure/want_allure.dart';

void main() {
  test('palette output matches the same vectors used by foundation', () {
    final fixtures = jsonDecode(
      File('test/fixtures/appearance-palettes.json').readAsStringSync(),
    ) as List<dynamic>;
    for (final fixture in fixtures.cast<Map<String, dynamic>>()) {
      final factory = fixture['theme'] == 'dark'
          ? WantThemeData.dark
          : WantThemeData.light;
      final data = factory(
        primaryColor: parse(fixture['primaryColor'] as String),
        paletteStyle: WantPaletteStyle.values.byName(
          fixture['paletteStyle'] as String,
        ),
      );
      final roles = fixture['roles'] as Map<String, dynamic>;
      for (final entry in roles.entries) {
        expect(
          data.color(entry.key).toARGB32(),
          parse(entry.value as String).toARGB32(),
          reason:
              '${fixture['theme']} ${fixture['paletteStyle']} ${fixture['primaryColor']} ${entry.key}',
        );
      }
    }
  });

  test('explicit overrides still win and alpha seeds are rejected', () {
    const ring = Color(0xFF85D721);
    final data = WantThemeData.dark(
      primaryColor: const Color(0xFFE23B66),
      paletteStyle: WantPaletteStyle.acid,
      overrides: {'ring': ring},
    );
    expect(data.forui.style.focusedOutlineStyle.color, ring);
    expect(
      () => WantThemeData.dark(primaryColor: const Color(0x7FE23B66)),
      throwsArgumentError,
    );
  });

  test('primary range accepts its boundaries and rejects extreme seeds', () {
    for (final seed in ['#AE7842', '#D10B64', '#946638', '#E184A0']) {
      expect(isSupportedWantPrimaryColor(parse(seed)), isTrue);
    }
    for (final seed in [
      '#000000',
      '#FFFFFF',
      '#808080',
      '#0025FF',
      '#936638',
      '#E284A0',
    ]) {
      expect(isSupportedWantPrimaryColor(parse(seed)), isFalse);
      expect(
        () => WantThemeData.light(primaryColor: parse(seed)),
        throwsArgumentError,
      );
    }
  });

  test('localized font presets choose the expected registered face', () {
    final pixel = WantThemeData.dark(
      locale: const Locale('ja'),
      typographyPreset: WantTypographyPreset.pixel,
    );
    expect(
      pixel.forui.typography.display.lg.fontFamily,
      'packages/want_allure/DotGothic16',
    );
    expect(
      pixel.forui.typography.body.lg.fontFamily,
      'packages/want_allure/Noto Sans JP',
    );
    final editorial = WantThemeData.light(
      locale: const Locale('zh'),
      typographyPreset: WantTypographyPreset.editorial,
    );
    expect(
      editorial.forui.typography.display.lg.fontFamily,
      'packages/want_allure/ZCOOL XiaoWei',
    );
    expect(
      editorial.forui.typography.body.lg.fontFamily,
      'packages/want_allure/Noto Sans SC',
    );
  });
}

Color parse(String hex) =>
    Color(0xFF000000 | int.parse(hex.substring(1), radix: 16));
