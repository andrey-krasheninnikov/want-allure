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
input?.addEventListener('change', () => {
  explicit = input.checked ? 'dark' : 'light'; apply(explicit);
  try { localStorage.setItem('want-theme', explicit); } catch {}
});
apply(explicit ?? (media.matches ? 'dark' : 'light'));
