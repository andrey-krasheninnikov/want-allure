import { useT, useCatalogueLocale } from '../i18n/catalogue';
import { useEffect, useRef, useState } from 'react';
import { Button, DirectionProvider, Tabs, TabsList, TabsTrigger, TabsContent, LightningBackground } from '@want-foundation/allure-react';
import { burstConfetti, initInteractionEffects, initBackgroundMotion } from '@want-foundation/allure';
import { CatalogueLocaleProvider } from '../i18n/catalogue';
import { version, type Locale } from '../site';
import UiKit from './UiKit';
import { CatalogueContext } from './CatalogueContext';
import { categories, categoryOf, categoryCopy, categoryDescriptions, type Category } from '../catalogue';
import { Section } from './Section';

export default function Showcase({ locale }: { locale: Locale }) {
  return <CatalogueLocaleProvider locale={locale}><ShowcaseContent /></CatalogueLocaleProvider>;
}
function ShowcaseContent() {
  const t = useT();
  const locale = useCatalogueLocale();
  const [category,setCategory]=useState<Category>('foundation');
  const [paused,setPaused]=useState(false);
  const [direction, setDirection] = useState<'ltr' | 'rtl'>('ltr');
  const confetti = useRef<() => void>(() => {});
  useEffect(()=>{
    const update=()=>{setCategory(categoryOf(new URLSearchParams(location.search).get('section')));setDirection(document.documentElement.dir==='rtl'?'rtl':'ltr');};
    update();addEventListener('want:section',update);addEventListener('want:direction',update);
    return()=>{removeEventListener('want:section',update);removeEventListener('want:direction',update);};
  },[]);
  useEffect(() => {
    if(category!=='effects')return;
    const interactions = initInteractionEffects();
    const background = document.querySelector<HTMLElement>('.page-background')!;
    const control = document.querySelector<HTMLButtonElement>('[data-background-toggle]')!;
    const motion = initBackgroundMotion({ background, control, shimmerDelayMs: [5000, 10000] });
    return () => { interactions(); motion(); confetti.current(); };
  }, [category]);
  return <DirectionProvider dir={direction}>
    <div className="page-background" hidden={category!=='effects'} inert><div /></div>
    <div className="showcase-main">
      <div className="showcase-intro"><p className="showcase-index">REACT / {version}</p><h1>{locale==='ru'?'Компоненты в действии':'Components in action'}</h1><p>{locale==='ru'?'Выберите раздел и изучите состояния, поведение и композиции.':'Choose a section to explore states, behavior and compositions.'}</p></div>
      <Tabs value={category} onValueChange={value=>dispatchEvent(new CustomEvent('want:choose-section',{detail:value}))}>
        <TabsList className="catalogue-tabs" aria-label={locale==='ru'?'Разделы каталога':'Catalogue sections'}>{categories.map((item,index)=><TabsTrigger key={item} value={item}>{categoryCopy[locale][index]}</TabsTrigger>)}</TabsList>
        <p className="category-description">{categoryDescriptions[locale][categories.indexOf(category)]}</p>
        <TabsContent value={category} className="catalogue-panel"><CatalogueContext.Provider value={category}>
      <Section category="effects" title={t("Optional motion")}><p>{t("The background and interaction effects have explicit ownership and cleanup. System accessibility preferences take priority.")}</p>
        <div className="showcase-controls"><Button variant="secondary" data-background-toggle data-pause-label={t("Pause background glow")} data-play-label={t("Resume background glow")} hidden>{t("Pause background glow")}</Button>
        <Button variant="secondary" onClick={() => document.querySelector('.page-background')?.dispatchEvent(new Event('want:background-shimmer'))}>{t("Preview background wave")}</Button>
        <Button onClick={event => { confetti.current(); confetti.current = burstConfetti(event.currentTarget); }}>{t("Preview confetti")}</Button></div>
      </Section>
      <Section category="effects" title={locale==='ru'?'Фоновые молнии':'Background lightning'}><div className="lightning-preview"><LightningBackground paused={paused}/><span>{locale==='ru'?'Свет и пространство':'Light and space'}</span></div><Button variant="secondary" onClick={()=>setPaused(value=>!value)}>{locale==='ru'?(paused?'Продолжить':'Пауза'):(paused?'Resume':'Pause')}</Button></Section>
      <div id="components"><UiKit item={{ href: '#main', title: t("Violet Horizon"), caption: t("Local demonstration artwork"), index: 1, image: { src: '/sample.svg', width: 1600, height: 900, alt: t("Violet ridge against a graphite background") } }} /></div>
      <Section title={locale==='ru'?'Направление текста':'Text direction'}><div lang="ar" dir="rtl"><p>تصميم واضح للجميع</p><p>مثال محلي للتحقق من اتجاه النص والخط العربي وإمكانية الوصول.</p></div></Section>
      </CatalogueContext.Provider></TabsContent></Tabs>
    </div>
  </DirectionProvider>;
}
