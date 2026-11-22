import BrandStudio from './BrandStudio';
import React, { useEffect, useId, useMemo, useRef, useState } from 'react';
import { ChevronLeft, ChevronRight, Palette } from 'lucide-react';
import { Button, Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger,
  Badge, Input, Label, Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
  Table, TableBody, TableCaption, TableCell, TableHead, TableHeader, TableRow, ThemeIcon, ThemePicker, type ThemeMode } from '@want-foundation/allure-react';
import { parseBrandProfile, resolveBrandProfile } from '@want-foundation/allure';
import { defaultAppearance, documentAppearance, documentProfile, isBrandColor, paletteStyles, typographyPresets, type Appearance } from '../appearance';
import { siteText, type Locale } from '../site';

const titleCase = (value: string) => value[0]!.toUpperCase() + value.slice(1);

export default function AppearancePreferences({ locale }: { locale: Locale }): React.JSX.Element {
  const t = (text: string) => siteText(locale, text);
  return <Dialog>
    <DialogTrigger asChild>
      <Button type="button" variant="ghost" size="icon" aria-label={t('Appearance')} className="appearance-trigger"><ThemeIcon icon={Palette} size={20} /></Button>
    </DialogTrigger>
    <DialogContent closeLabel={t('Close')} className="appearance-panel">
      <DialogHeader>
        <DialogTitle>{t('Appearance')}</DialogTitle>
        <DialogDescription>{t('Customize colors and type.')}</DialogDescription>
      </DialogHeader>
      <AppearanceFields locale={locale} />
    </DialogContent>
  </Dialog>;
}

export function SiteThemePicker({ locale }: { locale: Locale }) {
  const [mode, setMode] = useState<ThemeMode>('system');
  const [resolved, setResolved] = useState<'light' | 'dark'>('dark');
  useEffect(() => {
    const update = () => {
      const data = document.documentElement.dataset;
      setMode(data.themeMode === 'dark' || data.themeMode === 'light' ? data.themeMode : 'system');
      setResolved(data.theme === 'light' ? 'light' : 'dark');
    };
    update();
    addEventListener('want:theme', update);
    return () => removeEventListener('want:theme', update);
  }, []);
  const t = (text: string) => siteText(locale, text);
  return <ThemePicker label={t('Theme')} value={mode} resolved={resolved}
    labels={{ light: t('Light theme'), dark: t('Dark theme'), system: t('System theme') }}
    onChange={value => dispatchEvent(new CustomEvent('want:choose-theme', { detail: value }))} />;
}

function AppearanceFields({ locale }: { locale: Locale }) {
  const t = (text: string) => siteText(locale, text);
  const [appearance, setAppearance] = useState<Appearance>(defaultAppearance);
  const [profileError, setProfileError] = useState('');
  const [draft, setDraft] = useState(defaultAppearance.primaryColor);
  const [applied, setApplied] = useState(defaultAppearance.primaryColor);
  const id = useId();
  const paletteOptions = useMemo(() => paletteStyles.map(style => {
    const colors = resolveBrandProfile({ schemaVersion: 1, brandColor: appearance.primaryColor, paletteStyle: style }, 'light');
    return { style, fills: ['success', 'info', 'warning', 'error'].map(role => colors['--' + role]!) };
  }), [appearance.primaryColor]);
  useEffect(() => {
    const update = () => {
      const next = documentAppearance();
      setAppearance(next);
      setProfileError('');
      setDraft(next.primaryColor);
      setApplied(document.documentElement.dataset.appliedPrimary ?? next.primaryColor);
    };
    const updateColor = () => setApplied(document.documentElement.dataset.appliedPrimary ?? defaultAppearance.primaryColor);
    update();
    addEventListener('want:appearance', update);
    addEventListener('want:theme', updateColor);
    return () => {
      removeEventListener('want:appearance', update);
      removeEventListener('want:theme', updateColor);
    };
  }, []);
  const choose = (value: Partial<Appearance>) => {
    try {
      const profile = parseBrandProfile({
        ...documentProfile(),
        ...(value.primaryColor && { brandColor: value.primaryColor.toUpperCase() }),
        ...(value.paletteStyle && { paletteStyle: value.paletteStyle }),
        ...(value.typographyPreset && { typographyPreset: value.typographyPreset }),
      });
      setProfileError('');
      dispatchEvent(new CustomEvent('want:choose-profile', { detail: profile }));
    } catch (cause) {
      setProfileError(cause instanceof Error ? cause.message : String(cause));
    }
  };
  const invalid = !isBrandColor(draft);
  return <div className="appearance-fields">
      <div className="appearance-field">
        <Label htmlFor={id + '-hex'}>{t('Primary color')}</Label>
        <div className="appearance-seed">
          <input aria-label={t('Pick a color')} type="color" value={isBrandColor(draft) ? draft : appearance.primaryColor}
            onChange={event => {
              const value = event.currentTarget.value;
              setDraft(value);
              if (isBrandColor(value)) choose({ primaryColor: value });
            }} />
          <Input id={id + '-hex'} value={draft} dir="ltr" spellCheck={false} autoComplete="off"
            aria-invalid={invalid || undefined} aria-describedby={invalid ? id + '-error' : undefined}
            onChange={event => {
              const value = event.currentTarget.value;
              setDraft(value);
              if (isBrandColor(value)) choose({ primaryColor: value });
            }} />
        </div>
        {invalid && <p id={id + '-error'} role="status">{t('Enter a color in #RRGGBB format.')}</p>}
        {applied !== appearance.primaryColor && <p>{t('Applied primary')} <code dir="ltr">{applied}</code></p>}
      </div>
      <div className="appearance-field">
        <Label htmlFor={id + '-palette'}>{t('Palette style')}</Label>
        <Select value={appearance.paletteStyle} onValueChange={value => {
          const style = paletteStyles.find(style => style === value);
          if (style) choose({ paletteStyle: style });
        }}>
          <SelectTrigger id={id + '-palette'} aria-label={t('Palette style')}><SelectValue /></SelectTrigger>
          <SelectContent>{paletteOptions.map(({ style, fills }) => <SelectItem key={style} value={style} textValue={titleCase(style)}>
            <span className="palette-option"><span className="palette-option-colors" aria-hidden="true">
              {fills.map((fill, i) => <i key={i} style={{ backgroundColor: fill }} />)}
            </span>{titleCase(style)}</span>
          </SelectItem>)}</SelectContent>
        </Select>
      </div>
      <div className="appearance-field">
        <Label htmlFor={id + '-type'}>{t('Typography preset')}</Label>
        <Select value={appearance.typographyPreset} onValueChange={value => {
          const preset = typographyPresets.find(preset => preset === value);
          if (preset) choose({ typographyPreset: preset });
        }}>
          <SelectTrigger id={id + '-type'} aria-label={t('Typography preset')}><SelectValue /></SelectTrigger>
          <SelectContent>{typographyPresets.map(preset => <SelectItem key={preset} value={preset}>{titleCase(preset)}</SelectItem>)}</SelectContent>
        </Select>
      </div>
      {profileError && <p role="alert">{profileError}</p>}
      <Button type="button" variant="secondary" onClick={() => dispatchEvent(new CustomEvent('want:choose-profile',{detail:{schemaVersion:1}}))}>{t('Reset appearance')}</Button>
  </div>;
}

export function AppearanceSection({ locale }: { locale: Locale }) {
  const track = useRef<HTMLDivElement>(null);
  const t = (text: string) => siteText(locale, text);
  const shift = (direction: number) => {
    const element = track.current;
    if (!element) return;
    const rtl = getComputedStyle(element).direction === 'rtl';
    const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
    const slides = Array.from(element.children);
    const start = Math.abs(element.scrollLeft);
    const step = slides[1] && slides[0] ? Math.abs((slides[1] as HTMLElement).offsetLeft - (slides[0] as HTMLElement).offsetLeft) : element.clientWidth;
    const next = Math.max(0, (Math.round(start / step) + direction) * step);
    element.scrollTo({ left: rtl ? -next : next, behavior: reduced ? 'instant' : 'smooth' });
  };
  return <section className="landing-section appearance-section" aria-labelledby="appearance-title">
    <h2 id="appearance-title">{t('Appearance')}</h2>
    <div className="appearance-editor">
      <SiteThemePicker locale={locale} />
      <AppearanceFields locale={locale} />
    </div>
    <BrandStudio locale={locale}/>
    <div className="appearance-preview-heading">
      <h3>{t('Component preview')}</h3>
      <Button size="icon" variant="secondary" aria-label={t('Previous preview')} onClick={() => shift(-1)}><ThemeIcon icon={ChevronLeft}/></Button>
      <Button size="icon" variant="secondary" aria-label={t('Next preview')} onClick={() => shift(1)}><ThemeIcon icon={ChevronRight}/></Button>
    </div>
    <div className="appearance-track" ref={track} role="region" aria-label={t('Component preview')} tabIndex={0}>
      <article className="appearance-sample">
        <h4>{t('Typography preset')}</h4>
        <p className="appearance-sample-title">{t('One language.')}</p>
        <p>{t('Every interface.')}</p>
        <div className="slate-palette" role="img" aria-label={t('Palette style')}>{['primary','success','info','warning','error'].map(role=>
          <span key={role} style={{ background: 'var(--' + role + ')' }} />)}</div>
      </article>
      <article className="appearance-sample">
        <h4>{t('Feedback')}</h4>
        <Label htmlFor="appearance-preview-email">{t('Email')}</Label>
        <Input id="appearance-preview-email" type="email" placeholder="hello@example.com" dir="ltr" />
        <div className="appearance-sample-statuses">{(['success','info','warning','error'] as const).map(role =>
          <Badge key={role} variant={role}>{t(titleCase(role))}</Badge>)}</div>
      </article>
      <article className="appearance-sample">
        <h4>{t('Data')}</h4>
        <Table><TableCaption className="sr-only">{t('Component preview')}</TableCaption>
          <TableHeader><TableRow><TableHead>{t('Foundation')}</TableHead><TableHead>{t('Data')}</TableHead></TableRow></TableHeader>
          <TableBody><TableRow><TableCell>React</TableCell><TableCell>Radix</TableCell></TableRow>
            <TableRow data-state="selected"><TableCell>Flutter</TableCell><TableCell>ForUI</TableCell></TableRow></TableBody>
        </Table>
      </article>
    </div>
  </section>;
}
