import type { Locale } from '../site';
import pass from './pass-messages.json';
const passLocales: Locale[] = ['en','ru','zh-Hans','hi','es','ar','fr','pt-BR','de','ja','tr','he'];
const dictionaries=import.meta.glob<Record<string,string>>('./catalogue-*.json',{import:'default'});
export async function catalogueMessages(locale:Locale):Promise<Record<string,string>> {
  if (locale === 'en') return {};
  const messages = await dictionaries[`./catalogue-${locale}.json`]();
  const index = passLocales.indexOf(locale);
  return { ...messages, ...Object.fromEntries(Object.entries(pass).map(([key, row]) => [key, row[index]])) };
}
