import { useEffect, useState, type MouseEvent } from 'react';
import { Input } from '@want-foundation/allure-react';
import entries from '../i18n/component-guide.json';
import { categories, categoryCopy, type Category } from '../catalogue';
import { route, siteText, type Locale } from '../site';
import { studioText } from '../i18n/studio';

type Family = typeof entries[number];
type Framework = 'react' | 'flutter';
const lookup = new Map(entries.map(family=>[family.id,family]));
const href=(locale:Locale,framework:Framework,family:Family)=>{
  const params=new URLSearchParams({section:family.section,component:family.id});
  return route(locale,framework)+'?'+params;
};

function select(event:MouseEvent<HTMLAnchorElement>, family:Family) {
  if(event.button || event.ctrlKey || event.metaKey || event.altKey || event.shiftKey)return;
  event.preventDefault();
  dispatchEvent(new CustomEvent('want:choose-section',{detail:{section:family.section,component:family.id}}));
}

function Example({family,locale,framework}:{family:Family;locale:Locale;framework:Framework}) {
  const names=Array.from(new Set(Array.from(family.react.matchAll(/<([A-Z]\w*)/g),m=>m[1])));
  const other=framework==='react'?'flutter':'react';
  return <div className="catalogue-example">
    <div className="catalogue-example-title"><strong dir="ltr">{family.id}</strong>
      <a href={href(locale,other,family)}>{other==='flutter'?'Flutter':'React'} ↗</a></div>
    <pre dir="ltr"><code>{framework==='react'
      ? "import { "+names.join(', ')+" } from '@want-foundation/allure-react';\n\n"+family.react
      : "import 'package:want_allure/want_allure.dart';\n\n"+family.dart}</code></pre>
    <p dir="ltr">{family.states}</p>
  </div>;
}

export function FamilyGuide({guide,locale}:{guide:string;locale:Locale}) {
  const main=lookup.get(guide);
  const [component,setComponent]=useState<string|null>(null),[open,setOpen]=useState(false);
  useEffect(()=>{
    const update=()=>setComponent(new URLSearchParams(location.search).get('component'));
    update();addEventListener('want:section',update);return()=>removeEventListener('want:section',update);
  },[]);
  const selected=lookup.get(component??'');
  useEffect(()=>{if(selected && main?.title===selected.title)setOpen(true);},[selected,main]);
  useEffect(()=>{
    if(!open || !selected || main?.title!==selected.title)return;
    const target=document.getElementById('api-'+selected.id);
    target?.focus({preventScroll:true});target?.scrollIntoView({block:'nearest'});
  },[open,selected,main]);
  if(!main)return null;
  const families=entries.filter(entry=>entry.title===main.title);
  return <details className="catalogue-api" open={open} onToggle={event=>setOpen(event.currentTarget.open)}>
    <summary>API · {families.map(item=>item.id).join(' / ')}</summary>
    {open&&families.map(family=><section key={family.id} id={'api-'+family.id} tabIndex={-1} aria-label={family.id}>
      <Example family={family} locale={locale} framework="react"/>
      <a href={href(locale,'react',family)} onClick={event=>select(event,family)}>{family.id} · URL</a>
    </section>)}
  </details>;
}

export function CatalogueFinder({locale,framework,messages={}}:{locale:Locale;framework:Framework;messages?:Record<string,string>}) {
  const [query,setQuery]=useState(''),[selected,setSelected]=useState('');
  const [expanded,setExpanded]=useState(false);
  useEffect(()=>{
    const update=()=>{
      const id=new URLSearchParams(location.search).get('component')??'';
      setSelected(id);setExpanded(false);setQuery('');
    };
    update();addEventListener('want:section',update);return()=>removeEventListener('want:section',update);
  },[framework]);
  const family=lookup.get(selected);
  const needle=query.trim().toLocaleLowerCase(locale);
  const matches=entries.filter(item=>[item.id,item.title,messages[item.title],item.example,...item.flutter].filter(Boolean)
    .some(value=>value.toLocaleLowerCase(locale).includes(needle)));
  return <div className="catalogue-finder">
    <label><span>{studioText(locale,'search')}</span><Input type="search" autoComplete="off" value={query} onFocus={()=>setExpanded(true)}
      onChange={e=>{setQuery(e.currentTarget.value);setExpanded(true);}} onKeyDown={e=>{if(e.key==='Escape'){setExpanded(false);setQuery('');}}}
      placeholder="Button, WantTable…" /></label>
    {expanded&&query.trim()&&<><span className="sr-only" role="status">{new Intl.NumberFormat(locale).format(matches.length)}</span>
      {matches.length?<ul>{matches.map(item=><li key={item.id}><a href={href(locale,framework,item)} onClick={e=>select(e,item)}>
        <bdi>{framework==='react'?item.id:item.flutter[0]}</bdi><small>{siteText(locale,categoryCopy.en[categories.indexOf(item.section as Category)])}</small></a></li>)}</ul>
      :<p role="status">{studioText(locale,'empty')}</p>}</>}
    {framework==='flutter'&&family&&<details key={family.id} open className="catalogue-api"><summary>API · {family.flutter[0]}</summary>
      <Example family={family} framework={framework} locale={locale}/></details>}
  </div>;
}
