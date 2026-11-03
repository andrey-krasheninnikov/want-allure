import { createContext, useContext, useMemo, type ReactNode } from 'react';
import ru from './ru.json';
import type { Locale } from '../site';
const LocaleContext = createContext<Locale>('en');
export function CatalogueLocaleProvider({ locale, children }: { locale: Locale; children: ReactNode }) {
  return <LocaleContext.Provider value={locale}>{children}</LocaleContext.Provider>;
}
export function useCatalogueLocale() { return useContext(LocaleContext); }
export function translate(locale: Locale, text: string): string {
  const key = text.trim();
  const translated = locale === 'ru' ? ru[key as keyof typeof ru] : undefined;
  return translated ? text.replace(key, translated) : text;
}
export function useT() {
  const locale = useCatalogueLocale();
  return useMemo(() => (text: string) => translate(locale, text), [locale]);
}
