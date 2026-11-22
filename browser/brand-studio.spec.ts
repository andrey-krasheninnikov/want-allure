import { expect, test } from '@playwright/test';

test('a profile survives navigation, while an invalid import leaves the two previews intact',async({page})=>{
  await page.setViewportSize({width:375,height:900});
  await page.goto('/');
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  const header=await page.locator('.header-bar').boundingBox();
  expect(header!.height).toBeLessThan(84);
  const studio=page.locator('[data-brand-studio]');
  await studio.getByText('Brand profile',{exact:true}).click();
  await studio.getByText('JSON · v1',{exact:true}).click();
  const json=studio.getByRole('textbox',{name:'JSON',exact:true});
  const profile={schemaVersion:1,brandColor:'#8A370C',radii:{field:6},density:'compact',motion:'off',fonts:{display:'Manrope'},icons:{confirm:'star'}};
  await json.fill(JSON.stringify(profile));
  await studio.getByRole('button',{name:'Apply JSON'}).click();
  for(const mode of ['dark','light']){
    const preview=studio.locator('[data-allure-scope][data-theme="'+mode+'"]');
    await expect(preview).toHaveCSS('--brand-color',profile.brandColor);
    await expect(preview).toHaveCSS('--radius','6px');
    await expect(preview).toHaveAttribute('data-density','compact');
  }
  await json.fill('{"schemaVersion":1,"radii":{"field":-2}}');
  await studio.getByRole('button',{name:'Apply JSON'}).click();
  await expect(studio.getByRole('alert')).toContainText('radii.field');
  await expect(studio.locator('[data-allure-scope]').first()).toHaveCSS('--radius','6px');
  const download=page.waitForEvent('download');
  await studio.getByRole('button',{name:'Download JSON'}).click();
  expect((await download).suggestedFilename()).toBe('allure-brand.json');
  await page.goto('/react/?studio=1&section=inputs');
  await expect(page.locator('[data-allure-scope]').first()).toHaveAttribute('data-density','compact');
  expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth)).toBe(true);
});

test('deep links find families by public symbol and survive browser history',async({page})=>{
  await page.goto('/ja/react/');
  await page.getByRole('searchbox').fill('WantTable');
  await page.locator('.catalogue-finder li a').first().click();
  await expect(page).toHaveURL(url=>url.searchParams.get('section')==='data' && url.searchParams.get('component')==='Table');
  await expect(page.locator('#api-Table')).toBeFocused();
  await expect(page.locator('#api-Table pre')).toContainText("from '@want-foundation/allure-react'");
  await expect(page.locator('#api-Table a').first()).toHaveAttribute('href','/ja/flutter/?section=data&component=Table');
  await page.reload();
  await expect(page.locator('#api-Table')).toBeVisible();
  await page.goBack();
  await expect(page).toHaveURL(/\/ja\/react\/$/);
});

test('reduced motion reads the SVG first and loads Three only after manual rotation',async({page})=>{
  const models:string[]=[];
  page.on('request',req=>{if(/logo-three[.]/.test(req.url()))models.push(req.url());});
  await page.emulateMedia({reducedMotion:'reduce'});
  await page.goto('/');
  await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  const logo=page.locator('.landing-hero .logo-stage');
  await expect(logo).toHaveAttribute('data-ready','false');
  expect(models).toHaveLength(0);
  await logo.focus();
  await logo.press('ArrowRight');
  await expect.poll(()=>models.length).toBeGreaterThan(0);
});
