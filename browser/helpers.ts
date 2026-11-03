import type { Page } from '@playwright/test';
const labels = {foundation:'Foundation',inputs:'Inputs',navigation:'Navigation',data:'Data',feedback:'Feedback',effects:'Effects',compositions:'Compositions'} as const;
export async function category(page:Page,value:keyof typeof labels) {
  await page.getByRole('tablist',{name:'Catalogue sections',exact:true}).getByRole('tab',{name:labels[value],exact:true}).click();
}
