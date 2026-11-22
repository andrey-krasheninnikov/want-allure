import { chooseTheme } from './helpers';
import {test,expect} from '@playwright/test';

test('favicons follow the selected theme across reload, system changes and both catalogues',async({page})=>{
  test.setTimeout(60000);
  const icons=async(theme:'light'|'dark')=>{
    await expect(page.locator('link[data-theme-icon="favicon-512.svg"]')).toHaveAttribute('href',`/favicon/${theme}/favicon-512.svg`);
    await expect(page.locator('link[data-theme-icon="favicon.ico"]')).toHaveAttribute('href',`/favicon/${theme}/favicon.ico`);
    await expect(page.locator('link[rel="apple-touch-icon"]')).toHaveAttribute('href',`/favicon/${theme}/apple-touch-icon.png`);
  };
  await page.emulateMedia({colorScheme:'light'});await page.goto('/');await icons('light');
  await chooseTheme(page, 'dark');await icons('dark');
  await page.reload();await icons('dark');
  await page.goto('/react/');await icons('dark');
  await page.getByRole('switch',{name:'Component theme',exact:true}).uncheck();await icons('light');
  await page.evaluate(()=>{
    localStorage.setItem('want-theme','dark');
    dispatchEvent(new PageTransitionEvent('pageshow',{persisted:true}));
  });await icons('dark');
  await chooseTheme(page, 'system');await icons('light');await page.reload();await icons('light');
  await page.emulateMedia({colorScheme:'dark'});await icons('dark');
  await page.goto('/flutter/');
  await expect(page.locator('[data-flutter-stage]')).toHaveAttribute('data-state','ready',{timeout:45000});
  const frame=page.frames().find(frame=>frame.url().includes('/_flutter/'))!;
  for(const theme of ['light','dark'] as const){
    await chooseTheme(page, theme);await icons(theme);
    await expect(frame.locator('link[rel="icon"]')).toHaveAttribute('href',`favicon/${theme}/favicon-512.svg`);
    await expect(frame.locator('link[rel="apple-touch-icon"]')).toHaveAttribute('href',`favicon/${theme}/apple-touch-icon.png`);
  }
  await page.emulateMedia({colorScheme:'light'});
  await page.goto('/_flutter/');
  await expect(page.locator('body')).toHaveCSS('background-color','rgb(247, 247, 250)',{timeout:30000});
  await page.emulateMedia({colorScheme:'dark'});
  await expect(page.locator('body')).toHaveCSS('background-color','rgb(13, 13, 15)');
  await page.goto('/_flutter/?theme=light');
  await expect(page.locator('body')).toHaveCSS('background-color','rgb(247, 247, 250)',{timeout:30000});
  await expect(page.locator('link[rel="icon"]')).toHaveAttribute('href','favicon/light/favicon-512.svg');
  await page.goto('/_flutter/?theme=dark');
  await expect(page.locator('link[rel="icon"]')).toHaveAttribute('href','favicon/dark/favicon-512.svg');
});
