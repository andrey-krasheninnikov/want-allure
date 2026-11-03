import { test, expect } from '@playwright/test';

test('restores current theme across history and persisted lifecycle events', async ({ page }) => {
  await page.goto('/react/');
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  await page.getByRole('switch', { name: 'Dark theme', exact: true }).check();
  await page.getByRole('navigation', { name: 'Main navigation' }).getByRole('link', { name: 'Overview', exact: true }).click();
  await page.getByRole('switch', { name: 'Dark theme', exact: true }).uncheck();
  await page.goBack();
  await expect(page).toHaveURL(/\/react\/$/);
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'light');
  await expect(page.getByRole('switch', { name: 'Component theme', exact: true })).not.toBeChecked();
  // Browsers may reload history entries; exercise the persisted lifecycle explicitly too.
  await page.evaluate(() => {
    dispatchEvent(new PageTransitionEvent('pagehide', { persisted: true }));
    localStorage.setItem('want-theme', 'dark');
    dispatchEvent(new PageTransitionEvent('pageshow', { persisted: true }));
  });
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'dark');
  await expect(page.getByRole('switch', { name: 'Component theme', exact: true })).toBeChecked();
  await page.goForward();
  await expect(page).toHaveURL(/:\d+\/$/);
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'dark');
});
