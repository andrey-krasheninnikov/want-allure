import { parseBrandProfile, isSupportedPrimaryColor, tokens, type AllureBrandProfileV1, type PaletteStyle, type TypographyPreset } from '@want-foundation/allure';

export const paletteStyles = Object.keys(tokens.paletteStyles) as PaletteStyle[];
export const typographyPresets = Object.keys(tokens.typography.presets) as TypographyPreset[];
export const localeFlags: Record<string, string> = {
  en: '🇬🇧', 'zh-Hans': '🇨🇳', hi: '🇮🇳', es: '🇪🇸', ar: '🇸🇦', fr: '🇫🇷',
  'pt-BR': '🇧🇷', ru: '🇷🇺', de: '🇩🇪', ja: '🇯🇵', tr: '🇹🇷', he: '🇮🇱',
};

export type Appearance = {
  primaryColor: string;
  paletteStyle: PaletteStyle;
  typographyPreset: TypographyPreset;
};

export const defaultAppearance: Readonly<Appearance> = {
  primaryColor: tokens.themes.wallpapers.dark.primary,
  paletteStyle: 'contrast',
  typographyPreset: 'brand',
};

export function isBrandColor(value: unknown): value is string {
  return typeof value === 'string' && /^#[0-9a-f]{6}$/i.test(value);
}

export function normalizeAppearance(value: unknown): Appearance {
  const data = value && typeof value === 'object' ? value as Record<string, unknown> : {};
  return {
    primaryColor: typeof data.primaryColor === 'string' && isSupportedPrimaryColor(data.primaryColor)
      ? data.primaryColor.toUpperCase() : defaultAppearance.primaryColor,
    paletteStyle: paletteStyles.find(style => style === data.paletteStyle) ?? defaultAppearance.paletteStyle,
    typographyPreset: typographyPresets.find(preset => preset === data.typographyPreset) ?? defaultAppearance.typographyPreset,
  };
}

export function documentAppearance(): Appearance {
  const data = document.documentElement.dataset;
  const saved = normalizeAppearance({ paletteStyle: data.paletteStyle, typographyPreset: data.typography });
  return { ...saved, primaryColor: isBrandColor(data.primaryColor) ? data.primaryColor.toUpperCase() : saved.primaryColor };
}

export function typographyNames(preset: TypographyPreset, language: string) {
  const label = tokens.typography.presets[preset];
  const script: Record<string, string> = { ja: 'Noto Sans JP', zh: 'Noto Sans SC', ar: 'Noto Sans Arabic', he: 'Noto Sans Hebrew', hi: 'Noto Sans Devanagari' };
  const local = script[language];
  const overrides: Record<string, string> = label.localDisplay;
  return [
    overrides[language] ?? local ?? label.display,
    local ?? (language === 'ru' && preset === 'humanist' ? 'Manrope' : label.body),
  ] as const;
}

export const brandProfileKey = 'want-brand-profile-v1';

export function profileFromAppearance(appearance: Appearance): AllureBrandProfileV1 {
  return { schemaVersion: 1, brandColor: appearance.primaryColor, paletteStyle: appearance.paletteStyle, typographyPreset: appearance.typographyPreset };
}

export function documentProfile(): AllureBrandProfileV1 {
  try {
    const stored = document.documentElement.dataset.brandProfile;
    if (stored) return parseBrandProfile(JSON.parse(stored));
  } catch { /* Legacy preferences still work when a profile is unavailable. */ }
  return profileFromAppearance(documentAppearance());
}
