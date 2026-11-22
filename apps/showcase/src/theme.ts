import { categoryOf } from './catalogue';
import { parseBrandProfile, resolveBrandProfile, type AllureBrandProfileV1, transitionTheme, tokens, type Theme } from '@want-foundation/allure';
import { brandProfileKey, defaultAppearance, normalizeAppearance, profileFromAppearance } from './appearance';

const appearanceKey = 'want-appearance';
let appearance = { ...defaultAppearance };
let profile: AllureBrandProfileV1 = { schemaVersion: 1 };

function readAppearance() {
  try {
    const saved = localStorage.getItem(appearanceKey);
    if (saved !== null) appearance = normalizeAppearance(JSON.parse(saved));
    profile = profileFromAppearance(appearance);
    const candidate = localStorage.getItem(brandProfileKey);
    if (candidate) profile = parseBrandProfile(JSON.parse(candidate));
  } catch { /* Keep the current appearance when storage is unavailable. */ }
}

function applyAppearance(theme: Theme) {
  const root = document.documentElement;
  const base: Record<string, string> = tokens.themes.wallpapers[theme];
  const colors = resolveBrandProfile(profile, theme);
  for (const [role, original] of Object.entries(base)) {
    const property: `--${string}` = `--${role}`;
    const value = colors[property];
    if (value && value !== original) root.style.setProperty(property, value);
    else root.style.removeProperty(property);
  }
  for (const [key,value] of Object.entries(colors)) {
    if (!Object.hasOwn(base, key.slice(2))) root.style.setProperty(key,value);
  }
  root.dataset.brandProfile = JSON.stringify(profile);
  root.dataset.density = profile.density ?? 'comfortable';
  root.dataset.surface = profile.surface ?? 'soft';
  root.dataset.motion = profile.motion ?? 'standard';
  root.dataset.primaryColor = profile.brandColor ?? defaultAppearance.primaryColor;
  root.dataset.appliedPrimary = colors['--primary'];
  root.dataset.paletteStyle = profile.paletteStyle ?? defaultAppearance.paletteStyle;
  root.dataset.typography = profile.typographyPreset ?? defaultAppearance.typographyPreset;
}

readAppearance();
function chooseProfile(next: AllureBrandProfileV1) {
  profile = parseBrandProfile(next);
  appearance = normalizeAppearance({ ...profile, primaryColor: profile.brandColor });
  transitionTheme(document.documentElement, Object.keys(tokens.themes.wallpapers.dark), () => {
    applyAppearance(document.documentElement.dataset.theme === 'light' ? 'light' : 'dark');
  }, false);
  try { localStorage.setItem(appearanceKey, JSON.stringify(appearance)); } catch { /* The current page keeps the selection. */ }
  try { localStorage.setItem(brandProfileKey, JSON.stringify(profile)); } catch { /* Keep the applied profile in this document. */ }
  dispatchEvent(new Event('want:appearance'));
}
addEventListener('want:choose-profile', event => chooseProfile((event as CustomEvent<AllureBrandProfileV1>).detail));
addEventListener('want:choose-appearance', event => {
  const legacy = normalizeAppearance((event as CustomEvent<unknown>).detail);
  chooseProfile({ ...profile, ...profileFromAppearance(legacy) });
});
const media = matchMedia('(prefers-color-scheme: dark)');
let explicit: Theme | undefined;
try { const saved = localStorage.getItem('want-theme'); if (saved === 'dark' || saved === 'light') explicit = saved; } catch {}
function apply(theme: Theme, animate = true) {
  const root = document.documentElement;
  transitionTheme(root, Object.keys(tokens.themes.wallpapers[theme]), () => {
    root.dataset.themeMode = explicit ?? 'system';
    root.dataset.theme = theme;
    applyAppearance(theme);
    root.classList.toggle('dark', theme === 'dark');
  }, animate && root.dataset.theme !== theme);
  for (const icon of document.querySelectorAll<HTMLLinkElement>('link[data-theme-icon]')) icon.href = `/favicon/${theme}/${icon.dataset.themeIcon}`;
  dispatchEvent(new CustomEvent('want:theme', { detail: theme }));
}
function system() { if (!explicit) apply(media.matches ? 'dark' : 'light'); }
media.addEventListener('change', system);
function choose(theme: Theme | 'system') {
  explicit = theme === 'system' ? undefined : theme;
  apply(explicit ?? (media.matches ? 'dark' : 'light'));
  try {
    if (explicit) localStorage.setItem('want-theme', explicit);
    else localStorage.removeItem('want-theme');
  } catch {}
}
addEventListener('want:choose-theme', event => {
  const theme: unknown = (event as CustomEvent).detail;
  if (theme === 'light' || theme === 'dark' || theme === 'system') choose(theme);
});
window.addEventListener('pageshow', event => {
  if (!event.persisted) return;
  readAppearance();
  explicit = undefined;
  try { const saved = localStorage.getItem('want-theme'); if (saved === 'light' || saved === 'dark') explicit = saved; } catch {}
  apply(explicit ?? (media.matches ? 'dark' : 'light'));
  dispatchEvent(new Event('want:appearance'));
});
apply(explicit ?? (media.matches ? 'dark' : 'light'), false);

function direction(value: 'ltr'|'rtl') { document.documentElement.dir=value; dispatchEvent(new CustomEvent('want:direction',{detail:value})); }
function section() { dispatchEvent(new CustomEvent('want:section',{detail:categoryOf(new URLSearchParams(location.search).get('section'))})); }
addEventListener('want:choose-direction',event=>{const value=(event as CustomEvent).detail; if(value!=='ltr'&&value!=='rtl')return;direction(value);try{localStorage.setItem('want-direction:'+document.documentElement.lang,value);}catch{}});
addEventListener('want:choose-section',event=>{
  const detail=(event as CustomEvent).detail;
  const value=categoryOf(typeof detail==='string'?detail:detail?.section);
  const url=new URL(location.href);
  if(typeof detail?.component === 'string') url.searchParams.set('component',detail.component);
  else url.searchParams.delete('component');
  if(value==='foundation' && !url.searchParams.has('component'))url.searchParams.delete('section');else url.searchParams.set('section',value);
  if(url.href!==location.href)history.pushState(null,'',url); section();
});
addEventListener('popstate',section);
addEventListener('pageshow',()=>{try{const saved=localStorage.getItem('want-direction:'+document.documentElement.lang);direction(saved==='rtl'||saved==='ltr'?saved:(['ar','he'].includes(document.documentElement.lang)?'rtl':'ltr'));}catch{} section();});
