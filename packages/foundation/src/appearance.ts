import tokens from '../tokens.json';

export type PaletteStyle = keyof typeof tokens.paletteStyles;
export type TypographyPreset = keyof typeof tokens.typography.presets;
export type ThemeOptions = {
  theme: 'light' | 'dark';
  primaryColor?: string;
  paletteStyle?: PaletteStyle;
};

type RGB = [number, number, number];
const rgb = (hex: string): RGB => [1, 3, 5].map(i => parseInt(hex.slice(i, i + 2), 16)) as RGB;
const hex = (value: RGB) => '#' + value.map(channel => channel.toString(16).padStart(2, '0')).join('').toUpperCase();
const black: RGB = [0, 0, 0], white: RGB = [255, 255, 255];
const clamp = (n: number) => Math.max(0, Math.min(1, n));
const unit = (channel: number) => channel / 255;
const linear = (v: number) => v <= .04045 ? v / 12.92 : ((v + .055) / 1.055) ** 2.4;
const luminance = (color: RGB) => color.map(unit).map(linear)
  .reduce((sum, value, i) => sum + value * [.2126, .7152, .0722][i]!, 0);
const contrast = (a: RGB, b: RGB) => {
  const x = luminance(a), y = luminance(b);
  return (Math.max(x, y) + .05) / (Math.min(x, y) + .05);
};
const mix = (a: RGB, b: RGB, weight: number) =>
  a.map((value, i) => Math.round(value + (b[i]! - value) * weight)) as RGB;

// Interpolate within each status family in linear light. Near-gray seeds keep the style defaults.
function harmonyWeights(hue: number, brandHue: number, seed: RGB) {
  const angle = (hue - 25 + 360) % 360;
  const teal = 170 - 25, brand = brandHue - 25;
  const strength = clamp((Math.max(...seed) - Math.min(...seed)) / 48);
  const ease = (t: number) => { const x = clamp(t); return strength * x * x * (3 - 2 * x); };
  return {
    warm: ease(angle < teal ? 1 - angle / teal : (angle - brand) / (360 - brand)),
    teal: ease(Math.min(angle / teal, (brand - angle) / (brand - teal))),
  };
}

function blendStatus(anchor: RGB, warm: RGB, teal: RGB, weights: { warm: number; teal: number }): RGB {
  return anchor.map((channel, i) => {
    const base = linear(unit(channel));
    const value = base + weights.warm * (linear(unit(warm[i]!)) - base) + weights.teal * (linear(unit(teal[i]!)) - base);
    const encoded = value <= .0031308 ? 12.92 * value : 1.055 * value ** (1 / 2.4) - .055;
    return Math.round(clamp(encoded) * 255);
  }) as RGB;
}

function hsl([red, green, blue]: RGB): [number, number, number] {
  const [r, g, b] = [red / 255, green / 255, blue / 255] as const;
  const min = Math.min(r, g, b), max = Math.max(r, g, b), delta = max - min;
  const lightness = (max + min) / 2;
  if (delta === 0) return [0, 0, lightness];
  const segment = max === r ? (g - b) / delta : max === g ? 2 + (b - r) / delta : 4 + (r - g) / delta;
  return [(segment * 60 + 360) % 360, delta / (1 - Math.abs(2 * lightness - 1)), lightness];
}

function fromHsl(hue: number, saturation: number, lightness: number): RGB {
  const c = (1 - Math.abs(2 * lightness - 1)) * saturation;
  const segment = ((hue % 360 + 360) % 360) / 60;
  const x = c * (1 - Math.abs(segment % 2 - 1));
  const m = lightness - c / 2;
  const channels = segment < 1 ? [c, x, 0] : segment < 2 ? [x, c, 0] : segment < 3 ? [0, c, x]
    : segment < 4 ? [0, x, c] : segment < 5 ? [x, 0, c] : [c, 0, x];
  return channels.map(value => Math.round(clamp(value + m) * 255)) as RGB;
}

function fit(hue: number, saturation: number, target: number, accepts: (color: RGB) => boolean, fallback: RGB): RGB {
  for (let step = 0; step <= 100; step++) {
    const down = fromHsl(hue, saturation, clamp(target - step / 100));
    if (accepts(down)) return down;
    if (!step) continue;
    const up = fromHsl(hue, saturation, clamp(target + step / 100));
    if (accepts(up)) return up;
  }
  return fallback;
}

export function isSupportedPrimaryColor(color: string): boolean {
  if (!/^#[0-9A-F]{6}$/i.test(color)) return false;
  const [, saturation, lightness] = hsl(rgb(color));
  const range = tokens.primaryRange;
  const tolerance = 1e-9;
  return saturation >= range.minSaturation - tolerance && saturation <= range.maxSaturation + tolerance
    && lightness >= range.minLightness - tolerance && lightness <= range.maxLightness + tolerance;
}

/** Resolve an opaque seed to semantic CSS colors. Call once per theme change. */
export function createThemeVariables(options: ThemeOptions) {
  if (options.primaryColor !== undefined && !isSupportedPrimaryColor(options.primaryColor)) {
    throw new RangeError('primaryColor must be #RRGGBB with HSL saturation 45–90% and lightness 40–70%');
  }
  return brandPaletteVariables(options);
}

/** WCAG contrast ratio between two opaque #RRGGBB colors, from 1 to 21. */
export function colorContrast(a: string, b: string): number {
  if (![a, b].every(value => /^#[0-9a-f]{6}$/i.test(value))) throw new RangeError('Expected two opaque #RRGGBB colors');
  return contrast(rgb(a), rgb(b));
}

export function brandPaletteVariables({ theme, primaryColor, paletteStyle = 'contrast' }: ThemeOptions): Record<`--${string}`, string> & { colorScheme: ThemeOptions['theme'] } {
  const base = tokens.themes.wallpapers[theme];
  const seed = primaryColor?.toUpperCase() ?? base.primary;
  if (!Object.hasOwn(tokens.paletteStyles, paletteStyle)) throw new RangeError('Unknown palette style');
  const variables = (values: Record<string, string>) => ({
    ...Object.fromEntries(Object.entries(values).map(([role, value]) => ['--' + role, value])),
    colorScheme: theme,
  });
  if (seed === base.primary && paletteStyle === 'contrast') return variables(base);

  const dark = theme === 'dark';
  const profile = tokens.paletteStyles[paletteStyle];
  const seedColor = rgb(seed);
  const [hue, saturation, lightness] = hsl(seedColor);
  const chroma = saturation === 0 ? 0 : clamp(Math.max(profile.saturationFloor, saturation * profile.saturation));
  const surfaces = [base.background, base.card, base.secondary, base.popover, base.accent].map(rgb);
  const onSurfaces = (color: RGB, minimum: number) => surfaces.every(surface => contrast(color, surface) >= minimum);
  const opposite = dark ? white : black;
  const target = clamp(lightness + profile.lightness);
  const graphite = rgb(tokens.themes.wallpapers.light.foreground);
  const vividSeed = paletteStyle === 'neon' && saturation >= profile.saturationFloor;
  const intended = vividSeed ? seedColor : fromHsl(hue, chroma, target);
  const bright = contrast(seedColor, white) < 4.5 && contrast(intended, graphite) >= 7;
  const ink = bright ? graphite : white;
  const minimum = bright ? 7 : 4.5;
  const primary = bright ? intended : fit(hue, chroma, target,
    color => contrast(color, ink) >= minimum && onSurfaces(color, 3),
    fit(hue, chroma, target, color => contrast(color, ink) >= minimum, black));
  const [, , primaryLightness] = hsl(primary);
  const edge = onSurfaces(primary, 3) ? primary : fit(hue, chroma, primaryLightness, color => onSurfaces(color, 3), opposite);
  const readableState = (color: RGB) => contrast(color, ink) >= minimum && (bright || onSurfaces(color, 3));
  const travel = (offset: number) => hsl(fit(hue, chroma, clamp(primaryLightness + offset), readableState, primary))[2] - primaryLightness;
  const preferred = -.08;
  let range = travel(preferred);
  if (Math.abs(range) < .07) {
    const reverse = travel(-preferred);
    if (Math.abs(reverse) > Math.abs(range)) range = reverse;
  }
  // At a contrast boundary, vary hue and saturation along the same ramp as lightness.
  const state = (fraction: number) => {
    const bend = fraction * (1 - clamp(Math.abs(range) / .08));
    return fit(hue + 20 * bend, chroma * (1 - .24 * bend), primaryLightness + fraction * range, readableState, primary);
  };
  const soft = mix(rgb(base.secondary), fromHsl(hue + profile.hueShift, chroma, primaryLightness), profile.softMix);
  const text = fit(hue, chroma, dark ? .76 : .34, color => onSurfaces(color, 4.5) && contrast(color, soft) >= 4.5, opposite);
  const ring = fit(hue + profile.hueShift, chroma, dark ? .72 : .37, color => onSurfaces(color, 3), opposite);
  const input = mix(rgb(base.input), rgb(profile.inputMix < 0 ? base.background : base.foreground), Math.abs(profile.inputMix));
  const statusColors: Record<string, string> = {};
  const [brandHue] = hsl(rgb(base.primary));
  const anchors = paletteStyle === 'contrast' ? base : tokens.statusPalettes[paletteStyle];
  const weights = harmonyWeights(hue, brandHue, seedColor);
  const { warm, teal } = tokens.statusHarmonies;
  for (const role of ['success', 'info', 'warning', 'error'] as const) {
    const surface = blendStatus(rgb(anchors[role]), rgb(warm[paletteStyle][role]), rgb(teal[paletteStyle][role]), weights);
    const [statusHue, statusSaturation, statusLightness] = hsl(surface);
    const preferredInk = rgb(base[(role + '-foreground') as keyof typeof base]);
    const inkOnFill = contrast(surface, preferredInk) >= 4.5 ? preferredInk
      : contrast(surface, black) >= contrast(surface, white) ? black : white;
    statusColors[role] = statusColors[role + '-surface'] = hex(surface);
    statusColors[role + '-foreground'] = hex(inkOnFill);
    statusColors[role + '-text'] = hex(fit(statusHue, statusSaturation, dark ? statusLightness : Math.min(statusLightness, .32),
      color => onSurfaces(color, 4.5), opposite));
  }
  return variables({
    ...base,
    ...statusColors,
    destructive: statusColors.error!,
    'destructive-foreground': statusColors['error-foreground']!,
    'destructive-text': statusColors['error-text']!,
    primary: hex(primary),
    'primary-edge': hex(edge),
    'primary-hover': hex(state(.5)),
    'primary-active': hex(state(1)),
    'primary-foreground': hex(ink),
    'primary-text': hex(text),
    link: hex(text),
    'primary-soft': hex(soft),
    ring: hex(ring),
    input: onSurfaces(input, 3) ? hex(input) : base.input,
  });
}
