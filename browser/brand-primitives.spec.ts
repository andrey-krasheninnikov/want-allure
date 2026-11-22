import { expect, test } from '@playwright/test';
import { execFileSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

let bundle: string;
test.beforeAll(() => {
  const directory = mkdtempSync(join(tmpdir(), 'allure-browser-'));
  try {
    const file = join(directory, 'fixture.js');
    execFileSync('bun', ['build', 'browser/brand-primitives.fixture.tsx', '--target=browser', '--format=iife', '--outfile', file]);
    bundle = readFileSync(file, 'utf8');
  } finally { rmSync(directory, { recursive:true, force:true }); }
});
test.beforeEach(async ({ page }) => {
  await page.route('http://allure.test/**', route => route.request().resourceType() === 'document'
    ? route.fulfill({ contentType:'text/html', body:'<!doctype html><html lang="en"><body><button id="outside">Host</button><main id="fixture"></main></body></html>' })
    : route.fulfill({status:404,body:''}));
  await page.goto('http://allure.test/');
  await page.addScriptTag({content:bundle});
});

test('scoped stylesheet preserves the host and isolates nested buttons and portals', async ({ page }) => {
  await page.emulateMedia({reducedMotion:'no-preference'});
  const outside = page.locator('#outside');
  const style = (node: Element) => {
    const css = getComputedStyle(node);
    return [css.backgroundColor,css.color,css.paddingInlineStart,css.fontFamily,css.borderRadius];
  };
  const before = await outside.evaluate(style);
  await page.addStyleTag({path:'packages/foundation/dist/scoped.css'});
  expect(await outside.evaluate(style)).toEqual(before);
  const outer = page.getByRole('button',{name:'Outer action'}), inner = page.getByRole('button',{name:'Inner action'});
  await expect(outer).toHaveCSS('border-radius','9px');
  await expect(inner).toHaveCSS('border-radius','17px');
  const fills = await Promise.all([outer.evaluate(style),inner.evaluate(style)]);
  expect(fills[0][0]).not.toEqual(fills[1][0]);
  expect(fills[0][3]).toContain('Outside Sans');
  expect(fills[1][3]).not.toContain('Outside Sans');
  const paddingVariable = (node: Element) => getComputedStyle(node).getPropertyValue('--allure-cell-block');
  expect(await outer.evaluate(paddingVariable)).not.toEqual(await inner.evaluate(paddingVariable));
  expect(Number.parseFloat(fills[0][2])).toBeGreaterThan(8);
  await expect(page.getByTestId('flat-card')).toHaveCSS('box-shadow','none');
  const busyDuration = await page.getByRole('button',{name:'Busy'}).evaluate(node =>
    Number.parseFloat(getComputedStyle(node, '::before').animationDuration));
  expect(busyDuration).toBeLessThan(.001);
  await page.getByRole('button',{name:'Open popover'}).click();
  const overlay = page.getByTestId('inner').getByText('Scoped overlay');
  await expect(overlay).toBeVisible();
  expect(await overlay.evaluate(node => getComputedStyle(node).direction)).toBe('rtl');
});

test('global styles isolate nested brand settings and keep controlled RTL tabs visible', async ({ page }) => {
  await page.addStyleTag({path:'packages/foundation/dist/index.css'});
  await expect(page.getByRole('button',{name:'Outer action'})).toHaveCSS('font-family', /Outside Sans/);
  await expect(page.getByRole('button',{name:'Inner action'})).not.toHaveCSS('font-family', /Outside Sans/);
  await page.getByRole('button',{name:'Last section'}).click();
  const last = page.getByRole('tab',{name:'Section last'});
  await expect(last).toHaveAttribute('aria-selected','true');
  await expect.poll(() => last.evaluate(node => {
    const bounds = node.getBoundingClientRect(), list = node.parentElement!.getBoundingClientRect();
    return bounds.left >= list.left - 1 && bounds.right <= list.right + 1;
  })).toBe(true);
  await last.focus();
  await page.keyboard.press('ArrowRight');
  await expect(page.getByRole('tab',{name:'Section fourth'})).toBeFocused();
});

test('fields, external options, calendar bounds and sort retain keyboard semantics', async ({ page }) => {
  await page.addStyleTag({path:'packages/foundation/dist/scoped.css'});
  const password = page.getByLabel('Password', {exact:true});
  await expect(password).toHaveAccessibleDescription('Password hint Required');
  await page.getByRole('button',{name:'Focus password'}).click();
  await expect(password).toBeFocused();
  await expect(password).toHaveValue('example');
  await password.evaluate(node => (node as HTMLInputElement).setSelectionRange(1,5));
  await page.getByRole('button',{name:'Show',exact:true}).click();
  await expect.poll(() => password.evaluate(node => [(node as HTMLInputElement).selectionStart,(node as HTMLInputElement).selectionEnd])).toEqual([1,5]);
  const combo = page.getByRole('combobox',{name:'Find'});
  await combo.fill('unrelated query');
  await expect(page.getByRole('alert').filter({hasText:'Offline'})).toBeVisible();
  await page.getByRole('button',{name:'Retry'}).click();
  await expect(page.getByRole('option',{name:'Result'})).toBeVisible();
  await page.keyboard.press('Escape');
  await page.getByRole('button',{name:/^Date:/}).click();
  await expect(page.locator('.ui-date-grid th').first()).toHaveText('Sun');
  await expect(page.getByRole('button',{name:'Today'})).toBeDisabled();
  await expect(page.locator('[data-day="2026-11-16"]')).toBeDisabled();
  await page.locator('[data-day="2026-11-18"]').press('End');
  await expect(page.locator('[data-day="2026-11-21"]')).toBeFocused();
  await page.keyboard.press('Home');
  await expect(page.locator('[data-day="2026-11-17"]')).toBeFocused();
  await page.keyboard.press('Escape');
  const head = page.getByRole('columnheader',{name:/Amount/});
  for (const state of ['ascending','descending','none']) {
    await head.getByRole('button').click();
    await expect(head).toHaveAttribute('aria-sort',state);
  }
});

test('operation updates preserve the notification and broken previews fall back in place', async ({ page }) => {
  await page.addStyleTag({path:'packages/foundation/dist/scoped.css'});
  await page.getByRole('button',{name:'Start',exact:true}).click();
  const toast = page.locator('[data-operation-key="save"]');
  await expect(toast).toContainText('Saving');
  await toast.evaluate(node => node.setAttribute('data-original','yes'));
  await page.getByRole('button',{name:'Finish',exact:true}).click();
  await expect(toast).toHaveCount(1);
  await expect(toast).toHaveAttribute('data-original','yes');
  await expect(toast).toContainText('Saved');
  await toast.getByRole('button',{name:'Dismiss'}).click();
  await expect(toast).toHaveCount(0);
  await page.getByLabel('Attachment').setInputFiles([
    { name:'broken.png',mimeType:'image/png',buffer:Buffer.from('x') },
    { name:'large.png',mimeType:'image/png',buffer:Buffer.alloc(64) },
  ]);
  await expect(page.locator('.ui-file-list svg.ui-file-preview')).toHaveCount(2);
  await expect(page.getByText('Unavailable')).toBeVisible();
});
