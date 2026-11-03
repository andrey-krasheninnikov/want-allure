import { useContext, useRef, type ReactNode } from 'react';
import { CatalogueContext } from './CatalogueContext';
import type { Category } from '../catalogue';

export function Section({ title, children, category = 'foundation' }: { title: string; children: ReactNode; category?: Category }) {
  const active = useContext(CatalogueContext);
  const visited = useRef(false);
  if (active === category) visited.current = true;
  if (!visited.current) return null;
  return <section className="kit-section" hidden={active !== category}><h2>{title}</h2>{children}</section>;
}
