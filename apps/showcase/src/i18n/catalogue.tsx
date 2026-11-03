import { createContext, useContext, useMemo, type ReactNode } from 'react';
import type { Locale } from '../site';
type Messages = Record<string,string>;
const LocaleContext = createContext<{locale:Locale;messages:Messages}>({locale:'en',messages:{}});
export function CatalogueLocaleProvider({locale,messages={},children}:{locale:Locale;messages?:Messages;children:ReactNode}) {
  return <LocaleContext.Provider value={{locale,messages}}>{children}</LocaleContext.Provider>;
}
export function useCatalogueLocale() { return useContext(LocaleContext).locale; }
export function translate(messages:Messages,text:string):string { const key=text.trim();return messages[key]?text.replace(key,messages[key]):text; }
export function useT() { const {messages}=useContext(LocaleContext);return useMemo(()=>(text:string)=>translate(messages,text),[messages]); }
