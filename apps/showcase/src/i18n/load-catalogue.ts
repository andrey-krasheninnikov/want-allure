import type { Locale } from '../site';
const dictionaries=import.meta.glob<Record<string,string>>('./catalogue-*.json',{import:'default'});
export async function catalogueMessages(locale:Locale):Promise<Record<string,string>> {
  return locale==='en'?{}:await dictionaries[`./catalogue-${locale}.json`]();
}
