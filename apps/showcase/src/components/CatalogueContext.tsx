import { createContext } from 'react';
import type { Category } from '../catalogue';
export const CatalogueContext = createContext<Category>('foundation');
