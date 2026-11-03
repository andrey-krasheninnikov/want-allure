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
  await expect(page.locator('.hero-note a')).toHaveCount(0);
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
  await expect(page.locator('.landing-final h2, .landing-final p')).toHaveCount(0);
  const back=page.getByRole('link',{name:'See the details in action',exact:true});
  await expect(back).toHaveAttribute('href','#main');
  await expect(back).toHaveAccessibleDescription('Back to top');
  await expect(page.locator('.landing-final .ui-glow')).toHaveCount(1);
  await expect(page.locator('.footer-credit')).toContainText('2026 ©');
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

for(const locale of ['ru','ar'])test(`headline glow stays inside the viewport in ${locale}`,async({page})=>{
  await page.emulateMedia({reducedMotion:'no-preference'});
  await page.goto(`/${locale}/`);await page.evaluate(()=>document.fonts.ready);
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  const surface=page.locator('.fire-headline canvas');
  for(const width of [320,360,390,768,1440])for(const theme of ['light','dark']){
    await page.setViewportSize({width,height:1000});
    await page.evaluate(theme=>{document.documentElement.dataset.theme=theme;},theme);
    await page.evaluate(()=>scrollTo({top:0,behavior:'instant'}));
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
      await page.mouse.move(letter.x,letter.y);await expect(surface).toBeVisible();
      expect(await page.evaluate(()=>document.documentElement.scrollWidth)).toBe(width);
      await page.mouse.move(0,0);await expect(surface).toBeHidden();
      expect(await page.evaluate(()=>document.documentElement.scrollWidth)).toBe(width);
    }
  }
  await page.locator('.fire-headline').evaluate(element=>element.dispatchEvent(new PointerEvent('pointermove',{clientX:element.getBoundingClientRect().left,clientY:element.getBoundingClientRect().top})));
  await page.evaluate(()=>dispatchEvent(new Event('scroll')));await expect(surface).toBeHidden();
});

test('headline colors follow a theme change during hover and respect motion preferences',async({page})=>{
  await page.emulateMedia({reducedMotion:'no-preference'});await page.goto('/');
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);await page.evaluate(()=>document.fonts.ready);
  await page.getByRole('switch',{name:'Dark theme',exact:true}).check();
  const point=await page.locator('.fire-headline').evaluate(element=>{
    const node=element.firstChild!,range=document.createRange();range.setStart(node,1);range.setEnd(node,2);
    const rect=range.getBoundingClientRect();return{x:rect.left+rect.width*.25,y:rect.top+rect.height*.5};
  });
  const surface=page.locator('.fire-headline canvas'),heading=page.locator('.fire-headline');
  await page.mouse.move(point.x,point.y);await expect(surface).toBeVisible();
  await expect.poll(()=>heading.evaluate(el=>parseInt(el.style.getPropertyValue('--fire-letter-color').match(/\d+/g)?.[0]??'0'))).toBeGreaterThan(200);
  await page.evaluate(()=>dispatchEvent(new CustomEvent('want:choose-theme',{detail:'light'})));
  await expect.poll(()=>heading.evaluate(el=>parseInt(el.style.getPropertyValue('--fire-letter-color').match(/\d+/g)?.[0]??'255'))).toBeLessThan(180);
  await expect(surface).toBeVisible();
  await page.evaluate(()=>dispatchEvent(new Event('scroll')));await expect(surface).toBeHidden();
  await page.mouse.move(point.x+1,point.y);await expect(surface).toBeVisible();
  await page.emulateMedia({reducedMotion:'reduce'});await expect(surface).toBeHidden();
});
