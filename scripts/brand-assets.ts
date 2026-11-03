import { cp, mkdir, readFile, readdir } from 'node:fs/promises';
import { resolve, relative } from 'node:path';
import assert from 'node:assert/strict';

const root = resolve(import.meta.dir, '..');
const check = process.argv.includes('--check');
const source = resolve(root, 'assets/brand');
const pairs = [
  ['logos', 'packages/foundation/src/assets/allure/logos'],
  ['backgrounds', 'packages/foundation/src/assets/allure/backgrounds'],
  ['logos', 'packages/flutter/assets/brand/allure/logos'],
  ['backgrounds', 'packages/flutter/assets/brand/allure/backgrounds'],
  ['favicon', 'packages/flutter/example/web/favicon'],
] as const;
async function sync(from: string, to: string) {
  for (const entry of await readdir(from, { withFileTypes: true })) {
    const input = resolve(from, entry.name), output = resolve(to, entry.name);
    if (entry.isDirectory()) await sync(input, output);
    else if (check) assert((await readFile(input)).equals(await readFile(output)), relative(root, output) + ' differs from the brand source');
    else { await mkdir(to, { recursive: true }); await cp(input, output); }
  }
}
for (const [from, to] of pairs) await sync(resolve(source, from), resolve(root, to));
if (!check) {
  await mkdir(resolve(root, 'apps/showcase/public'), { recursive: true });
  await cp(source, resolve(root, 'apps/showcase/public/brand'), { recursive: true });
  await cp(resolve(source, 'favicon'), resolve(root, 'apps/showcase/public/favicon'), { recursive: true });
}
console.log(check ? 'Brand resource copies match their source.' : 'Prepared Want Allure brand resources.');
