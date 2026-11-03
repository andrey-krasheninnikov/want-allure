import { test, expect } from '@playwright/test';
import { category } from './helpers';

test('category navigation keeps form edits, slider values and history',async({page})=>{
  await page.goto('/react/?section=inputs');
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  const title=page.getByRole('textbox',{name:'Wallpaper title',exact:true});
  await title.fill('Personal template');
  const slider=page.getByRole('slider',{name:'Intensity',exact:true});
  await slider.focus();await slider.press('ArrowRight');await expect(slider).toHaveAttribute('aria-valuenow','43');
  await page.getByRole('switch',{name:'Right to left',exact:true}).check();
  await slider.focus();await slider.press('ArrowLeft');await expect(slider).toHaveAttribute('aria-valuenow','44');
  const range=page.getByRole('slider',{name:'Range start',exact:true});await range.focus();await range.press('Home');await expect(range).toHaveAttribute('aria-valuenow','0');
  await category(page,'navigation');await expect(title).toBeHidden();
  await page.goBack();await expect(title).toHaveValue('Personal template');await expect(slider).toHaveAttribute('aria-valuenow','44');
  await category(page,'foundation');await category(page,'inputs');await expect(title).toHaveValue('Personal template');
  await expect(page.getByRole('switch',{name:'Right to left',exact:true})).toHaveCount(1);
});

test('home guides framework selection, installation and advice',async({page})=>{
  const errors:string[]=[];page.on('pageerror',error=>errors.push(error.message));
  await page.goto('/');
  await expect(page.locator('.landing-hero .logo-stage')).toHaveAttribute('data-ready','true');
  await expect(page.locator('.hero-note .icon-actions a')).toHaveCount(2);
  await expect(page.getByRole('button',{name:'Reset rotation',exact:true})).toHaveCount(0);
  await expect(page.getByRole('button',{name:'Pause effects',exact:true})).toHaveCount(0);
  await expect(page.locator('.journey')).toHaveAttribute('data-step','choose');
  await page.getByRole('button',{name:'Choose your framework: React',exact:true}).click();
  await expect(page.locator('.journey')).toHaveAttribute('data-step','install');
  await expect(page.locator('.journey-install')).toContainText('want-design-install');
  await expect(page.locator('.journey-install')).toContainText('npm install @want-foundation/allure@1.2.0');
  await page.getByRole('button',{name:'I have installed it',exact:true}).click();
  await expect(page.locator('.journey')).toHaveAttribute('data-step','learn');
  await expect(page.locator('.tips-track')).toBeVisible();
  await page.getByRole('button',{name:'Next tip',exact:true}).click();
  await expect(page.locator('.tip-count')).toHaveText('2 / 7');
  await expect(page.locator('.landing-final a')).toHaveCount(1);
  await expect(page.locator('.footer-credit')).toHaveAttribute('href','https://t.me/andrey_krasheninnikov');
  expect(errors).toEqual([]);
});

test('lightning follows system motion and viewport visibility',async({page})=>{
  await page.emulateMedia({reducedMotion:'no-preference'});await page.goto('/');
  const effect=page.locator('.landing-hero [data-slot=lightning-background]');
  await expect(effect).toHaveAttribute('data-paused','false');
  await expect(effect).toHaveCSS('pointer-events','none');
  await expect(effect.locator('.lightning-primary')).toHaveCSS('animation-duration','3s');
  await page.emulateMedia({reducedMotion:'reduce'});await expect(effect).toHaveAttribute('data-paused','true');
  await page.emulateMedia({reducedMotion:'no-preference'});await expect(effect).toHaveAttribute('data-paused','false');
  await page.locator('.site-footer').scrollIntoViewIfNeeded();await expect(effect).toHaveAttribute('data-paused','true');
});

test('logo asset failure preserves the supplied SVG fallback',async({page})=>{
  await page.route('**/brand/logos/dark/transparent.svg',route=>route.request().resourceType()==='fetch'?route.abort():route.continue());
  await page.goto('/');
  await expect(page.locator('.landing-hero .logo-stage-fallback')).toBeVisible();
  await expect(page.locator('.landing-hero .logo-stage')).toHaveAttribute('data-ready','false');
});

test('Flutter shares category and RTL without replacing its engine',async({page})=>{
  await page.emulateMedia({reducedMotion:'no-preference'});
  await page.goto('/flutter/?section=effects');
  await expect(page.locator('[data-flutter-stage]')).toHaveAttribute('data-state','ready',{timeout:45000});
  const frame=page.frames().find(item=>item.url().includes('/_flutter/'))!;
  await frame.evaluate(()=>{(window as Window&{previewIdentity?:number}).previewIdentity=123;});
  await page.getByRole('switch',{name:'Right to left',exact:true}).check();
  await expect.poll(()=>frame.evaluate(()=>document.documentElement.dir)).toBe('rtl');
  await frame.evaluate(()=>parent.postMessage({type:'want-allure:choose-section',section:'data'},location.origin));
  await expect(page).toHaveURL(/section=data/);
  await page.goBack();await expect(page).toHaveURL(/section=effects/);
  expect(await frame.evaluate(()=>(window as Window&{previewIdentity?:number}).previewIdentity)).toBe(123);
});
