import { useT } from '../i18n/catalogue';
import { useEffect, useRef, useState } from 'react';
import { Button, DirectionProvider } from '@want-foundation/allure-react';
import { burstConfetti, initInteractionEffects, initBackgroundMotion } from '@want-foundation/allure';
import { CatalogueLocaleProvider } from '../i18n/catalogue';
import { version, type Locale } from '../site';
import UiKit from './UiKit';

export default function Showcase({ locale }: { locale: Locale }) {
  return <CatalogueLocaleProvider locale={locale}><ShowcaseContent /></CatalogueLocaleProvider>;
}
function ShowcaseContent() {
  const t = useT();
  const [direction, setDirection] = useState<'ltr' | 'rtl'>('ltr');
  const confetti = useRef<() => void>(() => {});
  useEffect(() => {
    const interactions = initInteractionEffects();
    const background = document.querySelector<HTMLElement>('.page-background')!;
    const control = document.querySelector<HTMLButtonElement>('[data-background-toggle]')!;
    const motion = initBackgroundMotion({ background, control, shimmerDelayMs: [5000, 10000] });
    return () => { interactions(); motion(); confetti.current(); };
  }, []);
  return <DirectionProvider dir={direction}>
    <div className="page-background" inert><div /></div>
    <div className="showcase-main">
      <div className="catalogue-toolbar"><Button variant="secondary" onClick={() => { const next = direction === 'ltr' ? 'rtl' : 'ltr'; setDirection(next); document.documentElement.dir = next; }}>{t("Toggle RTL")}</Button></div>
      <div className="showcase-intro"><p className="showcase-index">WANT / ALLURE / REACT / {version}</p><h1>{t("Shared by design.")}</h1><p>{t("Tokens, accessible controls and product compositions. Local examples, ready for independent consumers.")}</p></div>
      <section className="kit-section showcase-motion"><h2>{t("Optional motion")}</h2><p>{t("The background and interaction effects have explicit ownership and cleanup. System accessibility preferences take priority.")}</p>
        <div className="showcase-controls"><Button variant="secondary" data-background-toggle data-pause-label={t("Pause background glow")} data-play-label={t("Resume background glow")} hidden>{t("Pause background glow")}</Button>
        <Button variant="secondary" onClick={() => document.querySelector('.page-background')?.dispatchEvent(new Event('want:background-shimmer'))}>{t("Preview background wave")}</Button>
        <Button onClick={event => { confetti.current(); confetti.current = burstConfetti(event.currentTarget); }}>{t("Preview confetti")}</Button></div>
      </section>
      <div id="components"><UiKit item={{ href: '#main', title: t("Violet Horizon"), caption: t("Local demonstration artwork"), index: 1, image: { src: '/sample.svg', width: 1600, height: 900, alt: t("Violet ridge against a graphite background") } }} /></div>
      <section lang="ar" dir="rtl" className="kit-section locale-example"><h2>تصميم واضح للجميع</h2><p>مثال محلي للتحقق من اتجاه النص والخط العربي وإمكانية الوصول.</p></section>
    </div>
  </DirectionProvider>;
}
