import { expect, test } from '@playwright/test';

test('workspace resizes adjacent panels, restores the layout and closes its small-screen menu', async ({ page }) => {
  await page.setViewportSize({ width: 1440, height: 960 });
  await page.goto('/react/?section=compositions');
  const workspace = page.locator('section').filter({ has: page.getByRole('heading', { name: 'Workspace', exact: true }) });
  const handles = workspace.getByRole('separator');
  await expect(handles).toHaveCount(2);
  const first = handles.first(), second = handles.last();
  const n = async () => Number(await first.getAttribute('aria-valuenow'));
  const initial = await n(), adjacent = Number(await second.getAttribute('aria-valuenow'));
  await first.press('ArrowRight');
  await expect.poll(n).toBe(initial + 16);
  await expect.poll(async () => Number(await second.getAttribute('aria-valuenow'))).toBe(adjacent - 16);
  await first.scrollIntoViewIfNeeded();
  const bounds = (await first.boundingBox())!;
  await page.mouse.move(bounds.x + bounds.width / 2, bounds.y + bounds.height / 2);
  await page.mouse.down(); await page.mouse.move(bounds.x - 1000, bounds.y + bounds.height / 2); await page.mouse.up();
  await expect.poll(n).toBe(176);
  await page.reload();
  await expect.poll(n).toBe(176);
  await page.getByRole('switch', { name: 'Right to left', exact: true }).click();
  await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');
  await first.press('ArrowLeft');
  await expect.poll(n).toBe(192);
  await page.setViewportSize({ width: 375, height: 900 });
  const toggle = workspace.getByRole('button', { name: 'Toggle menu' });
  await toggle.click();
  await expect(page.getByRole('dialog', { name: 'Groups' })).toBeVisible();
  await page.keyboard.press('Escape');
  await expect(toggle).toBeFocused();
  await page.evaluate(() => { document.documentElement.style.fontSize = '200%'; });
  await expect.poll(() => page.evaluate(() => document.documentElement.scrollWidth)).toBeLessThanOrEqual(375);
});

test('sensitive field keeps local validation and copies its hint', async ({ page, context }) => {
  await context.grantPermissions(['clipboard-read','clipboard-write']);
  await page.goto('/react/?section=inputs');
  const field = page.getByRole('textbox', { name: 'Example password' }).or(page.locator('input[aria-label="Example password"]'));
  await field.fill('wrong');
  await page.getByRole('button', { name: 'Verify', exact: true }).click();
  await expect(field).toHaveAttribute('aria-invalid','true');
  await field.fill('sample-123');
  await expect(field).not.toHaveAttribute('aria-invalid','true');
  await page.getByRole('button', { name: 'Show password', exact: true }).click();
  await expect(field).toHaveAttribute('type','text');
  const hint = page.getByRole('button', { name: 'Show hint', exact: true });
  await hint.click();
  await page.getByRole('button', { name: 'Copy hint' }).click();
  await expect.poll(() => page.evaluate(() => navigator.clipboard.readText())).toBe('sample-123');
  await expect(page.locator('.ui-copy-glyph[data-state=copied]')).toBeVisible();
});

test('guided setup shares password visibility and announces file success after the write', async ({ page }) => {
  await page.addInitScript(() => {
    Object.defineProperty(window, 'showSaveFilePicker', { value: async () => ({
      createWritable: async () => ({
        write: () => new Promise<void>(resolve => Object.assign(window, { finishDemoWrite: resolve })),
        close: async () => {},
      }),
    }) });
  });
  await page.goto('/react/?section=compositions');
  const setup = page.locator('section').filter({has:page.getByRole('heading',{name:'Guided setup',exact:true})});
  const next = setup.getByRole('button', { name: 'Next', exact: true });
  await next.click();
  const first=setup.locator('input[aria-label="Password"]'), repeat=setup.locator('input[aria-label="Repeat password"]');
  await first.fill('example123');
  await repeat.fill('example123');
  await setup.getByRole('button', { name: 'Show both passwords' }).click();
  await expect(first).toHaveAttribute('type','text');
  await expect(repeat).toHaveAttribute('type','text');
  await next.click();
  await setup.getByRole('button',{name:'Download JSON'}).click();
  await expect(page.locator('[data-slot=snackbar] .ui-snackbar-title')).toContainText('Saving file…');
  await page.evaluate(() => Reflect.get(window, 'finishDemoWrite')());
  const toast = page.locator('[data-slot=snackbar][data-variant=success]');
  await expect(toast).toBeVisible();
  const geometry = await toast.evaluate(element => {
    const icon = element.querySelector('.ui-snackbar-icon')!.getBoundingClientRect();
    const body = element.querySelector('.ui-snackbar-body')!.getBoundingClientRect();
    return { top:Math.abs(icon.y - body.y), x: icon.x + 10, y:icon.y + 10 };
  });
  expect(geometry.top).toBeLessThanOrEqual(3);
  await page.evaluate(({x,y}) => {
    const button = document.createElement('button');
    button.id='pass-below-toast'; button.textContent='Under toast';
    button.style.cssText='position:fixed;z-index:30;top:'+y+'px;left:'+x+'px;width:44px;height:44px';
    button.onclick=()=>{ button.dataset.clicked='true'; };
    document.body.append(button);
  }, geometry);
  await toast.getByRole('button',{name:'Close',exact:true}).click();
  await expect(toast).toHaveCount(0);
  await page.mouse.click(geometry.x+2,geometry.y+2);
  await expect(page.locator('#pass-below-toast')).toHaveAttribute('data-clicked','true');
  await setup.getByRole('button',{name:'Show QR'}).click();
  await expect(page.getByRole('img',{name:'QR'})).toBeVisible();
  await page.getByRole('button',{name:'I saved it'}).click();
  await setup.getByRole('button',{name:'Reset example'}).click();
  await expect(page.getByRole('button',{name:'Delete local data',exact:true})).toBeDisabled();
  await page.getByRole('textbox',{name:'Enter DELETE to confirm'}).fill('bad');
  await page.getByRole('button',{name:'Delete local data',exact:true}).click();
  await expect(page.getByRole('alert')).toContainText('Enter DELETE exactly.');
});
