import {test,expect} from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

for (const locale of ['zh-Hans','hi','ar','he']) {
  test(`localized landing ${locale} keeps layout and native direction`,async({page})=>{
    await page.setViewportSize({width:locale==='hi'?1440:320,height:1000});
    await page.goto(`/${locale}/`);await page.evaluate(()=>document.fonts.ready);
    await expect(page.locator('html')).toHaveAttribute('lang',locale);
    await expect(page.locator('html')).toHaveAttribute('dir',['ar','he'].includes(locale)?'rtl':'ltr');
    await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
    expect(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth)).toBe(true);
    const result=await new AxeBuilder({page}).withTags(['wcag2a','wcag2aa']).analyze();
    expect(result.violations.map(item=>({id:item.id,targets:item.nodes.map(node=>node.target)}))).toEqual([]);
  });
}
test('language chooser keeps category and lists all twelve locales in speaker order',async({page})=>{
  await page.goto('/react/?section=inputs');await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  await page.getByRole('combobox',{name:'Language',exact:true}).click();
  const labels=await page.getByRole('option').allTextContents();
  expect(labels).toEqual(['English','简体中文','हिन्दी','Español','العربية','Français','Português (Brasil)','Русский','Deutsch','日本語','Türkçe','עברית']);
  await page.getByRole('option',{name:'العربية',exact:true}).click();
  await expect(page).toHaveURL('/ar/react/?section=inputs');await expect(page.locator('html')).toHaveAttribute('dir','rtl');
  await expect(page.getByRole('slider').first()).toBeVisible();
});

test('Arabic catalogue localizes slider names and dates',async({page})=>{
  await page.goto('/ar/react/?section=inputs');await expect(page.locator('astro-island[ssr]')).toHaveCount(0);
  await expect(page.getByRole('slider',{name:'بداية النطاق',exact:true})).toBeVisible();
  await expect(page.getByRole('slider',{name:'منزلق معطّل',exact:true})).toBeDisabled();
  await page.getByRole('tab').last().click();
  await page.locator('.demo-fields .ui-date-trigger').first().click();
  await expect(page.getByRole('dialog')).toContainText('أكتوبر');
});
test('standalone Arabic Flutter starts with native document direction',async({page})=>{
  await page.goto('/_flutter/?locale=ar&section=data');
  await expect(page.locator('html')).toHaveAttribute('lang','ar');
  await expect(page.locator('html')).toHaveAttribute('dir','rtl');
});
