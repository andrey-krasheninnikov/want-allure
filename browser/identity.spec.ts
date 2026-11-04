import { test, expect } from '@playwright/test';

test('live slate changes framework and light through public controls', async ({ page }) => {
  await page.goto('/');
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  const slate = page.locator('.hero-slate');
  for (const theme of ['light', 'dark']) {
    await page.getByRole('switch', { name:'Dark theme', exact:true }).setChecked(theme === 'dark');
    await slate.getByRole('tab', { name:'Flutter', exact:true }).click();
    await expect(slate.getByRole('tabpanel')).toContainText('ForUI');
    await expect(slate.getByRole('link', { name:'Component catalogue' })).toHaveAttribute('href','/flutter/');
    await slate.getByRole('tab', { name:'React', exact:true }).click();
    await expect(slate.getByRole('tabpanel')).toContainText('Radix');
    await expect(slate.getByRole('link', { name:'Component catalogue' })).toHaveAttribute('href','/react/');
  }
  const slider = slate.getByRole('slider', { name:'Light and space', exact:true });
  await slider.focus();
  await slider.press('ArrowRight');
  await expect(slider).toHaveAttribute('aria-valuenow','61');
  await expect(slate.locator('.slate-reading')).toHaveText('61%');
  await expect(page.locator('.landing-hero [data-slot="lightning-background"]')).toHaveCount(0);
});

test('feather introduction settles and manual rotation stays available', async ({ page }) => {
  await page.emulateMedia({ reducedMotion:'no-preference' });
  await page.goto('/');
  const logo = page.locator('.landing-hero .logo-stage');
  await expect(logo).toHaveAttribute('data-ready','true');
  await page.waitForTimeout(5200);
  const canvas = logo.locator('canvas');
  const settled = await canvas.screenshot();
  await page.waitForTimeout(300);
  expect((await canvas.screenshot()).equals(settled)).toBe(true);
  await logo.focus();
  await logo.press('ArrowRight');
  expect((await canvas.screenshot()).equals(settled)).toBe(false);
});


test('semantic link overrides still reach link buttons', async ({ page }) => {
  await page.goto('/react/?section=inputs');
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  await page.evaluate(() => document.documentElement.style.setProperty('--link','#276B53'));
  await expect(page.getByRole('button',{name:'link',exact:true})).toHaveCSS('color','rgb(39, 107, 83)');
});
