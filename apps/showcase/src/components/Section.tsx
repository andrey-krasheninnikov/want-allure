import { FamilyGuide } from './CatalogueGuide';
import { useCatalogueLocale } from '../i18n/catalogue';
import { useContext, useRef, type ReactNode } from 'react';
import { CatalogueContext } from './CatalogueContext';
import type { Category } from '../catalogue';

export function Section({ title, children, guide, category = 'foundation' }: { title: string; guide?:string; children: ReactNode; category?: Category }) {
  const locale=useCatalogueLocale();
  const active = useContext(CatalogueContext);
  const visited = useRef(false);
  if (active === category) visited.current = true;
  if (!visited.current) return null;
  return <section className="kit-section" hidden={active !== category}><h2>{title}</h2>{children}{guide&&<FamilyGuide guide={guide} locale={locale}/>}</section>;
}
