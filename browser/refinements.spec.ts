import { resolveBrandProfile } from '../packages/foundation/dist/index.js';
import { test, expect } from '@playwright/test';
import { category, chooseTheme } from './helpers';

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
  await expect(page.locator('.landing-hero .logo-stage-fallback')).toBeVisible();
  await expect(page.locator('.landing-hero .logo-stage')).toHaveAttribute('data-ready','false');
  await expect(page.locator('.hero-note a')).toHaveCount(0);
  await expect(page.getByRole('button',{name:'Reset rotation',exact:true})).toHaveCount(0);
  await expect(page.getByRole('button',{name:'Pause effects',exact:true})).toHaveCount(0);
  await expect(page.locator('.journey')).toHaveAttribute('data-step','choose');
  await page.getByRole('button',{name:'Choose your framework: React',exact:true}).click();
  await expect(page.locator('.journey')).toHaveAttribute('data-step','install');
  await expect(page.locator('.journey-install')).toContainText('want-design-install');
  await expect(page.locator('.journey-install')).toContainText('npm install @want-foundation/allure@1.4.0');
  await page.getByRole('button',{name:'I have installed it',exact:true}).click();
  await expect(page.locator('.journey')).toHaveAttribute('data-step','learn');
  await expect(page.locator('.tips-track')).toBeVisible();
  await page.getByRole('button',{name:'Next tip',exact:true}).click();
  await expect(page.locator('.tip-count')).toHaveText('2 / 7');
  await expect(page.locator('.landing-final')).toHaveCount(0);
  await expect(page.locator('.footer-credit')).toContainText('2026 ©');
  await expect(page.locator('.footer-credit')).toHaveAttribute('href','https://t.me/andrey_krasheninnikov');
  expect(errors).toEqual([]);
});

test('catalogue lightning follows system motion and viewport visibility',async({page})=>{
  await page.emulateMedia({reducedMotion:'no-preference'});await page.goto('/react/?section=effects');
  const effect=page.locator('.lightning-preview [data-slot=lightning-background]');
  await effect.scrollIntoViewIfNeeded();
  await expect(effect).toHaveAttribute('data-paused','false');
  await expect(effect).toHaveCSS('pointer-events','none');
  await expect(effect.locator('.lightning-primary')).toHaveCSS('animation-duration','9s');
  await page.emulateMedia({reducedMotion:'reduce'});await expect(effect.locator('.lightning-primary')).toHaveCSS('animation-name','none');
  await page.emulateMedia({reducedMotion:'no-preference'});await expect(effect.locator('.lightning-primary')).toHaveCSS('animation-name','want-lightning');
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

for(const locale of ['ru','ar'])test(`headline glow stays inside the viewport in ${locale}`,async({page})=>{
  await page.emulateMedia({reducedMotion:'no-preference'});
  await page.goto(`/${locale}/`);await page.evaluate(()=>document.fonts.ready);
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  const surface=page.locator('.fire-headline canvas');
  const hoverInk = () => surface.evaluate(element => (element.parentElement as HTMLElement).style.getPropertyValue('--fire-letter-color'));
  for(const width of [320,360,390,768,1440])for(const theme of ['light','dark']){
    await page.setViewportSize({width,height:1000});
    await page.evaluate(theme=>{document.documentElement.dataset.theme=theme;},theme);
    await page.evaluate(()=>scrollTo({top:0,behavior:'instant'}));
    await page.evaluate(()=>new Promise<void>(resolve=>requestAnimationFrame(()=>requestAnimationFrame(()=>resolve()))));
    const letters=await page.locator('.fire-headline').evaluate(element=>{
      const walker=document.createTreeWalker(element,NodeFilter.SHOW_TEXT),rects:{x:number;y:number}[]=[];
      while(walker.nextNode()){
        const node=walker.currentNode,text=node.textContent??'';
        for(const item of new Intl.Segmenter(document.documentElement.lang,{granularity:'grapheme'}).segment(text)){
          if(!item.segment.trim())continue;
          const range=document.createRange();range.setStart(node,item.index);range.setEnd(node,item.index+item.segment.length);
          const rect=range.getBoundingClientRect();rects.push({x:rect.left+rect.width*.25,y:rect.top+rect.height*.5});
        }
      }
      return [rects.reduce((a,b)=>a.x<b.x?a:b),rects.reduce((a,b)=>a.x>b.x?a:b)];
    });
    for(const letter of letters){
      await page.mouse.move(letter.x,letter.y);await expect.poll(hoverInk).not.toBe('');
      await expect(surface).toBeVisible();
      expect(await page.evaluate(()=>document.documentElement.scrollWidth)).toBe(width);
      await page.mouse.move(0,0);await expect.poll(hoverInk).toBe('');
      expect(await page.evaluate(()=>document.documentElement.scrollWidth)).toBe(width);
    }
  }
  await page.locator('.fire-headline').evaluate(element=>element.dispatchEvent(new PointerEvent('pointermove',{clientX:element.getBoundingClientRect().left,clientY:element.getBoundingClientRect().top})));
  expect(await surface.evaluate(element=>{dispatchEvent(new Event('scroll'));return (element as HTMLElement).hidden;})).toBe(true);
});

test('headline colors follow a theme change during hover and respect motion preferences',async({page})=>{
  await page.emulateMedia({reducedMotion:'no-preference'});await page.goto('/');
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);await page.evaluate(()=>document.fonts.ready);
  await chooseTheme(page, 'dark');
  const point=await page.locator('.fire-headline').evaluate(element=>{
    const node=element.firstChild!,range=document.createRange();range.setStart(node,1);range.setEnd(node,2);
    const rect=range.getBoundingClientRect();return{x:rect.left+rect.width*.25,y:rect.top+rect.height*.5};
  });
  const surface=page.locator('.fire-headline canvas'),heading=page.locator('.fire-headline');
  await page.mouse.move(point.x,point.y);await expect(surface).toBeVisible();
  const matchesTheme = async (theme: 'dark'|'light') => {
    const vars = resolveBrandProfile({schemaVersion:1},theme);
    const colors = ['primary','info','warning','error','success'].map(role=>vars['--'+role+'-text'].slice(1).match(/../g)!.map(pair=>parseInt(pair,16)));
    const ink = await heading.evaluate(el=>el.style.getPropertyValue('--fire-letter-color').match(/\d+/g)?.map(Number));
    if (!ink?.length) return false;
    return colors.some((a,i)=>{
      const b=colors[(i+1)%colors.length], delta=b.map((value,j)=>value-a[j]);
      const longest=delta.reduce((best,value,j)=>Math.abs(value)>Math.abs(delta[best])?j:best,0);
      const fraction=delta[longest]?(ink[longest]-a[longest])/delta[longest]:0;
      return fraction>=-.02 && fraction<=1.02 && a.every((value,j)=>Math.abs(value+delta[j]*fraction-ink[j])<2);
    });
  };
  await expect.poll(()=>matchesTheme('dark')).toBe(true);
  await page.evaluate(()=>dispatchEvent(new CustomEvent('want:choose-theme',{detail:'light'})));
  await expect.poll(()=>matchesTheme('light')).toBe(true);
  await expect(surface).toBeVisible();
  expect(await surface.evaluate(element=>{dispatchEvent(new Event('scroll'));return (element as HTMLElement).hidden;})).toBe(true);
  await page.mouse.move(point.x+1,point.y);await expect(surface).toBeVisible();
  await page.emulateMedia({reducedMotion:'reduce'});await expect(surface).toBeHidden();
});
