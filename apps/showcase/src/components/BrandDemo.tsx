import { useEffect, useState } from 'react';
import { BrandLockup, ThemeToggle } from '@want-foundation/allure-react';
import { useT } from '../i18n/catalogue';
import { Section } from './Section';

export default function BrandDemo() {
  const t = useT();
  const [theme, setTheme] = useState<'light' | 'dark'>('dark');
  useEffect(() => {
    const update = () => setTheme(document.documentElement.dataset.theme === 'light' ? 'light' : 'dark');
    update(); addEventListener('want:theme', update);
    return () => removeEventListener('want:theme', update);
  }, []);
  return <Section title={t('Brand and theme')}><div className="demo-stack">
    <BrandLockup name="Want Allure" subtitle={t('Component preview')} logoSrc={`/brand/logos/${theme}/transparent.svg`} href="#main" />
    <ThemeToggle theme={theme} label={t('Component theme')} onThemeChange={value => dispatchEvent(new CustomEvent('want:choose-theme', { detail: value }))} />
  </div></Section>;
}
