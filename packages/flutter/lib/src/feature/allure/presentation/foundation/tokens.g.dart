// dart format off
import 'package:flutter/painting.dart';

class WantTextToken {
  final String font;
  final double min, max, weight, lineHeight, tracking;
  const WantTextToken(this.font, this.min, this.max, this.weight, this.lineHeight, this.tracking);
}

abstract final class WantTokens {
  static const dark = <String, Color>{
    'background': Color(0xFF0D0D0F),
    'foreground': Color(0xFFF0F0F2),
    'card': Color(0xFF161618),
    'card-foreground': Color(0xFFF0F0F2),
    'popover': Color(0xFF262628),
    'popover-foreground': Color(0xFFF0F0F2),
    'primary': Color(0xFF5962F0),
    'primary-foreground': Color(0xFFFFFFFF),
    'primary-edge': Color(0xFF5962F0),
    'secondary': Color(0xFF222224),
    'secondary-foreground': Color(0xFFF0F0F2),
    'muted': Color(0xFF161618),
    'muted-foreground': Color(0xFFA6A6AB),
    'accent': Color(0xFF29292C),
    'accent-foreground': Color(0xFFF0F0F2),
    'destructive': Color(0xFFE66A78),
    'border': Color(0xFF464648),
    'input': Color(0xFF85858A),
    'ring': Color(0xFFA3A8FF),
    'link': Color(0xFFA3A8FF),
    'primary-hover': Color(0xFF5059DE),
    'primary-active': Color(0xFF454ECB),
    'media-ground': Color(0xFF0A0A0B),
    'glass-highlight': Color(0x14FFFFFF),
    'error': Color(0xFFE66A78),
    'error-surface': Color(0xFFE66A78),
    'error-foreground': Color(0xFF15161A),
    'warning': Color(0xFFF0AF43),
    'warning-surface': Color(0xFFF0AF43),
    'warning-foreground': Color(0xFF15161A),
    'info': Color(0xFF48A6D9),
    'info-surface': Color(0xFF48A6D9),
    'info-foreground': Color(0xFF15161A),
    'success': Color(0xFF39B986),
    'success-surface': Color(0xFF39B986),
    'success-foreground': Color(0xFF15161A),
    'shimmer-highlight': Color(0x1FFFFFFF),
    'error-text': Color(0xFFE66A78),
    'warning-text': Color(0xFFF0AF43),
    'info-text': Color(0xFF48A6D9),
    'success-text': Color(0xFF39B986),
    'destructive-foreground': Color(0xFF15161A),
    'destructive-text': Color(0xFFE66A78),
    'primary-text': Color(0xFFA3A8FF),
    'primary-soft': Color(0xFF27272B),
    'surface-highlight': Color(0x14FFFFFF),
    'surface-shadow': Color(0x4D000000),
  };
  static const light = <String, Color>{
    'background': Color(0xFFF7F7FA),
    'foreground': Color(0xFF1B1C24),
    'card': Color(0xFFFFFFFF),
    'card-foreground': Color(0xFF1B1C24),
    'popover': Color(0xFFFFFFFF),
    'popover-foreground': Color(0xFF1B1C24),
    'primary': Color(0xFF5962F0),
    'primary-foreground': Color(0xFFFFFFFF),
    'primary-edge': Color(0xFF5962F0),
    'secondary': Color(0xFFECEEF4),
    'secondary-foreground': Color(0xFF1B1C24),
    'muted': Color(0xFFEFF0F5),
    'muted-foreground': Color(0xFF606371),
    'accent': Color(0xFFE1E4EE),
    'accent-foreground': Color(0xFF1B1C24),
    'destructive': Color(0xFFE66A78),
    'border': Color(0xFFD8DAE4),
    'input': Color(0xFF7A7E90),
    'ring': Color(0xFF5962F0),
    'link': Color(0xFF454ECB),
    'primary-hover': Color(0xFF5059DE),
    'primary-active': Color(0xFF454ECB),
    'media-ground': Color(0xFF0D0E12),
    'glass-highlight': Color(0xD9FFFFFF),
    'error': Color(0xFFE66A78),
    'error-surface': Color(0xFFE66A78),
    'error-foreground': Color(0xFF15161A),
    'warning': Color(0xFFF0AF43),
    'warning-surface': Color(0xFFF0AF43),
    'warning-foreground': Color(0xFF15161A),
    'info': Color(0xFF48A6D9),
    'info-surface': Color(0xFF48A6D9),
    'info-foreground': Color(0xFF15161A),
    'success': Color(0xFF39B986),
    'success-surface': Color(0xFF39B986),
    'success-foreground': Color(0xFF15161A),
    'shimmer-highlight': Color(0xB3FFFFFF),
    'error-text': Color(0xFF9E3447),
    'warning-text': Color(0xFF785013),
    'info-text': Color(0xFF17597C),
    'success-text': Color(0xFF116447),
    'destructive-foreground': Color(0xFF15161A),
    'destructive-text': Color(0xFF9E3447),
    'primary-text': Color(0xFF454ECB),
    'primary-soft': Color(0xFFE8EAFE),
    'surface-highlight': Color(0xD9FFFFFF),
    'surface-shadow': Color(0x14343850),
  };
  static const primaryRange = <String, double>{
    'minSaturation': 0.45,
    'maxSaturation': 0.90,
    'minLightness': 0.40,
    'maxLightness': 0.70,
  };
  static const paletteStyles = <String, Map<String, double>>{
    'smooth': {'saturation': 0.7, 'saturationFloor': 0, 'lightness': 0, 'softMix': 0.09, 'hueShift': 0, 'inputMix': -0.1},
    'contrast': {'saturation': 1, 'saturationFloor': 0, 'lightness': 0, 'softMix': 0.12, 'hueShift': 0, 'inputMix': 0},
    'neon': {'saturation': 1.25, 'saturationFloor': 0.84, 'lightness': 0.12, 'softMix': 0.16, 'hueShift': 0, 'inputMix': 0},
    'acid': {'saturation': 1.35, 'saturationFloor': 0.94, 'lightness': 0.04, 'softMix': 0.19, 'hueShift': 24, 'inputMix': 0.08},
  };
  static const statusPalettes = <String, Map<String, Color>>{
    'smooth': {'success': Color(0xFF97BA96), 'info': Color(0xFF92AEC9), 'warning': Color(0xFFD6B68F), 'error': Color(0xFFC68F9F)},
    'neon': {'success': Color(0xFF36E6B0), 'info': Color(0xFF39CEFF), 'warning': Color(0xFFFFB960), 'error': Color(0xFFFF5998)},
    'acid': {'success': Color(0xFFADDC45), 'info': Color(0xFF27C7BF), 'warning': Color(0xFFEDDA36), 'error': Color(0xFFFF7751)},
  };
  static const statusHarmonies = <String, Map<String, Map<String, Color>>>{
    'warm': {
    'smooth': {'success': Color(0xFF8CBAA5), 'info': Color(0xFF90B2CF), 'warning': Color(0xFFDCC38A), 'error': Color(0xFFC7899E)},
    'contrast': {'success': Color(0xFF44B298), 'info': Color(0xFF629FE0), 'warning': Color(0xFFE6BE52), 'error': Color(0xFFDF6289)},
    'neon': {'success': Color(0xFF32ECC6), 'info': Color(0xFF62B6FF), 'warning': Color(0xFFFFDA59), 'error': Color(0xFFFF5B9B)},
    'acid': {'success': Color(0xFF7AD65A), 'info': Color(0xFF28C9E1), 'warning': Color(0xFFDEDF43), 'error': Color(0xFFFF5877)},
    },
    'teal': {
    'smooth': {'success': Color(0xFFA2BB87), 'info': Color(0xFF96ABC9), 'warning': Color(0xFFDDBD8E), 'error': Color(0xFFC78F95)},
    'contrast': {'success': Color(0xFF95C872), 'info': Color(0xFF789FE0), 'warning': Color(0xFFEFBC71), 'error': Color(0xFFDF7881)},
    'neon': {'success': Color(0xFF50ED88), 'info': Color(0xFF55B6FF), 'warning': Color(0xFFFFCA58), 'error': Color(0xFFFF6389)},
    'acid': {'success': Color(0xFFBDDC4B), 'info': Color(0xFF53B4EF), 'warning': Color(0xFFF3D35E), 'error': Color(0xFFFF795C)},
    },
  };
  static const typographyPresets = <String, ({String display, String body, double weight, Map<String, String> localDisplay})>{
    'brand': (display: 'Days One', body: 'Manrope', weight: 400, localDisplay: {}),
    'geometric': (display: 'Unbounded', body: 'Manrope', weight: 600, localDisplay: {'ar': 'Noto Kufi Arabic'}),
    'editorial': (display: 'Literata', body: 'Manrope', weight: 600, localDisplay: {'zh': 'ZCOOL XiaoWei'}),
    'technical': (display: 'IBM Plex Mono', body: 'IBM Plex Sans', weight: 400, localDisplay: {}),
    'humanist': (display: 'Atkinson Hyperlegible Next', body: 'Atkinson Hyperlegible Next', weight: 700, localDisplay: {'ru': 'Manrope'}),
    'pixel': (display: 'Pixelify Sans', body: 'Manrope', weight: 400, localDisplay: {'ja': 'DotGothic16', 'ru': 'DotGothic16'}),
  };
  static const geometry = <String, double>{
    'fieldRadiusPx': 12.0,
    'panelRadiusPx': 24.0,
    'mediaRadiusPx': 24.0,
    'prominentRadiusPx': 32.0,
    'touchTargetPx': 44.0,
    'spacingStepPx': 4.0,
  };
  static const material = <String, double>{
    'stepPx': 4.0,
    'edgeWidthPx': 1.0,
    'shadowBlurPx': 24.0,
    'shadowOffsetYPx': 8.0,
    'overlayBlurPx': 48.0,
    'overlayOffsetYPx': 20.0,
  };
  static const motion = <String, Duration>{
    'feedbackMs': Duration(milliseconds: 120),
    'transitionMs': Duration(milliseconds: 180),
    'glowMs': Duration(milliseconds: 2600),
    'confettiMs': Duration(milliseconds: 800),
  };
  static const easing = <double>[0.32, 0.72, 0.00, 1.00];
  static const glassOpacity = 0.68;
  static const glassBlur = 20.0;
  static const glassSaturation = 1.2;
  static const typography = <String, WantTextToken>{
    'display': WantTextToken('display', 32.0, 64.0, 400.0, 1.08, -0.045),
    'h1': WantTextToken('display', 28.0, 48.0, 400.0, 1.15, -0.035),
    'h2': WantTextToken('display', 24.0, 36.0, 400.0, 1.2, -0.025),
    'h3': WantTextToken('display', 22.0, 28.0, 400.0, 1.3, -0.02),
    'h4': WantTextToken('display', 20.0, 24.0, 400.0, 1.35, -0.015),
    'h5': WantTextToken('display', 18.0, 20.0, 400.0, 1.4, 0),
    'h6': WantTextToken('display', 16.0, 18.0, 400.0, 1.4, 0),
    'lead': WantTextToken('body', 18.0, 20.0, 400.0, 1.75, 0),
    'body': WantTextToken('body', 16.0, 16.0, 400.0, 1.7, 0),
    'small': WantTextToken('body', 14.0, 14.0, 400.0, 1.6, 0),
    'caption': WantTextToken('body', 14.0, 14.0, 400.0, 1.5, 0),
    'label': WantTextToken('body', 14.0, 14.0, 600.0, 1.4, 0),
    'overline': WantTextToken('body', 14.0, 14.0, 650.0, 1.4, 0.08),
    'mono': WantTextToken('mono', 16.0, 16.0, 400.0, 1.7, 0),
    'code': WantTextToken('mono', 14.0, 14.0, 400.0, 1.6, 0),
    'code-block': WantTextToken('mono', 14.0, 14.0, 400.0, 1.7, 0),
    'quote': WantTextToken('body', 18.0, 20.0, 500.0, 1.7, 0),
  };
}
