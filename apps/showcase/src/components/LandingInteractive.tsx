import React, { useEffect, useRef, useState } from 'react';
import { Pause, Play, Check, Copy } from 'lucide-react';
import { Button, Glow, LightningBackground, Accordion, AccordionItem, AccordionTrigger, AccordionContent } from '@want-foundation/allure-react';
import { copy, route, type Locale } from '../site';
import { FrameworkLogo } from './FrameworkLogo';
import LogoStage from './LogoStage';

function useMotion(element: React.RefObject<HTMLElement|null>) {
  const [paused,setPaused]=useState(true);
  useEffect(()=>{
    let visible=false;
    const sync=()=>setPaused(!visible||document.hidden||document.documentElement.dataset.motionPaused==='true');
    const observer=new IntersectionObserver(entries=>{visible=entries[0].isIntersecting;sync();});
    if(element.current)observer.observe(element.current);
    document.addEventListener('visibilitychange',sync);addEventListener('want:motion',sync);
    return()=>{observer.disconnect();document.removeEventListener('visibilitychange',sync);removeEventListener('want:motion',sync);};
  },[element]);
  return paused;
}
export function ExploreLinks({locale,only}:{locale:Locale;only?:'react'|'flutter'}) {
  const host=useRef<HTMLDivElement>(null),paused=useMotion(host),c=copy[locale];
  return <div className="landing-actions" ref={host}>{(['react','flutter'] as const).filter(item=>!only||item===only).map(item=><span className="glow-host cta-glow" key={item}><Glow paused={paused}/><Button asChild><a href={route(locale,item)}><FrameworkLogo framework={item} size={20}/>{c[item]}</a></Button></span>)}</div>;
}
export function HeroExperience({locale}:{locale:Locale}) {
  const host=useRef<HTMLElement>(null),paused=useMotion(host),[manualPause,setManualPause]=useState(false),c=copy[locale];
  return <section className="landing-hero" ref={host}>
    <LightningBackground paused={paused}/>
    <div className="hero-heading"><p className="eyebrow">DESIGN SYSTEM / REACT + FLUTTER</p><h1>{locale==='ru'?'Один язык.':'One language.'}<br/><span>{locale==='ru'?'Любой интерфейс.':'Every interface.'}</span></h1></div>
    <LogoStage locale={locale}/>
    <div className="hero-note"><p>{c.intro}</p><ExploreLinks locale={locale}/><button className="motion-control" aria-pressed={manualPause} onClick={()=>{const next=!manualPause;setManualPause(next);document.documentElement.dataset.motionPaused=String(next);dispatchEvent(new Event('want:motion'));}}>{manualPause?<Play size={16}/>:<Pause size={16}/>}<span>{locale==='ru'?(manualPause?'Продолжить эффекты':'Пауза эффектов'):(manualPause?'Resume effects':'Pause effects')}</span></button></div>
    <div className="hero-spec"><span>Days One × Manrope</span><span>primary + warning</span><span>React / Flutter</span></div>
  </section>;
}
export function CopyCommand({command,locale}:{command:string;locale:Locale}) {
  const [state,setState]=useState<'idle'|'copied'|'failed'>('idle');const timer=useRef<ReturnType<typeof setTimeout>|undefined>(undefined);
  useEffect(()=>()=>clearTimeout(timer.current),[]);
  const label=locale==='ru'?'Скопировать команду':'Copy command';
  return <div className="command"><pre tabIndex={0}><code>{command}</code></pre><Button variant="ghost" size="icon" aria-label={label} onClick={async()=>{try{await navigator.clipboard.writeText(command);setState('copied');}catch{setState('failed');}clearTimeout(timer.current);timer.current=setTimeout(()=>setState('idle'),2500);}}>{state==='copied'?<Check size={18}/>:<Copy size={18}/>}</Button><span className="command-status" role="status">{state==='copied'?(locale==='ru'?'Скопировано':'Copied'):state==='failed'?(locale==='ru'?'Выделите и скопируйте команду':'Select and copy the command'):''}</span></div>;
}
export function LandingFaq({locale}:{locale:Locale}) {
  return <Accordion type="single" collapsible className="faq-list">{copy[locale].questions.map(([question,answer],index)=><AccordionItem value={String(index)} key={question}><AccordionTrigger>{question}</AccordionTrigger><AccordionContent forceMount><p>{answer}</p></AccordionContent></AccordionItem>)}</Accordion>;
}
