import { readFile, writeFile } from 'node:fs/promises';
import { resolve } from 'node:path';

const root = resolve(import.meta.dir, '..');
const tokens = JSON.parse(await readFile(resolve(root, 'packages/foundation/tokens.json'), 'utf8'));
const color = (value: string) => {
  const hex = value.slice(1);
  return `Color(0x${hex.length === 8 ? hex.slice(6) + hex.slice(0, 6) : 'FF' + hex})`;
};
const maps = Object.entries(tokens.themes.wallpapers).map(([theme, values]) =>
  `  static const ${theme} = <String, Color>{\n${Object.entries(values as Record<string, string>).map(([key, value]) => `    '${key}': ${color(value)},`).join('\n')}\n  };`).join('\n');
const entries = (values: Record<string, number>) => Object.entries(values).map(([key, value]) => `    '${key}': ${value.toFixed(1)},`).join('\n');
const source = `// dart format off\nimport 'package:flutter/painting.dart';\n\nclass WantTextToken {\n  final String font;\n  final double min, max, weight, lineHeight, tracking;\n  const WantTextToken(this.font, this.min, this.max, this.weight, this.lineHeight, this.tracking);\n}\n\nabstract final class WantTokens {\n${maps}\n  static const geometry = <String, double>{\n${entries(tokens.geometry)}\n  };\n  static const motion = <String, Duration>{\n${Object.entries(tokens.motion).filter(([, value]) => typeof value === 'number').map(([key, value]) => `    '${key}': Duration(milliseconds: ${value}),`).join('\n')}\n  };\n  static const easing = <double>[${tokens.motion.easing.map((v: number) => v.toFixed(2)).join(', ')}];\n  static const glassOpacity = ${tokens.glass.opacityPercent / 100};\n  static const glassBlur = ${tokens.glass.blurPx.toFixed(1)};\n  static const glassSaturation = ${tokens.glass.saturationPercent / 100};\n  static const typography = <String, WantTextToken>{\n${Object.entries(tokens.typography.styles).map(([key, value]: [string, any]) => `    '${key}': WantTextToken('${value.font}', ${value.minPx.toFixed(1)}, ${value.maxPx.toFixed(1)}, ${value.weight.toFixed(1)}, ${value.lineHeight}, ${value.trackingEm}),`).join('\n')}\n  };\n}\n`;
const target = resolve(root, 'packages/flutter/lib/src/feature/allure/presentation/foundation/tokens.g.dart');
if (process.argv.includes('--check')) {
  if (await readFile(target, 'utf8') !== source) throw new Error('Flutter tokens differ from the canonical foundation. Run bun run flutter:tokens.');
  console.log('Flutter tokens match the foundation.');
} else {
  await writeFile(target, source);
}
