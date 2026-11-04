import React, { useEffect, useRef, useState } from 'react';
import { ArrowLeft, ArrowRight, ArrowUp, Check, Copy } from 'lucide-react';
import { Button, Glow, Slider, Tabs, TabsList, TabsTrigger, TabsContent, Table, TableCaption, TableHeader, TableHead, TableRow, TableBody, TableCell } from '@want-foundation/allure-react';
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
function FireHeadline({locale}:{locale:Locale}) {
  const host=useRef<HTMLHeadingElement>(null),canvas=useRef<HTMLCanvasElement>(null);
  useEffect(()=>{
    const element=host.current!,surface=canvas.current!,context=surface.getContext('2d');if(!context)return;
    const media=matchMedia('(prefers-reduced-motion: reduce)'),style=getComputedStyle(element);
    const highlights=(CSS as unknown as {highlights?:Map<string,unknown>}).highlights;
    let animation=0,hitFrame=0,last=0,started=0,opacity=0,engaged=false,target:DOMRect|null=null;
    const reset=()=>{
      cancelAnimationFrame(animation);cancelAnimationFrame(hitFrame);animation=0;hitFrame=0;last=0;opacity=0;engaged=false;target=null;
      highlights?.delete('want-fire-letter');element.style.removeProperty('--fire-letter-color');surface.hidden=true;
      surface.style.removeProperty('left');surface.style.removeProperty('top');context.clearRect(0,0,160,160);
    };
    const mix=(from:number[],to:number[],amount:number)=>from.map((value,i)=>Math.round(value+(to[i]-value)*amount));
    const rgb=(role:string)=>(style.getPropertyValue(`--${role}`).trim().match(/[a-f\d]{2}/gi)??[]).map(value=>parseInt(value,16));
    const roles=['primary','info','warning','error','success'];
    let colors:number[][]=[],ink:number[][]=[];
    const palette=()=>{colors=roles.map(rgb);ink=roles.map(role=>rgb(role==='primary'?role:`${role}-text`));};
    const paint=(now:number)=>{
      animation=0;if(!target||media.matches||document.hidden){reset();return;}
      if(last&&now-last<1000/30){animation=requestAnimationFrame(paint);return;}
      const elapsed=last?Math.min(now-last,100):33;last=now;
      opacity+=((engaged?1:0)-opacity)*(1-Math.exp(-elapsed/(engaged?110:90)));
      if(!engaged&&opacity<.01){reset();return;}
      const phase=((now-started)%8000)/8000*roles.length,index=Math.floor(phase),blend=(1-Math.cos((phase-index)*Math.PI))/2;
      const color=mix(colors[index],colors[(index+1)%roles.length],blend),text=mix(ink[index],ink[(index+1)%roles.length],blend);
      element.style.setProperty('--fire-letter-color',`rgb(${text.join(',')})`);
      const left=Math.max(0,Math.min(innerWidth-160,target.left+target.width/2-80)),top=Math.max(0,Math.min(innerHeight-160,target.top+target.height/2-80));
      surface.style.left=`${left}px`;surface.style.top=`${top}px`;surface.hidden=false;
      const x=target.left+target.width/2-left,y=target.top+target.height/2-top;
      context.clearRect(0,0,160,160);
      for(let i=0;i<3;i++){
        const drift=Math.sin(now*.0012+i*2),radius=54+i*10+drift*3,cx=x+drift*5,cy=y-i*7+Math.cos(now*.001+i)*4;
        const gradient=context.createRadialGradient(cx,cy,0,cx,cy,radius);
        gradient.addColorStop(0,`rgba(${color.join(',')},${.38-i*.07})`);gradient.addColorStop(.3,`rgba(${color.join(',')},.18)`);gradient.addColorStop(.65,`rgba(${color.join(',')},.045)`);gradient.addColorStop(1,`rgba(${color.join(',')},0)`);
        context.globalAlpha=opacity*(.94+.06*Math.sin(now*.0017+i));context.fillStyle=gradient;context.fillRect(0,0,160,160);
      }
      context.globalAlpha=1;animation=requestAnimationFrame(paint);
    };
    const leave=()=>{cancelAnimationFrame(hitFrame);hitFrame=0;engaged=false;highlights?.delete('want-fire-letter');if(!animation)reset();};
    const move=(event:PointerEvent)=>{
      if(hitFrame)return;hitFrame=requestAnimationFrame(()=>{hitFrame=0;
        const doc=document as unknown as {caretPositionFromPoint?:(x:number,y:number)=>{offsetNode:Node;offset:number}|null;caretRangeFromPoint?:(x:number,y:number)=>Range|null};
        const position=doc.caretPositionFromPoint?.(event.clientX,event.clientY),range=doc.caretRangeFromPoint?.(event.clientX,event.clientY);
        const node=position?.offsetNode??range?.startContainer,offset=position?.offset??range?.startOffset??0;
        if(!node||node.nodeType!==Node.TEXT_NODE||!element.contains(node)){leave();return;}
        const text=node.textContent??'',segments=[...new Intl.Segmenter(locale,{granularity:'grapheme'}).segment(text)];
        let active:Range|undefined,rect:DOMRect|undefined;
        for(const segment of segments.filter(item=>offset>=item.index&&offset<=item.index+item.segment.length)){
          if(!segment.segment.trim())continue;
          const candidate=document.createRange();candidate.setStart(node,segment.index);candidate.setEnd(node,segment.index+segment.segment.length);const bounds=candidate.getBoundingClientRect();
          if(event.clientX>=bounds.left&&event.clientX<=bounds.right&&event.clientY>=bounds.top&&event.clientY<=bounds.bottom){active=candidate;rect=bounds;break;}
        }
        if(!active||!rect){leave();return;}
        const HighlightClass=(window as unknown as {Highlight?:new(range:Range)=>unknown}).Highlight;if(highlights&&HighlightClass)highlights.set('want-fire-letter',new HighlightClass(active));
        target=rect;
        if(!engaged){started=performance.now();palette();}
        engaged=true;if(!animation&&!media.matches){last=0;animation=requestAnimationFrame(paint);}
      });
    };
    element.addEventListener('pointermove',move);element.addEventListener('pointerleave',leave);media.addEventListener('change',reset);document.addEventListener('visibilitychange',reset);window.addEventListener('scroll',reset,true);window.addEventListener('resize',reset);window.addEventListener('want:theme',palette);window.addEventListener('want:direction',reset);
    return()=>{reset();element.removeEventListener('pointermove',move);element.removeEventListener('pointerleave',leave);media.removeEventListener('change',reset);document.removeEventListener('visibilitychange',reset);window.removeEventListener('scroll',reset,true);window.removeEventListener('resize',reset);window.removeEventListener('want:theme',palette);window.removeEventListener('want:direction',reset);};
  },[locale]);
  return <h1 ref={host} className="fire-headline">{siteText(locale,'One language.')}<br/><span>{siteText(locale,'Every interface.')}</span><canvas ref={canvas} width="160" height="160" hidden aria-hidden="true"/></h1>;
}
export function HeroExperience({locale}:{locale:Locale}) {
  const host = useRef<HTMLElement>(null);
  const inactive = useMotion(host);
  const [light, setLight] = useState(60);
  const [framework, setFramework] = useState('react');
  const t = (text:string) => siteText(locale,text);
  const c = copy[locale];
  return <section className="landing-hero" ref={host}>
    <div className="hero-heading"><p className="eyebrow">DESIGN SYSTEM / REACT + FLUTTER</p><FireHeadline locale={locale}/></div>
    <LogoStage locale={locale} paused={inactive}/>
    <div className="hero-note"><p>{c.intro}</p><span className="hero-signature">Days One × Manrope <span aria-hidden="true">·</span> #5962F0</span></div>
    <div className="hero-slate" style={{'--slate-light':light / 100} as React.CSSProperties}>
      <div className="slate-heading"><span className="slate-mark" aria-hidden="true"/><p className="eyebrow">{t('Component preview')}</p><span className="slate-edition">01 / 46</span></div>
      <div className="slate-records">
        <Tabs value={framework} onValueChange={setFramework}>
          <TabsList aria-label={c.choose}><TabsTrigger value="react">React</TabsTrigger><TabsTrigger value="flutter">Flutter</TabsTrigger></TabsList>
          <TabsContent value={framework}><Table><TableCaption className="sr-only">{t('One palette, two frameworks')}</TableCaption><TableHeader><TableRow><TableHead>{t('Foundation')}</TableHead><TableHead>{t('Data')}</TableHead></TableRow></TableHeader><TableBody>
          <TableRow><TableCell>{t('Design tokens')}</TableCell><TableCell><code>#5962F0</code><span className="slate-color" aria-hidden="true"/></TableCell></TableRow>
          <TableRow><TableCell>{t('Navigation')}</TableCell><TableCell><code>{framework === 'react' ? 'Radix' : 'ForUI'}</code></TableCell></TableRow>
          <TableRow><TableCell>{t('Motion with a purpose')}</TableCell><TableCell><code>120 / 180 ms</code></TableCell></TableRow>
        </TableBody></Table></TabsContent>
        </Tabs>
      </div>
      <div className="slate-controls">
        <div><span className="eyebrow">{t('Light and space')}</span><div className="slate-reading"><span>{String(light).padStart(2,'0')}</span><span>%</span></div></div>
        <Slider label={t('Light and space')} value={light} onValueChange={setLight} formatValue={value=>`${value}%`}/>
        <div className="slate-palette" aria-hidden="true">{['primary','success','info','warning','error'].map(role=><span key={role} style={{background:`var(--${role})`}}/>)}</div>
        <Button asChild><a href={route(locale,framework === 'react' ? 'react' : 'flutter')}>{c.catalogue}<ArrowRight size={16} aria-hidden="true"/></a></Button>
      </div>
    </div>
  </section>;
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
      {(['react','flutter'] as const).map(item=><div className={`orbit-slot orbit-${item}`} key={item}><button className="framework-choice" onClick={()=>choose(item)} aria-label={`${c.choose}: ${item==='react'?'React':'Flutter'}`}><LogoStage locale={locale} framework={item} paused/><span className="framework-choice-title">{item==='react'?'React':'Flutter'}</span><span className="framework-choice-copy">{item==='react'?c.reactText:c.flutterText}</span><ArrowRight size={20} aria-hidden="true"/></button></div>)}</div>
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
export function BackToTop({locale}:{locale:Locale}) {
  return <div className="glow-host back-to-top-glow"><Glow paused/><Button asChild className="back-to-top"><a href="#main" aria-describedby="back-to-top-description"><ArrowUp size={20} aria-hidden="true"/>{copy[locale].final}</a></Button><span id="back-to-top-description" className="sr-only">{siteText(locale,'Back to top')}</span></div>;
}
