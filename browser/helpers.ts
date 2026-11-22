import type { Page } from '@playwright/test';
const labels = {foundation:'Foundation',inputs:'Inputs',navigation:'Navigation',data:'Data',feedback:'Feedback',effects:'Effects',compositions:'Compositions'} as const;
export async function category(page:Page,value:keyof typeof labels) {
  await page.getByRole('tablist',{name:'Catalogue sections',exact:true}).getByRole('tab',{name:labels[value],exact:true}).click();
}

export function themeMenu(page: Page) {
  return page.locator('.site-header').getByRole('button', { name: /^(Theme|Тема)$/ });
}

export async function chooseTheme(page: Page, theme: string) {
  await themeMenu(page).click();
  const names = { light: /^(Light theme|Светлая тема)$/, dark: /^(Dark theme|Тёмная тема)$/, system: /^(System theme|Системная тема)$/ };
  await page.getByRole('menuitem', { name: names[theme as keyof typeof names] }).click();
}
