import { categoryOf } from './catalogue';
type Theme = 'light' | 'dark';
const media = matchMedia('(prefers-color-scheme: dark)');
let explicit: Theme | undefined;
try { const saved = localStorage.getItem('want-theme'); if (saved === 'dark' || saved === 'light') explicit = saved; } catch {}
function apply(theme: Theme) {
  document.documentElement.dataset.theme = theme;
  document.documentElement.classList.toggle('dark', theme === 'dark');
  dispatchEvent(new CustomEvent('want:theme', { detail: theme }));
}
function system() { if (!explicit) apply(media.matches ? 'dark' : 'light'); }
media.addEventListener('change', system);
function choose(theme: Theme) {
  explicit = theme; apply(theme);
  try { localStorage.setItem('want-theme', theme); } catch {}
}
addEventListener('want:choose-theme', event => {
  const theme: unknown = (event as CustomEvent).detail;
  if (theme === 'light' || theme === 'dark') choose(theme);
});
window.addEventListener('pageshow', event => {
  if (!event.persisted) return;
  explicit = undefined;
  try { const saved = localStorage.getItem('want-theme'); if (saved === 'light' || saved === 'dark') explicit = saved; } catch {}
  apply(explicit ?? (media.matches ? 'dark' : 'light'));
});
apply(explicit ?? (media.matches ? 'dark' : 'light'));

function direction(value: 'ltr'|'rtl') { document.documentElement.dir=value; dispatchEvent(new CustomEvent('want:direction',{detail:value})); }
function section() { dispatchEvent(new CustomEvent('want:section',{detail:categoryOf(new URLSearchParams(location.search).get('section'))})); }
addEventListener('want:choose-direction',event=>{const value=(event as CustomEvent).detail; if(value!=='ltr'&&value!=='rtl')return;direction(value);try{localStorage.setItem('want-direction',value);}catch{}});
addEventListener('want:choose-section',event=>{
  const value=categoryOf((event as CustomEvent).detail);const url=new URL(location.href);
  if(value==='foundation')url.searchParams.delete('section');else url.searchParams.set('section',value);
  if(url.href!==location.href)history.pushState(null,'',url); section();
});
addEventListener('popstate',section);
addEventListener('pageshow',()=>{try{direction(localStorage.getItem('want-direction')==='rtl'?'rtl':'ltr');}catch{} section();});
