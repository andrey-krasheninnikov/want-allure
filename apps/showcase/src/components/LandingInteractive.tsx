import React, { useEffect, useRef, useState } from 'react';
import { ArrowLeft, ArrowRight, ArrowUp, Check, Copy } from 'lucide-react';
import { Button, Glow, LightningBackground } from '@want-foundation/allure-react';
import { copy, route, siteText, version, type Locale } from '../site';
import { FrameworkLogo } from './FrameworkLogo';
import LogoStage from './LogoStage';

function useMotion(element: React.RefObject<HTMLElement|null>) {
  const [paused,setPaused]=useState(true);
  useEffect(()=>{
    let visible=false;const media=matchMedia('(prefers-reduced-motion: reduce)');
    const sync=()=>setPaused(!visible||document.hidden||media.matches);
    const observer=new IntersectionObserver(entries=>{visible=entries[0].isIntersecting;sync();});
    if(element.current)observer.observe(element.current);document.addEventListener('visibilitychange',sync);media.addEventListener('change',sync);
    return()=>{observer.disconnect();document.removeEventListener('visibilitychange',sync);media.removeEventListener('change',sync);};
  },[element]);return paused;
}
export function ExploreLinks({locale,only,icons=false}:{locale:Locale;only?:'react'|'flutter';icons?:boolean}) {
  const host=useRef<HTMLDivElement>(null),paused=useMotion(host),c=copy[locale];
  return <div className={`landing-actions ${icons?'icon-actions':''}`} ref={host}>{(['react','flutter'] as const).filter(item=>!only||item===only).map(item=><span className="glow-host cta-glow" key={item}><Glow paused={paused}/><Button asChild size={icons?'icon':'default'}><a href={route(locale,item)} aria-label={c[item]} title={c[item]}><FrameworkLogo framework={item} size={icons?26:20}/>{!icons&&c[item]}</a></Button></span>)}</div>;
}
function FireHeadline({locale}:{locale:Locale}) {
  const host=useRef<HTMLHeadingElement>(null),canvas=useRef<HTMLCanvasElement>(null);
  useEffect(()=>{
    const element=host.current!,surface=canvas.current!,context=surface.getContext('2d');if(!context)return;
    const media=matchMedia('(prefers-reduced-motion: reduce)');let animation=0,hitFrame=0,target:DOMRect|null=null;
    const highlights=(CSS as unknown as {highlights?:Map<string,unknown>}).highlights;
    const clear=()=>{target=null;highlights?.delete('want-fire-letter');cancelAnimationFrame(animation);animation=0;context.clearRect(0,0,160,160);};
    const paint=(now:number)=>{
      animation=0;if(!target||media.matches||document.hidden)return;
      context.clearRect(0,0,160,160);
      const color=getComputedStyle(element).getPropertyValue('--warning').trim();
      for(let i=0;i<7;i++){
        const wave=(now*.0007+i*.17)%1,x=80+Math.sin(now*.002+i*2)*19,y=118-wave*90,radius=24*(1-wave)+5;
        const gradient=context.createRadialGradient(x,y,0,x,y,radius);gradient.addColorStop(0,color);gradient.addColorStop(.35,color);gradient.addColorStop(1,'transparent');context.globalAlpha=(1-wave)*.58;context.fillStyle=gradient;context.beginPath();context.ellipse(x,y,radius*.65,radius*1.4,Math.sin(i)*.3,0,Math.PI*2);context.fill();
      }
      context.globalAlpha=1;animation=requestAnimationFrame(paint);
    };
    const move=(event:PointerEvent)=>{
      if(hitFrame)return;hitFrame=requestAnimationFrame(()=>{hitFrame=0;
        const doc=document as unknown as {caretPositionFromPoint?:(x:number,y:number)=>{offsetNode:Node;offset:number}|null;caretRangeFromPoint?:(x:number,y:number)=>Range|null};
        const position=doc.caretPositionFromPoint?.(event.clientX,event.clientY),range=doc.caretRangeFromPoint?.(event.clientX,event.clientY);
        const node=position?.offsetNode??range?.startContainer,offset=position?.offset??range?.startOffset??0;
        if(!node||node.nodeType!==Node.TEXT_NODE||!element.contains(node)){clear();return;}
        const text=node.textContent??'',segments=[...new Intl.Segmenter(locale,{granularity:'grapheme'}).segment(text)];
        const segment=segments.find(item=>offset>=item.index&&offset<item.index+item.segment.length)??segments.at(-1);if(!segment||!segment.segment.trim()){clear();return;}
        const active=document.createRange();active.setStart(node,segment.index);active.setEnd(node,segment.index+segment.segment.length);const rect=active.getBoundingClientRect();
        if(event.clientX<rect.left-4||event.clientX>rect.right+4||event.clientY<rect.top||event.clientY>rect.bottom){clear();return;}
        const HighlightClass=(window as unknown as {Highlight?:new(range:Range)=>unknown}).Highlight;if(highlights&&HighlightClass)highlights.set('want-fire-letter',new HighlightClass(active));
        target=rect;const outer=element.getBoundingClientRect();surface.style.left=`${rect.left-outer.left+rect.width/2-80}px`;surface.style.top=`${rect.top-outer.top+rect.height/2-100}px`;
        if(!animation&&!media.matches)animation=requestAnimationFrame(paint);
      });
    };
    element.addEventListener('pointermove',move);element.addEventListener('pointerleave',clear);media.addEventListener('change',clear);document.addEventListener('visibilitychange',clear);
    return()=>{clear();cancelAnimationFrame(hitFrame);element.removeEventListener('pointermove',move);element.removeEventListener('pointerleave',clear);media.removeEventListener('change',clear);document.removeEventListener('visibilitychange',clear);};
  },[locale]);
  return <h1 ref={host} className="fire-headline">{siteText(locale,'One language.')}<br/><span>{siteText(locale,'Every interface.')}</span><canvas ref={canvas} width="160" height="160" aria-hidden="true"/></h1>;
}
export function HeroExperience({locale}:{locale:Locale}) {
  const host=useRef<HTMLElement>(null),paused=useMotion(host),c=copy[locale];
  return <section className="landing-hero" ref={host}><LightningBackground paused={paused} style={{'--lightning-period':'3s','--lightning-delay':'1.5s'} as React.CSSProperties}/><div className="hero-heading"><p className="eyebrow">DESIGN SYSTEM / REACT + FLUTTER</p><FireHeadline locale={locale}/></div><LogoStage locale={locale}/><div className="hero-note"><p>{c.intro}</p><ExploreLinks locale={locale} icons/></div><div className="hero-spec"><span>Days One × Manrope</span><span>primary + warning</span><span>React / Flutter</span></div></section>;
}
export function CopyCommand({command,locale}:{command:string;locale:Locale}) {
  const [state,setState]=useState<'idle'|'copied'|'failed'>('idle'),timer=useRef<ReturnType<typeof setTimeout>|undefined>(undefined);
  useEffect(()=>()=>clearTimeout(timer.current),[]);
  return <div className="command"><pre tabIndex={0} dir="ltr"><code>{command}</code></pre><Button variant="ghost" size="icon" aria-label={siteText(locale,'Copy command')} onClick={async()=>{try{await navigator.clipboard.writeText(command);setState('copied');}catch{setState('failed');}clearTimeout(timer.current);timer.current=setTimeout(()=>setState('idle'),2500);}}>{state==='copied'?<Check size={18}/>:<Copy size={18}/>}</Button><span className="command-status" role="status">{state==='copied'?siteText(locale,'Copied'):state==='failed'?siteText(locale,'Select and copy the command'):''}</span></div>;
}
export function FrameworkJourney({locale}:{locale:Locale}) {
  const t=(text:string)=>siteText(locale,text),c=copy[locale],host=useRef<HTMLElement>(null),paused=useMotion(host);
  const [step,setStep]=useState<'choose'|'install'|'learn'>('choose'),[framework,setFramework]=useState<'react'|'flutter'>('react'),[index,setIndex]=useState(0),[engaged,setEngaged]=useState(false),[enhanced,setEnhanced]=useState(false);
  const heading=useRef<HTMLHeadingElement>(null),changed=useRef(false);
  useEffect(()=>setEnhanced(true),[]);
  useEffect(()=>{if(changed.current)heading.current?.focus();else changed.current=true;},[step]);
  const choose=(value:'react'|'flutter')=>{setFramework(value);setStep('install');};
  const slides=[...c.questions,[t('One palette, two frameworks'),t('Primary and status colors stay the same in light and dark themes.')],[t('Local fonts, no remote requests'),t('Keep the supplied font licenses when distributing your application.')],[t('Your application owns its data'),t('The packages receive content and callbacks. They do not connect to product services.')]];
  return <section id="frameworks" className="landing-section journey" ref={host} data-step={step} data-enhanced={enhanced}>
    <div className="journey-progress" aria-label={t('Getting started')}>{[c.choose,c.install,c.faq].map((label,i)=><span key={label} aria-current={['choose','install','learn'].indexOf(step)===i?'step':undefined}>{String(i+1).padStart(2,'0')} <span>{label}</span></span>)}</div>
    <h2 ref={heading} tabIndex={-1}>{step==='choose'?c.choose:step==='install'?`${c.install} · ${framework==='react'?'React':'Flutter'}`:c.faq}</h2>
    <div className="journey-pane journey-chooser" hidden={enhanced&&step!=='choose'}>
      <p>{c.overviewText}</p><div className="framework-orbit" data-paused={paused||engaged} onPointerEnter={()=>setEngaged(true)} onPointerLeave={()=>setEngaged(false)} onFocusCapture={()=>setEngaged(true)} onBlurCapture={event=>{if(!event.currentTarget.contains(event.relatedTarget))setEngaged(false);}}>
      {(['react','flutter'] as const).map(item=><div className={`orbit-slot orbit-${item}`} key={item}><button className="framework-choice" onClick={()=>choose(item)} aria-label={`${c.choose}: ${item==='react'?'React':'Flutter'}`}><LogoStage locale={locale} framework={item}/><span className="framework-choice-title">{item==='react'?'React':'Flutter'}</span><span className="framework-choice-copy">{item==='react'?c.reactText:c.flutterText}</span><ArrowRight size={20} aria-hidden="true"/></button></div>)}</div>
    </div>
    <div className="journey-pane journey-install" id="install" hidden={enhanced&&step!=='install'}>
      <p>{c.installText}</p><div className="install-grid">
      {(['react','flutter'] as const).filter(item=>!enhanced||item===framework).map(item=><article key={item}><h3><FrameworkLogo framework={item} size={24}/>{item==='react'?'React':'Flutter'}</h3><CopyCommand locale={locale} command={item==='react'?`npm install @want-foundation/allure@${version} @want-foundation/allure-react@${version}`:`flutter pub add want_allure:^${version}`}/><pre className="install-code" tabIndex={0} dir="ltr"><code>{item==='react'?`import '@want-foundation/allure/styles.css';\nimport '@want-foundation/allure/fonts.css';\nimport { Button } from '@want-foundation/allure-react';`:`import 'package:want_allure/want_allure.dart';`}</code></pre></article>)}
      <article><p className="eyebrow">WANT DESIGN SKILL</p><h3>{t('Design rules beside your code')}</h3><p>{t('Brand, composition, UI/UX and motion. Add --global to install for all projects.')}</p><CopyCommand locale={locale} command={`npx --yes --package=@want-foundation/allure@${version} want-design-install`}/><p><code>$want-design</code></p></article></div>
      <div className="journey-actions"><Button variant="secondary" onClick={()=>setStep('choose')}><ArrowLeft size={18}/>{t('Change framework')}</Button><Button onClick={()=>setStep('learn')}><Check size={18}/>{t('I have installed it')}</Button></div>
    </div>
    <div className="journey-pane journey-learn" hidden={enhanced&&step!=='learn'}><div className="tips-track" tabIndex={0} role="region" aria-label={c.faq} onScroll={event=>{const element=event.currentTarget;setIndex(Math.round(element.scrollLeft/Math.max(1,element.clientWidth)));}} ref={element=>{if(element&&step!=='learn')element.scrollLeft=0;}}>{slides.map(([title,text],i)=><article className="tip-slide" key={title}><p className="eyebrow">{String(i+1).padStart(2,'0')} / {String(slides.length).padStart(2,'0')}</p><h3>{title}</h3><p>{text}</p></article>)}</div><div className="journey-actions"><Button variant="secondary" onClick={()=>setStep('install')}><ArrowLeft size={18}/>{c.install}</Button><span className="tip-count" aria-live="polite">{Math.abs(index)+1} / {slides.length}</span><div className="tip-navigation"><Button size="icon" variant="secondary" aria-label={t('Previous tip')} onClick={()=>{const track=host.current?.querySelector('.tips-track');track?.scrollBy({left:-(track.clientWidth)*(document.dir==='rtl'?-1:1),behavior:paused?'instant':'smooth'});}}><ArrowLeft size={18}/></Button><Button size="icon" variant="secondary" aria-label={t('Next tip')} onClick={()=>{const track=host.current?.querySelector('.tips-track');track?.scrollBy({left:track.clientWidth*(document.dir==='rtl'?-1:1),behavior:paused?'instant':'smooth'});}}><ArrowRight size={18}/></Button></div></div></div>
  </section>;
}
export function BackToTop({locale}:{locale:Locale}) {return <Button asChild className="back-to-top"><a href="#main"><ArrowUp size={20}/>{siteText(locale,'Back to top')}</a></Button>;}
