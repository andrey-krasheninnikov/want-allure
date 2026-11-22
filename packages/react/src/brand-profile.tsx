import { createContext, useContext, useMemo, useState, type ComponentPropsWithoutRef, type ComponentType, type CSSProperties } from 'react';
import { resolveBrandProfile, tokens, type AllureBrandProfileV1 } from '@want-foundation/allure';
import type { LucideProps } from 'lucide-react';
import { DirectionProvider } from './direction-provider.js';

export type AllureResources = {
  fonts?: Readonly<Record<string, string>>;
  logos?: Readonly<Record<string, string>>;
  icons?: Readonly<Record<string, ComponentType<LucideProps>>>;
};
type Scope = { profile: AllureBrandProfileV1; mode: 'light' | 'dark'; resources?: AllureResources; host: HTMLDivElement | null };
const BrandContext = createContext<Scope | undefined>(undefined);
export function useAllureBrand() { return useContext(BrandContext); }
export function usePortalHost() { return useAllureBrand()?.host; }

export type AllureProviderProps = Omit<ComponentPropsWithoutRef<'div'>, 'dir'> & {
  profile: AllureBrandProfileV1;
  mode: 'light' | 'dark';
  locale?: string;
  dir?: 'ltr' | 'rtl';
  resources?: AllureResources;
};

export function lookupResource<T>(resources: Readonly<Record<string, T>> | undefined, id: string | undefined) {
  return resources && id && Object.hasOwn(resources, id) ? resources[id] : undefined;
}

const fontVariables = {
  display: '--font-display', body: '--font-sans', mono: '--font-mono', ja: '--want-font-japanese',
  zh: '--want-font-chinese', ar: '--want-font-arabic', hi: '--want-font-devanagari', he: '--want-font-hebrew',
} as const;

export function AllureProvider({ profile: input, mode, resources, locale, dir, style, children, ...props }: AllureProviderProps) {
  const [host, setHost] = useState<HTMLDivElement | null>(null);
  const profile = input;
  const theme = useMemo(() => {
    const variables = { ...resolveBrandProfile(profile, mode) };
    const defaults = tokens.typography;
    const stacks = {display:defaults.display, sans:defaults.body, mono:defaults.mono, japanese:defaults.japanese,
      chinese:defaults.chinese, arabic:defaults.arabic, devanagari:defaults.devanagari, hebrew:defaults.hebrew};
    for (const [name, families] of Object.entries(stacks)) {
      variables['--want-font-' + name] = families.map(family => family.includes(' ') ? JSON.stringify(family) : family).join(',');
    }
    if (!profile.typographyPreset || profile.typographyPreset === 'brand') {
      variables['--font-display'] = 'var(--want-font-display)';
      variables['--font-sans'] = 'var(--want-font-sans)';
      variables['--want-heading-weight'] = String(defaults.presets.brand.weight);
    }
    variables['--font-mono'] = 'var(--want-font-mono)';
    for (const [role, variable] of Object.entries(fontVariables)) {
      const id = profile.fonts?.[role as keyof typeof fontVariables];
      const font = lookupResource(resources?.fonts, id);
      if (font) variables[variable] = font;
    }
    return variables;
  }, [profile, mode, resources?.fonts]);
  const context = useMemo(() => ({ profile, mode, resources, host }), [profile, mode, resources, host]);
  const content = <div {...props} ref={setHost} data-allure-scope="" data-theme={mode}
    data-typography={profile.typographyPreset ?? 'brand'} data-density={profile.density ?? 'comfortable'} data-surface={profile.surface ?? 'soft'}
    data-motion={profile.motion ?? 'standard'} dir={dir} lang={locale ?? props.lang} style={{ colorScheme: mode, ...theme, ...style } as CSSProperties}>{children}</div>;
  return <BrandContext.Provider value={context}>{dir ? <DirectionProvider dir={dir}>{content}</DirectionProvider> : content}</BrandContext.Provider>;
}
