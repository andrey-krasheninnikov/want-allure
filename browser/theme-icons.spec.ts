import {test,expect} from '@playwright/test';

test('favicons follow the selected theme across reload, system changes and both catalogues',async({page})=>{
  test.setTimeout(60000);
  const icons=async(theme:'light'|'dark')=>{
    await expect(page.locator('link[data-theme-icon="favicon-512.svg"]')).toHaveAttribute('href',`/favicon/${theme}/favicon-512.svg`);
    await expect(page.locator('link[data-theme-icon="favicon.ico"]')).toHaveAttribute('href',`/favicon/${theme}/favicon.ico`);
    await expect(page.locator('link[rel="apple-touch-icon"]')).toHaveAttribute('href',`/favicon/${theme}/apple-touch-icon.png`);
  };
  await page.emulateMedia({colorScheme:'light'});await page.goto('/');await icons('light');
  await page.getByRole('switch',{name:'Dark theme',exact:true}).check();await icons('dark');
  await page.reload();await icons('dark');
  await page.goto('/react/');await icons('dark');
  await page.getByRole('switch',{name:'Component theme',exact:true}).uncheck();await icons('light');
  await page.evaluate(()=>{
    localStorage.setItem('want-theme','dark');
    dispatchEvent(new PageTransitionEvent('pageshow',{persisted:true}));
  });await icons('dark');
  await page.evaluate(()=>localStorage.removeItem('want-theme'));await page.reload();await icons('light');
  await page.emulateMedia({colorScheme:'dark'});await icons('dark');
  await page.goto('/flutter/');
  await expect(page.locator('[data-flutter-stage]')).toHaveAttribute('data-state','ready',{timeout:45000});
  const frame=page.frames().find(frame=>frame.url().includes('/_flutter/'))!;
  for(const theme of ['light','dark'] as const){
    await page.getByRole('switch',{name:'Dark theme',exact:true}).setChecked(theme==='dark');await icons(theme);
    await expect(frame.locator('link[rel="icon"]')).toHaveAttribute('href',`favicon/${theme}/favicon-512.svg`);
    await expect(frame.locator('link[rel="apple-touch-icon"]')).toHaveAttribute('href',`favicon/${theme}/apple-touch-icon.png`);
  }
  await page.goto('/_flutter/?theme=light');
  await expect(page.locator('link[rel="icon"]')).toHaveAttribute('href','favicon/light/favicon-512.svg');
  await page.goto('/_flutter/?theme=dark');
  await expect(page.locator('link[rel="icon"]')).toHaveAttribute('href','favicon/dark/favicon-512.svg');
});
