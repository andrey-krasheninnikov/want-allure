const running = new WeakMap<HTMLElement, () => void>();

function channels(value: string): number[] | null {
  const hex = value.trim().match(/^#([\da-f]{6})([\da-f]{2})?$/i);
  if (hex) return hex[1]!.match(/../g)!.map(v => parseInt(v, 16)).concat(hex[2] ? parseInt(hex[2], 16) / 255 : 1);
  const rgb = value.match(/^rgba?\(([\d., /]+)\)$/);
  if (!rgb) return null;
  const parts = rgb[1]!.split(/[, /]+/).filter(Boolean).map(Number);
  return parts.length === 3 ? [...parts, 1] : parts.length === 4 ? parts : null;
}

/** Apply the new theme synchronously and animate scoped semantic color properties. */
export function transitionTheme(root: HTMLElement, roles: readonly string[], apply: () => void, animate = true) {
  const view = root.ownerDocument.defaultView;
  const motion = view?.matchMedia('(prefers-reduced-motion: reduce), (forced-colors: active)');
  const shouldAnimate = !!(animate && view && motion && !motion.matches && !root.ownerDocument.hidden);
  const before = shouldAnimate ? getComputedStyle(root) : null;
  const from = roles.map(role => before && channels(before.getPropertyValue('--' + role)));
  running.get(root)?.();
  apply();
  if (!shouldAnimate || !view || !motion) return;
  const computed = getComputedStyle(root);
  const colors = roles.flatMap((role, i) => {
    const name = '--' + role;
    const start = from[i], end = channels(computed.getPropertyValue(name));
    if (!start || !end || start.every((part, j) => part === end[j])) return [];
    return [{ name, start, end, saved: root.style.getPropertyValue(name) }];
  });
  if (colors.length === 0) return;
  let frame = 0;
  const finish = () => {
    view.cancelAnimationFrame(frame);
    running.delete(root);
    motion.removeEventListener('change', finish);
    root.ownerDocument.removeEventListener('visibilitychange', finish);
    for (const { name, saved } of colors) {
      if (saved) root.style.setProperty(name, saved);
      else root.style.removeProperty(name);
    }
  };
  const started = view.performance.now();
  const paint = (now: number) => {
    const t = Math.max(0, Math.min(1, (now - started) / 360));
    if (t >= 1) { finish(); return; }
    const progress = t * t * (3 - 2 * t);
    for (const { name, start, end } of colors) {
      const bytes = start.map((value, i) => Math.round((value + (end[i]! - value) * progress) * (i === 3 ? 255 : 1)));
      const hex = (bytes[3] === 255 ? bytes.slice(0,3) : bytes).map(value => value.toString(16).padStart(2,'0')).join('');
      root.style.setProperty(name, '#' + hex);
    }
    frame = view.requestAnimationFrame(paint);
  };
  running.set(root, finish);
  motion.addEventListener('change', finish);
  root.ownerDocument.addEventListener('visibilitychange', finish);
  paint(started);
}
