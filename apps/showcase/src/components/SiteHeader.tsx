import React, { useEffect, useState } from 'react';
import { Menu } from 'lucide-react';
import { Button, ThemeToggle, Select, SelectContent, SelectGroup, SelectItem, SelectTrigger, SelectValue,
  Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription, SheetTrigger, Switch, DirectionProvider } from '@want-foundation/allure-react';
import { copy, route, siteText, locales, localeNames, type Locale, type Section } from '../site';
import { categoryOf } from '../catalogue';
export default function SiteHeader({locale, section, notFound=false}:{locale:Locale;section:Section;notFound?:boolean}): React.JSX.Element {
  const c=copy[locale],t=(text:string)=>siteText(locale,text);
  const [theme,setTheme]=useState<'light'|'dark'>('dark');
  const [rtl,setRtl]=useState(false);
  const [category,setCategory]=useState('foundation');
  const [open,setOpen]=useState(false);
  useEffect(()=>{
    const update=()=>{setTheme(document.documentElement.dataset.theme==='light'?'light':'dark');setRtl(document.documentElement.dir==='rtl');setCategory(categoryOf(new URLSearchParams(location.search).get('section')));};
    update(); for(const event of ['want:theme','want:direction','want:section']) addEventListener(event,update);
    return()=>{for(const event of ['want:theme','want:direction','want:section']) removeEventListener(event,update);};
  },[]);
  const href=(target:Section,language=locale)=>route(language,target)+(target!=='home'&&category!=='foundation'?`?section=${category}`:'');
  const links=<nav className="site-nav" aria-label={c.navigation}>{(['home','react','flutter'] as const).map(item=><a key={item} href={href(item)} aria-current={section===item&&!notFound?'page':undefined} onClick={()=>setOpen(false)}>{item==='home'?c.home:item==='react'?'React':'Flutter'}</a>)}<a href="https://github.com/andrey-krasheninnikov/want-allure" aria-label="GitHub"><span>GitHub</span></a></nav>;
  return <DirectionProvider dir={rtl?'rtl':'ltr'}><header className="site-header"><div className="header-bar glass-surface">
    <a className="site-brand" href={href('home')} aria-label="Want Allure"><img className="logo-light" src="/brand/logos/light/transparent.svg" alt="" width="32" height="32"/><img className="logo-dark" src="/brand/logos/dark/transparent.svg" alt="" width="32" height="32"/><span>Want <span className="brand-product">Allure</span></span></a>
    <div className="desktop-navigation">{links}</div>
    <div className="site-preferences">
      <label className="header-rtl" title={t('Right to left')}><Switch checked={rtl} onCheckedChange={value=>dispatchEvent(new CustomEvent('want:choose-direction',{detail:value?'rtl':'ltr'}))} aria-label={t('Right to left')} size="sm"/><span>RTL</span></label>
      <ThemeToggle theme={theme} label={c.theme} title={t(theme==='dark'?'Light theme':'Dark theme')} onThemeChange={value=>dispatchEvent(new CustomEvent('want:choose-theme',{detail:value}))}/>
      <Select value={locale} onValueChange={value=>{location.href=href(section,value as Locale);}}><SelectTrigger aria-label={t('Language')} className="language-trigger"><SelectValue>{locale === 'zh-Hans' ? '中文' : locale === 'pt-BR' ? 'PT' : locale.toUpperCase()}</SelectValue></SelectTrigger><SelectContent><SelectGroup>{locales.map(language=><SelectItem key={language} value={language}><span lang={language} dir="auto">{localeNames[language]}</span></SelectItem>)}</SelectGroup></SelectContent></Select>
      <Sheet open={open} onOpenChange={setOpen}><SheetTrigger asChild><Button variant="ghost" size="icon" className="mobile-menu" aria-label={c.navigation}><Menu size={20}/></Button></SheetTrigger><SheetContent closeLabel={t('Close')} side={rtl?'left':'right'}><SheetHeader><SheetTitle>{c.navigation}</SheetTitle><SheetDescription>{c.catalogue}</SheetDescription></SheetHeader>{links}</SheetContent></Sheet>
    </div>
  </div></header></DirectionProvider>;
}
