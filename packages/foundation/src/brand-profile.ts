import tokens from '../tokens.json';
import schema from '../brand-profile.schema.json';
import { brandPaletteVariables, colorContrast, type PaletteStyle, type TypographyPreset, type ThemeOptions } from './appearance.js';

export type BrandColorRole = keyof typeof tokens.themes.wallpapers.light;
export type AllureBrandProfileV1 = {
  schemaVersion: 1;
  brandColor?: string;
  paletteStyle?: PaletteStyle;
  typographyPreset?: TypographyPreset;
  colors?: Partial<Record<ThemeOptions['theme'], Partial<Record<BrandColorRole, string>>>>;
  radii?: Partial<Record<'field' | 'panel' | 'media' | 'action', number>>;
  density?: 'comfortable' | 'compact';
  surface?: 'flat' | 'soft' | 'glass';
  fonts?: Partial<Record<'display' | 'body' | 'mono' | 'ja' | 'zh' | 'ar' | 'hi' | 'he', string>>;
  icons?: Record<string, string>;
  logos?: Partial<Record<'light' | 'dark' | 'mark', string>>;
  motion?: 'standard' | 'quiet' | 'off';
};

type Rule = {
  type?: string; const?: number; enum?: string[]; $ref?: string;
  properties?: Record<string, Rule>; required?: string[]; additionalProperties?: Rule | boolean;
  propertyNames?: Rule; pattern?: string; minLength?: number; maxLength?: number; minimum?: number; maximum?: number;
};

function check(value: unknown, rule: Rule, path: string): void {
  const fail = (reason: string): never => { throw new RangeError(path + ': ' + reason); };
  if (rule.$ref) return check(value, schema.$defs[rule.$ref.slice('#/$defs/'.length) as keyof typeof schema.$defs], path);
  if (rule.const !== undefined && value !== rule.const) fail('expected ' + rule.const);
  if (rule.enum && !rule.enum.includes(value as string)) fail('expected ' + rule.enum.join(' | '));
  if (rule.type === 'number' && (typeof value !== 'number' || !Number.isFinite(value) || value < rule.minimum! || value > rule.maximum!)) fail('expected 0–999');
  if (rule.type === 'string' && (typeof value !== 'string' || !new RegExp(rule.pattern!).test(value) || (rule.maxLength && [...value].length > rule.maxLength))) fail(rule.maxLength ? 'expected a resource ID of 1–128 characters without surrounding whitespace' : 'expected #RRGGBB');
  if (rule.type !== 'object') return;
  if (!value || typeof value !== 'object' || Array.isArray(value) || ![null, Object.prototype].includes(Object.getPrototypeOf(value))) fail('expected a JSON object');
  const fields = value as Record<string, unknown>;
  for (const key of rule.required ?? []) if (!Object.hasOwn(fields, key)) fail('missing ' + key);
  for (const [key, child] of Object.entries(fields)) {
    const childPath = path + '.' + key;
    if (rule.propertyNames) check(key, rule.propertyNames, childPath);
    const next = rule.properties && Object.hasOwn(rule.properties, key) ? rule.properties[key] : rule.additionalProperties;
    if (!next || typeof next !== 'object') throw new RangeError(childPath + ': unknown key');
    check(child, next, childPath);
  }
}

function resolveColors(profile: AllureBrandProfileV1, theme: ThemeOptions['theme']) {
  const result: Record<string, string> = brandPaletteVariables({ theme, primaryColor: profile.brandColor, paletteStyle: profile.paletteStyle });
  const overrides = profile.colors?.[theme] ?? {};
  for (const [name, color] of Object.entries(overrides)) result['--' + name] = color;
  const pair = (ink: string, fill: string, minimum = 4.5) => {
    if (!Object.hasOwn(overrides, ink) && !Object.hasOwn(overrides, fill)) return;
    if (colorContrast(result['--' + ink]!, result['--' + fill]!) < minimum) {
      const key = Object.hasOwn(overrides, ink) ? ink : fill;
      throw new RangeError('colors.' + theme + '.' + key + ': ' + ink + ' / ' + fill + ' requires contrast ' + minimum + ':1');
    }
  };
  for (const role of ['card', 'popover', 'secondary', 'accent', 'muted', 'primary', 'destructive', 'success', 'warning', 'error', 'info']) pair(role + '-foreground', role);
  for (const role of ['success', 'warning', 'error', 'info']) pair(role + '-foreground', role + '-surface');
  for (const fill of ['background', 'card', 'secondary', 'popover', 'accent']) {
    for (const ink of ['link', 'primary-text', 'success-text', 'info-text', 'warning-text', 'error-text', 'destructive-text']) pair(ink, fill);
    for (const control of ['primary-edge', 'ring', 'input']) pair(control, fill, 3);
  }
  pair('foreground', 'background');
  pair('primary-foreground', 'primary-hover');
  pair('primary-foreground', 'primary-active');
  pair('primary-text', 'primary-soft');
  return result;
}

/** Validate the complete document before applying either theme. */
export function parseBrandProfile(input: unknown): AllureBrandProfileV1 {
  check(input, schema, 'profile');
  const profile = input as AllureBrandProfileV1;
  for (const theme of ['light', 'dark'] as const) if (profile.colors?.[theme]) resolveColors(profile, theme);
  return profile;
}

export function resolveBrandProfile(input: AllureBrandProfileV1, theme: ThemeOptions['theme']): Record<string, string> {
  const profile = parseBrandProfile(input);
  const colors = resolveColors(profile, theme);
  const radius = profile.radii ?? {};
  return {
    ...colors, '--brand-color': profile.brandColor ?? tokens.themes.wallpapers[theme].primary,
    '--radius': (radius.field ?? tokens.geometry.fieldRadiusPx) + 'px',
    '--panel-radius': (radius.panel ?? tokens.geometry.panelRadiusPx) + 'px',
    '--media-radius': (radius.media ?? tokens.geometry.mediaRadiusPx) + 'px',
    '--allure-action-radius': (radius.action ?? 999) + 'px',
  };
}
