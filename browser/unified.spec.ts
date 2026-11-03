import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

for (const locale of ['en', 'ru']) for (const width of [320, 1440]) {
  test(`landing ${locale} at ${width}px stays accessible and does not load Flutter`, async ({ page }, testInfo) => {
    await page.setViewportSize({ width, height: 1000 });
    const runtime: string[] = [];
    const errors: string[] = [];
    page.on('request', request => { if (request.url().includes('/_flutter/')) runtime.push(request.url()); });
    page.on('pageerror', error => errors.push(error.message));
    await page.goto(locale === 'ru' ? '/ru/' : '/');
    await page.evaluate(() => document.fonts.ready);
    await expect(page.locator('html')).toHaveAttribute('lang', locale);
    await expect(page.locator('h1')).toContainText(locale === 'ru' ? 'Единый язык интерфейсов.' : 'One design language.');
    for (const theme of ['light', 'dark']) {
      await page.getByRole('switch').setChecked(theme === 'dark');
      await expect(page.locator('html')).toHaveAttribute('data-theme', theme);
      expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true);
      const result = await new AxeBuilder({ page }).withTags(['wcag2a', 'wcag2aa', 'wcag21aa']).analyze();
      expect(result.violations.map(item => ({ id: item.id, targets: item.nodes.map(node => node.target) }))).toEqual([]);
      await page.screenshot({ path: testInfo.outputPath(`landing-${locale}-${width}-${theme}.png`) });
    }
    expect(runtime).toEqual([]);
    expect(errors).toEqual([]);
  });
}

test('locale links preserve the selected section and saved theme', async ({ page }) => {
  await page.goto('/react/');
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  await page.getByRole('switch', { name: 'Dark theme' }).check();
  await page.getByRole('link', { name: 'Switch to Russian' }).click();
  await expect(page).toHaveURL(/\/ru\/react\/$/);
  await expect(page.getByRole('heading', { name: 'Общий дизайн.' })).toBeVisible();
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'dark');
  await expect(page.getByRole('button', { name: 'Открыть диалог', exact: true })).toBeVisible();
  await page.reload();
  await expect(page.getByRole('heading', { name: 'Общий дизайн.' })).toBeVisible();
  await page.getByRole('link', { name: 'Switch to English' }).click();
  await expect(page).toHaveURL(/\/react\/$/);
  await page.goBack();
  await expect(page).toHaveURL(/\/ru\/react\/$/);
});

test('Flutter synchronizes theme without restarting and rejects unrelated messages', async ({ page }, testInfo) => {
  test.setTimeout(60000);
  await page.goto('/ru/flutter/');
  const stage = page.locator('[data-flutter-stage]');
  await expect(stage).toHaveAttribute('data-state', 'ready', { timeout: 45000 });
  const box = await page.locator('[data-flutter-frame]').boundingBox();
  expect(box!.height).toBeGreaterThan(page.viewportSize()!.height * .6);
  const frame = page.frames().find(frame => frame.url().includes('/_flutter/'))!;
  expect(frame).toBeTruthy();
  await expect.poll(() => frame.evaluate(() => document.documentElement.lang)).toBe('ru');
  await frame.evaluate(() => { (window as Window & { catalogueIdentity?: string }).catalogueIdentity = 'preserved'; });
  for (const theme of ['light', 'dark']) {
    await page.getByRole('switch').setChecked(theme === 'dark');
    await expect.poll(() => frame.evaluate(() => document.documentElement.dataset.theme)).toBe(theme);
    expect(await frame.evaluate(() => (window as Window & { catalogueIdentity?: string }).catalogueIdentity)).toBe('preserved');
    await page.screenshot({ path: testInfo.outputPath(`flutter-ru-${theme}.png`) });
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true);
  }
  await page.setViewportSize({ width: 320, height: 900 });
  const narrow = await page.locator('[data-flutter-frame]').boundingBox();
  expect(narrow!.height).toBeGreaterThan(540);
  await page.screenshot({ path: testInfo.outputPath('flutter-ru-320.png') });
  await page.evaluate(() => window.postMessage({ type: 'want-allure:error' }, location.origin));
  await expect(stage).toHaveAttribute('data-state', 'ready');
  await page.reload();
  await expect(stage).toHaveAttribute('data-state', 'ready', { timeout: 45000 });
});

test('Flutter initialization failure offers retry and recovers', async ({ page }) => {
  test.setTimeout(65000);
  await page.route('**/_flutter/main.dart.js', route => route.abort());
  await page.goto('/flutter/');
  await expect(page.locator('[data-flutter-stage]')).toHaveAttribute('data-state', 'error', { timeout: 50000 });
  await expect(page.getByRole('alert')).toContainText('Could not start');
  await page.unroute('**/_flutter/main.dart.js');
  await page.getByRole('button', { name: 'Try again', exact: true }).click();
  await expect(page.locator('[data-flutter-stage]')).toHaveAttribute('data-state', 'ready', { timeout: 45000 });
});
