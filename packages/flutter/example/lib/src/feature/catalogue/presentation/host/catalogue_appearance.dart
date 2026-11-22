import 'package:flutter/widgets.dart';
import 'package:want_allure/want_allure.dart';

typedef CatalogueAppearance = ({
  Color? primaryColor,
  WantPaletteStyle paletteStyle,
  WantTypographyPreset typographyPreset,
});

const defaultCatalogueAppearance = (
  primaryColor: null as Color?,
  paletteStyle: WantPaletteStyle.contrast,
  typographyPreset: WantTypographyPreset.brand,
);

CatalogueAppearance catalogueAppearance(
  Map<Object?, Object?> values,
  CatalogueAppearance fallback,
) {
  final seed = values['primaryColor'];
  final color = seed is String && RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(seed)
      ? Color(0xFF000000 | int.parse(seed.substring(1), radix: 16))
      : null;
  return (
    primaryColor: color != null && isSupportedWantPrimaryColor(color)
        ? color
        : seed == null
        ? fallback.primaryColor
        : null,
    paletteStyle:
        WantPaletteStyle.values
            .where((value) => value.name == values['paletteStyle'])
            .firstOrNull ??
        fallback.paletteStyle,
    typographyPreset:
        WantTypographyPreset.values
            .where((value) => value.name == values['typographyPreset'])
            .firstOrNull ??
        fallback.typographyPreset,
  );
}

final catalogueBrandResources = WantBrandResources(
  fonts: {
    for (final family in [
      'Days One',
      'Manrope',
      'Atkinson Hyperlegible Next',
      'DotGothic16',
      'IBM Plex Mono',
      'IBM Plex Sans',
      'Literata',
      'Noto Kufi Arabic',
      'Pixelify Sans',
      'Unbounded',
      'ZCOOL XiaoWei',
      'Noto Sans JP',
      'Noto Sans SC',
      'Noto Sans Devanagari',
      'Noto Sans Arabic',
      'Noto Sans Hebrew',
    ])
      family: 'packages/want_allure/$family',
  },
  icons: const {
    'check': WantIcons.success,
    'star': WantIcons.star,
    'heart': WantIcons.heart,
    'copy': WantIcons.copy,
    'search': WantIcons.search,
  },
  logos: {
    for (final mode in ['light', 'dark', 'mark'])
      'allure-$mode': (context) => WantBrandLogo.asset(
        'assets/brand/allure/logos/${mode == "mark" ? WantTheme.of(context).forui.colors.brightness.name : mode}/transparent.svg',
        label: 'Want Allure',
        package: 'want_allure',
      ),
  },
);
