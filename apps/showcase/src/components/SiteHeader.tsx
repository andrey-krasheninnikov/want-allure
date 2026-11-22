import React, { useEffect, useState } from 'react';
import { Menu } from 'lucide-react';
import { Button, LanguagePicker, ThemeIcon,
  Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription, SheetTrigger, Switch, DirectionProvider } from '@want-foundation/allure-react';
import { copy, route, siteText, locales, localeNames, type Locale, type Section } from '../site';
import AppearancePreferences, { SiteThemePicker } from './AppearancePreferences';
import { localeFlags } from '../appearance';

const languages = locales.map(value => ({
  value, name: localeNames[value], flag: localeFlags[value]!, code: value.split('-')[0]!.toUpperCase()
}));
export default function SiteHeader({locale, section, notFound=false}:{locale:Locale;section:Section;notFound?:boolean}): React.JSX.Element {
  const c=copy[locale],t=(text:string)=>siteText(locale,text);
  const [rtl,setRtl]=useState(false);
  const [selection,setSelection]=useState('');
  const [open,setOpen]=useState(false);
  useEffect(()=>{
    const update=()=>{setRtl(document.documentElement.dir==='rtl');const params=new URLSearchParams(location.search);const filtered=new URLSearchParams();for(const key of ['section','component','studio']) if(params.has(key)) filtered.set(key,params.get(key)!);setSelection(filtered.toString());};
    update(); for(const event of ['want:theme','want:direction','want:section']) addEventListener(event,update);
    dispatchEvent(new Event('want:header-ready'));
    return()=>{for(const event of ['want:theme','want:direction','want:section']) removeEventListener(event,update);};
  },[]);
  const href=(target:Section,language=locale)=>route(language,target)+(target!=='home'&&selection?'?'+selection:'');
  const links=<nav className="site-nav" aria-label={c.navigation}>{(['home','react','flutter'] as const).map(item=><a key={item} href={href(item)} aria-current={section===item&&!notFound?'page':undefined} onClick={()=>setOpen(false)}>{item==='home'?c.home:item==='react'?'React':'Flutter'}</a>)}<a href="https://github.com/andrey-krasheninnikov/want-allure" aria-label="GitHub"><span>GitHub</span></a></nav>;
  return <DirectionProvider dir={rtl?'rtl':'ltr'}><header className="site-header" data-page={section}><div className="header-bar glass-surface">
    <a className="site-brand" href={href('home')} aria-label="Want Allure"><img className="logo-light" src="/brand/logos/light/transparent.svg" alt="" width="32" height="32"/><img className="logo-dark" src="/brand/logos/dark/transparent.svg" alt="" width="32" height="32"/><span>Want <span className="brand-product">Allure</span></span></a>
    <div className="desktop-navigation">{links}</div>
    <div className="site-preferences">
      <AppearancePreferences locale={locale} />
      <label className="header-rtl" title={t('Right to left')}><Switch checked={rtl} onCheckedChange={value=>dispatchEvent(new CustomEvent('want:choose-direction',{detail:value?'rtl':'ltr'}))} aria-label={t('Right to left')} size="sm"/><span>RTL</span></label>
      <SiteThemePicker locale={locale} />
      <LanguagePicker label={t('Language')} value={locale} options={languages} onChange={value=>{location.href=href(section,value);}} />
      <Sheet open={open} onOpenChange={setOpen}><SheetTrigger asChild><Button variant="ghost" size="icon" className="mobile-menu" aria-label={c.navigation}><ThemeIcon icon={Menu} size={20}/></Button></SheetTrigger><SheetContent closeLabel={t('Close')} side={rtl?'left':'right'}><SheetHeader><SheetTitle>{c.navigation}</SheetTitle><SheetDescription>{c.catalogue}</SheetDescription></SheetHeader>{links}</SheetContent></Sheet>
    </div>
  </div></header></DirectionProvider>;
}
