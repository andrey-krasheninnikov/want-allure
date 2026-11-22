import { chooseTheme } from './helpers';
import { expect, test } from '@playwright/test';
import { colorContrast, createThemeVariables } from '../packages/foundation/dist/index.js';

const seed = '#22DD88';

test('catalogue action and status labels use readable colors in both themes', async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
  await page.goto('/');
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  const action = page.locator('.hero-slate').getByRole('link', { name: 'Component catalogue' });
  const editor = page.locator('.appearance-section');
  const labels = editor.locator('.appearance-sample-statuses [data-slot="badge"]');
  const hex = (rgb: string) => '#' + rgb.match(/\d+/g)!.slice(0, 3)
    .map(n => Number(n).toString(16).padStart(2, '0')).join('').toUpperCase();
  async function checkAction() {
    const [ink, fill] = await action.evaluate(el => [getComputedStyle(el).color, getComputedStyle(el).backgroundColor]);
    expect(hex(ink)).toBe('#FFFFFF');
    expect(colorContrast(hex(ink), hex(fill))).toBeGreaterThanOrEqual(4.5);
  }
  for (const theme of ['dark', 'light'] as const) {
    await chooseTheme(page, theme);
    for (const style of ['Smooth', 'Contrast', 'Neon', 'Acid']) {
      await editor.getByRole('combobox', { name: 'Palette style' }).click();
      await page.getByRole('option', { name: style, exact: true }).click();
      await expect(page.locator('html')).toHaveAttribute('data-palette-style', style.toLowerCase());
      await action.focus();
      await checkAction();
      await action.hover();
      await checkAction();
      await page.mouse.down();
      try { await checkAction(); } finally { await page.mouse.move(0, 0); await page.mouse.up(); }
      await expect(labels).toHaveCount(4);
      for (const label of await labels.all()) {
        const [ink, fill, textRole, surface] = await label.evaluate(el => {
          const css = getComputedStyle(el);
          return [css.color, css.backgroundColor, css.getPropertyValue('--' + el.getAttribute('data-variant') + '-text').trim(),
            css.getPropertyValue('--secondary').trim()];
        });
        expect(hex(ink)).toBe(textRole.toUpperCase());
        expect(hex(fill)).toBe(surface.toUpperCase());
        expect(colorContrast(hex(ink), hex(fill))).toBeGreaterThanOrEqual(4.5);
      }
    }
  }
});


test('Neon keeps the chosen turquoise and a readable catalogue action', async ({ page }) => {
  await page.goto('/ru/');
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  const editor = page.locator('.appearance-section');
  const action = page.locator('.hero-slate').getByRole('link', { name: 'Каталог компонентов' });
  await editor.getByRole('textbox', { name: 'Основной цвет', exact: true }).fill('#0FFFE3');
  await editor.getByRole('combobox', { name: 'Стиль палитры' }).click();
  await page.getByRole('option', { name: 'Neon', exact: true }).click();
  for (const mode of ['light', 'dark'] as const) {
    await chooseTheme(page, mode);
    await expect(page.locator('html')).toHaveAttribute('data-applied-primary', '#0FFFE3');
    await expect(page.locator('.slate-color')).toHaveCSS('background-color', 'rgb(15, 255, 227)');
    await expect(action).toHaveCSS('background-color', 'rgb(15, 255, 227)');
    await expect(action).toHaveCSS('color', 'rgb(27, 28, 36)');
    await expect(action.locator('svg')).toHaveCSS('color', 'rgb(27, 28, 36)');
    await action.hover();
    await expect(action).toHaveCSS('background-color', 'rgb(0, 250, 220)');
    await page.mouse.down();
    try {
      await expect(action).toHaveCSS('background-color', 'rgb(0, 229, 202)');
      await expect(action).toHaveCSS('color', 'rgb(27, 28, 36)');
    } finally {
      await page.mouse.move(0, 0);
      await page.mouse.up();
    }
  }
  await editor.getByRole('textbox', { name: 'Основной цвет', exact: true }).fill('#307066');
  await editor.getByRole('combobox', { name: 'Стиль палитры' }).click();
  await page.getByRole('option', { name: 'Contrast', exact: true }).click();
  for (const mode of ['light', 'dark'] as const) {
    await chooseTheme(page, mode);
    await expect(action).toHaveCSS('color', 'rgb(255, 255, 255)');
    await expect(action.locator('svg')).toHaveCSS('color', 'rgb(255, 255, 255)');
  }
});

test('appearance follows the header selection across both adapters', async ({ page }) => {
  test.setTimeout(90000);
  await page.setViewportSize({ width: 375, height: 900 });
  await page.goto('/');
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  const root = page.locator('html');
  const trigger = page.getByRole('button', { name: 'Appearance', exact: true });
  await trigger.click();
  const editor = page.getByRole('dialog', { name: 'Appearance', exact: true });
  const hex = editor.getByRole('textbox', { name: 'Primary color' });
  await hex.fill('#bad');
  await expect(hex).toHaveAttribute('aria-invalid', 'true');
  await expect(root).toHaveAttribute('data-primary-color', '#5962F0');
  await hex.fill('#FFFFBB');
  await expect(root).toHaveAttribute('data-primary-color', '#FFFFBB');
  await expect(hex).toHaveValue('#FFFFBB');
  await hex.fill(seed);
  await editor.getByRole('combobox', { name: 'Palette style' }).click();
  await page.getByRole('option', { name: 'Acid', exact: true }).click();
  await editor.getByRole('combobox', { name: 'Typography preset' }).click();
  await page.getByRole('option', { name: 'Pixel', exact: true }).click();
  await expect(root).toHaveAttribute('data-primary-color', seed);
  await expect(root).toHaveAttribute('data-typography', 'pixel');
  await expect(root).toHaveAttribute('data-palette-style', 'acid');
  await expect(page.locator('.hero-heading h1')).toHaveCSS('font-family', /Pixelify Sans/);
  await page.keyboard.press('Escape');
  await expect(trigger).toBeFocused();
  await expect.poll(() => page.evaluate(() => document.documentElement.scrollWidth)).toBeLessThanOrEqual(375);

  await page.goto('/react/?section=inputs');
  await expect(root).toHaveAttribute('data-typography', 'pixel');
  for (const theme of ['dark', 'light'] as const) {
    await chooseTheme(page, theme);
    const resolved = createThemeVariables({ theme, primaryColor: seed, paletteStyle: 'acid' });
    await expect(root).toHaveAttribute('data-applied-primary', resolved['--primary']!);
  }

  await page.goto('/ja/flutter/?section=inputs');
  const stage = page.locator('[data-flutter-stage]');
  await expect(stage).toHaveAttribute('data-state', 'ready', { timeout: 45000 });
  const child = page.frameLocator('[data-flutter-frame]').locator('html');
  await expect(child).toHaveAttribute('data-typography', 'pixel');
  await expect(child).toHaveAttribute('data-palette-style', 'acid');
  await expect(child).toHaveAttribute('data-primary-color', seed);
  const iframe = await page.locator('[data-flutter-frame]').getAttribute('src');
  await page.getByRole('button', { name: '外観', exact: true }).click();
  await page.getByRole('button', { name: '外観をリセット', exact: true }).click();
  await expect(child).toHaveAttribute('data-typography', 'brand');
  await expect(child).toHaveAttribute('data-primary-color', '#5962F0');
  await expect(page.locator('[data-flutter-frame]')).toHaveAttribute('src', iframe!);
  await expect(page.locator('[data-flutter-standalone]')).toHaveAttribute('href', /typographyPreset=brand/);
  await page.reload();
  await expect(root).toHaveAttribute('data-palette-style', 'contrast');
});

test('landing preview shares settings and the framework journey keeps its height', async ({ page }) => {
  await page.setViewportSize({ width: 375, height: 900 });
  await page.goto('/ru/');
  const editor = page.locator('.appearance-section');
  const track = editor.locator('.appearance-track');
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  await editor.getByRole('textbox', { name: 'Основной цвет', exact: true }).fill('#22DD88');
  await expect(page.locator('html')).toHaveAttribute('data-primary-color', '#22DD88');
  await editor.locator('.appearance-preview-heading button').last().click();
  await expect.poll(() => track.evaluate(element => element.scrollLeft)).toBeGreaterThan(0);
  const journey = page.locator('.journey');
  await page.evaluate(() => document.fonts.ready);
  const height = await journey.evaluate(element => element.clientHeight);
  await page.getByRole('button', { name: 'Выберите фреймворк: React' }).click();
  await expect.poll(() => journey.evaluate(element => element.clientHeight)).toBe(height);
  await page.getByRole('button', { name: 'Я установил', exact: true }).click();
  await expect.poll(() => journey.evaluate(element => element.clientHeight)).toBe(height);
});

test('landing lightning uses palette colors and the automatic glow leaves text color alone', async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'no-preference' });
  await page.goto('/');
  const bolt = page.locator('.landing-hero .lightning-primary');
  await expect(bolt).toHaveCSS('animation-duration', '9s');
  const color = () => bolt.evaluate(element => (element as SVGElement).style.getPropertyValue('--lightning-color'));
  await expect.poll(color).toMatch(/^var\(--(?:primary|success|info|warning|error)\)$/);
  const start = await color();
  await bolt.evaluate(element => element.dispatchEvent(new AnimationEvent('animationiteration', { bubbles: true })));
  await expect.poll(color).not.toBe(start);
  const glow = page.locator('.fire-headline canvas');
  await expect(glow).toBeVisible();
  expect(await glow.evaluate(element => (element.parentElement as HTMLElement).style.getPropertyValue('--fire-letter-color'))).toBe('');
  await page.emulateMedia({ reducedMotion: 'reduce' });
  await expect(glow).toBeHidden();
  await expect(bolt).toHaveCSS('animation-name', 'none');
});
