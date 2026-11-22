import { expect, test } from 'bun:test';
import { brandPaletteVariables, createThemeVariables, isSupportedPrimaryColor, type PaletteStyle } from '../packages/foundation/src/appearance';
import tokens from '../packages/foundation/tokens.json';
import fixtures from '../packages/flutter/test/fixtures/appearance-palettes.json';

const luminance = (hex: string) => [1, 3, 5].map(i => parseInt(hex.slice(i, i + 2), 16) / 255)
  .map(channel => channel <= .04045 ? channel / 12.92 : ((channel + .055) / 1.055) ** 2.4)
  .reduce((sum, channel, i) => sum + channel * [.2126, .7152, .0722][i]!, 0);
const contrast = (a: string, b: string) => {
  const x = luminance(a), y = luminance(b);
  return (Math.max(x, y) + .05) / (Math.min(x, y) + .05);
};

test('omitting appearance options matches the canonical palette in either theme', () => {
  for (const theme of ['light', 'dark'] as const) {
    const values = createThemeVariables({ theme });
    for (const [role, value] of Object.entries(tokens.themes.wallpapers[theme])) expect(values[`--${role}`]).toBe(value);
    expect(createThemeVariables({ theme, paletteStyle: 'contrast', primaryColor: '#5962f0' })).toEqual(values);
  }
  expect(() => createThemeVariables({ theme: 'dark', primaryColor: '#fff' })).toThrow(RangeError);
});

test('all styles preserve neutral surfaces and readable primary roles across seed colors', () => {
  for (const theme of ['light', 'dark'] as const) {
    const base = tokens.themes.wallpapers[theme];
    for (const paletteStyle of Object.keys(tokens.paletteStyles) as PaletteStyle[]) {
      for (const primaryColor of ['#AE7842', '#D10B64', '#946638', '#E184A0', '#22DD88', '#506BC3', '#B13893']) {
        const values = createThemeVariables({ theme, primaryColor, paletteStyle });
        const color = (role: string) => values[`--${role}`]!;
        for (const role of ['background', 'card', 'secondary', 'accent', 'popover'] as const) {
          expect(color(role)).toBe(base[role]);
        }
        for (const surface of ['background', 'card', 'secondary', 'accent', 'popover']) {
          for (const role of ['ring', 'input', 'primary-edge']) {
            expect(contrast(color(role), color(surface)), `${theme} ${paletteStyle} ${primaryColor}: ${role} on ${surface}`).toBeGreaterThanOrEqual(3);
          }
        }
        for (const surface of ['background', 'card', 'secondary', 'accent', 'popover', 'primary-soft']) {
          expect(contrast(color('primary-text'), color(surface))).toBeGreaterThanOrEqual(4.5);
        }
        const other = createThemeVariables({ theme: theme === 'dark' ? 'light' : 'dark', primaryColor, paletteStyle });
        for (const status of ['success', 'info', 'warning', 'error']) {
          expect(color(status)).toBe(other[('--' + status) as `--${string}`]);
          expect(contrast(color(status + '-surface'), color(status + '-foreground'))).toBeGreaterThanOrEqual(4.5);
          for (const surface of ['background', 'card', 'secondary', 'accent', 'popover']) {
            expect(contrast(color(status + '-text'), color(surface))).toBeGreaterThanOrEqual(4.5);
          }
        }
        expect(color('destructive')).toBe(color('error'));
        for (const role of ['primary', 'primary-hover', 'primary-active']) {
          expect(contrast(color(role), color('primary-foreground'))).toBeGreaterThanOrEqual(4.5);
        }
      }
    }
  }
  const variants = Object.keys(tokens.paletteStyles).map(paletteStyle =>
    createThemeVariables({ theme: 'dark', primaryColor: '#506BC3', paletteStyle: paletteStyle as PaletteStyle })['--primary-soft']);
  expect(new Set(variants).size).toBe(4);
});

test('primary range is inclusive and status colors follow both appearance choices', () => {
  for (const seed of ['#AE7842', '#D10B64', '#946638', '#E184A0']) expect(isSupportedPrimaryColor(seed)).toBe(true);
  for (const seed of ['#000000', '#FFFFFF', '#808080', '#0025FF', '#936638', '#E284A0']) {
    expect(isSupportedPrimaryColor(seed)).toBe(false);
    expect(() => createThemeVariables({ theme: 'dark', primaryColor: seed })).toThrow(RangeError);
  }
  const styles = Object.keys(tokens.paletteStyles) as PaletteStyle[];
  for (const role of ['success', 'info', 'warning', 'error']) {
    const status = (paletteStyle: PaletteStyle, primaryColor: string) => createThemeVariables({ theme: 'dark', paletteStyle, primaryColor })[('--' + role) as `--${string}`];
    expect(new Set(styles.map(style => status(style, '#5962F0'))).size).toBe(4);
    expect(status('smooth', '#5962F0')).not.toBe(status('smooth', '#22DD88'));
  }
});

test('each style uses its own status fills with the brand seed or an achromatic seed', () => {
  for (const style of ['smooth', 'neon', 'acid'] as const) {
    for (const seed of ['#5962F0', '#888888']) {
      const palette = brandPaletteVariables({ theme: 'light', primaryColor: seed, paletteStyle: style });
      for (const [role, fill] of Object.entries(tokens.statusPalettes[style])) expect(palette[`--${role}`]).toBe(fill);
    }
  }
});

test('brand buttons retain white labels through every state and palette style', () => {
  for (const theme of ['dark', 'light'] as const) {
    for (const paletteStyle of Object.keys(tokens.paletteStyles) as PaletteStyle[]) {
      const values = createThemeVariables({ theme, paletteStyle });
      expect(values['--primary-foreground']).toBe('#FFFFFF');
      for (const state of ['--primary', '--primary-hover', '--primary-active'] as const) {
        expect(contrast(values[state]!, '#FFFFFF')).toBeGreaterThanOrEqual(4.5);
      }
    }
  }
});

test('Neon preserves luminous seeds and separates control edges from the action fill', () => {
  for (const theme of ['light', 'dark'] as const) {
    const palette = brandPaletteVariables({ theme, primaryColor: '#0FFFE3', paletteStyle: 'neon' });
    expect(palette['--primary']).toBe('#0FFFE3');
    for (const role of ['--primary', '--primary-hover', '--primary-active'] as const) {
      expect(contrast(palette[role]!, palette['--primary-foreground']!)).toBeGreaterThanOrEqual(7);
    }
    for (const role of ['--background', '--card', '--secondary', '--accent'] as const) {
      expect(contrast(palette['--primary-edge']!, palette[role]!)).toBeGreaterThanOrEqual(3);
    }
    const deep = brandPaletteVariables({ theme, primaryColor: '#307066', paletteStyle: 'contrast' });
    expect(deep['--primary-foreground']).toBe('#FFFFFF');
  }
});

test('teal and warm profiles keep distinct interaction states and semantic companions', () => {
  for (const paletteStyle of Object.keys(tokens.paletteStyles) as PaletteStyle[]) {
    const brand = brandPaletteVariables({ theme: 'light', paletteStyle });
    for (const primaryColor of ['#307066', '#D87544']) {
      const light = brandPaletteVariables({ theme: 'light', primaryColor, paletteStyle });
      const dark = brandPaletteVariables({ theme: 'dark', primaryColor, paletteStyle });
      for (const palette of [light, dark]) {
        const states = ['--primary', '--primary-hover', '--primary-active'] as const;
        expect(new Set(states.map(role => palette[role])).size).toBe(3);
        for (const role of states) expect(contrast(palette[role]!, palette['--primary-foreground']!)).toBeGreaterThanOrEqual(4.5);
      }
      for (const role of ['success', 'info', 'warning', 'error'] as const) {
        expect(light[`--${role}`]).toBe(dark[`--${role}`]);
        expect(light[`--${role}`]).not.toBe(brand[`--${role}`]);
      }
    }
  }
});

test('status fills stay continuous across hue stops, the red seam and nearly gray seeds', () => {
  for (const [first, second] of [
    ['#C48354', '#C48254'], ['#307065', '#307066'], ['#5962EF', '#5962F0'],
    ['#C74041', '#C74140'], ['#808182', '#828180'],
  ] as const) {
    for (const paletteStyle of Object.keys(tokens.paletteStyles) as PaletteStyle[]) {
      const firstPalette = brandPaletteVariables({ theme: 'light', primaryColor: first, paletteStyle });
      const secondPalette = brandPaletteVariables({ theme: 'light', primaryColor: second, paletteStyle });
      for (const role of ['--success', '--info', '--warning', '--error'] as const) {
        for (const start of [1, 3, 5]) {
          const channel = (hex: string) => parseInt(hex.slice(start, start + 2), 16);
          expect(Math.abs(channel(firstPalette[role]!) - channel(secondPalette[role]!))).toBeLessThanOrEqual(5);
        }
      }
    }
  }
});

test('palette output matches the same vectors used by Flutter', () => {
  for (const { theme, paletteStyle, primaryColor, roles } of fixtures) {
    const css = createThemeVariables({ theme: theme as 'light' | 'dark', paletteStyle: paletteStyle as PaletteStyle, primaryColor });
    for (const [role, value] of Object.entries(roles)) expect(css[`--${role}`]).toBe(value);
  }
});
