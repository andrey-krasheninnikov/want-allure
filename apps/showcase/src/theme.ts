type Theme = 'light' | 'dark';
const input = document.querySelector<HTMLInputElement>('[data-theme-toggle]');
const media = matchMedia('(prefers-color-scheme: dark)');
let explicit: Theme | undefined;
try { const saved = localStorage.getItem('want-theme'); if (saved === 'dark' || saved === 'light') explicit = saved; } catch {}
function apply(theme: Theme) {
  document.documentElement.dataset.theme = theme;
  document.documentElement.classList.toggle('dark', theme === 'dark');
  if (input) input.checked = theme === 'dark';
  dispatchEvent(new CustomEvent('want:theme', { detail: theme }));
}
function system() { if (!explicit) apply(media.matches ? 'dark' : 'light'); }
media.addEventListener('change', system);
function choose(theme: Theme) {
  explicit = theme; apply(theme);
  try { localStorage.setItem('want-theme', theme); } catch {}
}
input?.addEventListener('change', () => choose(input.checked ? 'dark' : 'light'));
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
