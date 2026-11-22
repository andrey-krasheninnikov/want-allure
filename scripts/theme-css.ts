import tokens from '../packages/foundation/tokens.json';

export function themeCss(): string {
  const theme = tokens.themes.wallpapers;
  const values = (mode: 'light' | 'dark') => Object.entries(theme[mode]).map(([name, value]) => '--' + name + ':' + value + ';').join('') +
    'color-scheme:' + mode + ';--glass-highlight:' + tokens.glass.highlight[mode] + ';--glass-shadow:' + tokens.glass.shadow[mode] + ';';
  const fonts = (items: string[]) => items.map(item => item.includes(' ') ? JSON.stringify(item) : item).join(',');
  // Interpolate between 320 and 1440 px, with rem bounds for text zoom.
  const typeStyles = Object.entries(tokens.typography.styles).map(([name, style]) => {
    const slope = (style.maxPx - style.minPx) / 11.2;
    const base = (style.minPx - slope * 3.2) / 16;
    const size = style.minPx === style.maxPx ? style.minPx / 16 + 'rem'
      : 'clamp(' + style.minPx / 16 + 'rem, calc(' + base.toFixed(4) + 'rem + ' + slope.toFixed(4) + 'vw), ' + style.maxPx / 16 + 'rem)';
    return '--type-' + name + '-size:' + size + ';--type-' + name + '-weight:' + style.weight +
      ';--type-' + name + '-leading:' + style.lineHeight + ';--type-' + name + '-tracking:' + style.trackingEm + 'em;';
  }).join('');
  const proseElements: Record<string, string> = { h1: 'h1', h2: 'h2', h3: 'h3', h4: 'h4', h5: 'h5', h6: 'h6', body: 'p', small: 'small', caption: 'figcaption', label: 'label', code: ':not(pre) > code', 'code-block': 'pre', quote: 'blockquote' };
  const typeRules = Object.entries(tokens.typography.styles).map(([name, style]) => {
    const selectors = '.ui-typography[data-variant="' + name + '"]' + (proseElements[name] ? ',.ui-prose :where(' + proseElements[name] + ')' : '');
    const family = style.font === 'body' ? '--font-sans' : '--font-' + style.font;
    return selectors + '{font-family:var(' + family + ');font-size:var(--type-' + name + '-size);font-weight:var(--type-' + name +
      '-weight);line-height:var(--type-' + name + '-leading);letter-spacing:var(--type-' + name + '-tracking);}';
  }).join('');
  const material = Object.entries(tokens.material).map(([name, value]) => '--material-' + name.replace(/[A-Z]/g, letter => '-' + letter.toLowerCase()) + ':' + value + 'px;').join('');
  const shared = material + '--radius:' + tokens.geometry.fieldRadiusPx + 'px;--panel-radius:' + tokens.geometry.panelRadiusPx + 'px;--media-radius:' + tokens.geometry.mediaRadiusPx + 'px;' +
    '--glass-opacity:' + tokens.glass.opacityPercent + '%;--glass-blur:' + tokens.glass.blurPx + 'px;--glass-saturation:' + tokens.glass.saturationPercent + '%;' +
    '--motion-fast:' + tokens.motion.feedbackMs + 'ms;--motion-transition:' + tokens.motion.transitionMs + 'ms;--motion-glow:' + tokens.motion.glowMs + 'ms;--motion-ease:cubic-bezier(' + tokens.motion.easing.join(',') + ');' +
    '--want-font-chinese:' + fonts(tokens.typography.chinese) + ';--want-font-devanagari:' + fonts(tokens.typography.devanagari) + ';--want-font-hebrew:' + fonts(tokens.typography.hebrew) + ';--want-font-japanese:' + fonts(tokens.typography.japanese) + ';--want-font-arabic:' + fonts(tokens.typography.arabic) + ';--want-font-display:' + fonts(tokens.typography.display) + ';--want-font-sans:' + fonts(tokens.typography.body) + ';--want-font-mono:' + fonts(tokens.typography.mono) + ';';
  const variableFamilies = new Set(['Manrope', 'Unbounded', 'Literata', 'IBM Plex Sans', 'Atkinson Hyperlegible Next', 'Pixelify Sans', 'Noto Kufi Arabic']);
  const family = (name: string) => JSON.stringify(name + (variableFamilies.has(name) ? ' Variable' : ''));
  const scriptFonts = {
    ja: 'japanese', zh: 'chinese', ar: 'arabic', hi: 'devanagari', he: 'hebrew',
  } as const;
  const presetRules = Object.entries(tokens.typography.presets).filter(([name]) => name !== 'brand').map(([name, preset]) => {
    const selector = '[data-typography="' + name + '"]';
    const localDisplay: Record<string, string> = preset.localDisplay;
    const localized = Object.entries(scriptFonts).map(([language, script]) => {
      const scriptFont = 'var(--want-font-' + script + ')';
      const display = localDisplay[language] ? family(localDisplay[language]) + ',' + scriptFont : scriptFont;
      return selector + ':lang(' + language + '),' + selector + ' :lang(' + language + '){--font-display:' + display + ';--font-sans:' + scriptFont + ';}';
    }).join('\n');
    const ru = localDisplay.ru ? selector + ':lang(ru),' + selector + ' :lang(ru){--font-display:' + family(localDisplay.ru) +
      ',var(--want-font-display);' + (name === 'humanist' ? '--font-sans:var(--want-font-sans);' : '') + '}' : '';
    return selector + '{--font-display:' + family(preset.display) + ',var(--want-font-display);--font-sans:' + family(preset.body) +
      ',var(--want-font-sans);--want-heading-weight:' + preset.weight + ';}\n' + localized + '\n' + ru;
  }).join('\n') + '\n' +
    '[data-typography]:not([data-typography="brand"]) :is(h1,h2,h3,h4,h5,h6,[data-slot="card-title"],.ui-typography[data-variant="display"],.ui-typography[data-variant^="h"]){font-family:var(--font-display);font-weight:var(--want-heading-weight);}';
  return ':root{' + values('light') + shared + typeStyles + '}\n' +
    '@media(prefers-color-scheme:dark){:root:not([data-theme]){' + values('dark') + '}}\n' +
    ':root[data-theme="dark"],:root.dark{' + values('dark') + '}\n' +
    ':root[data-theme="light"]{' + values('light') + '}\n' + '@layer components{' + typeRules + '}\n' + presetRules + '\n';
}
