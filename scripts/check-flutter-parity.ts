import { readFile, readdir } from 'node:fs/promises';
import { resolve } from 'node:path';
import assert from 'node:assert/strict';

const root = resolve(import.meta.dir, '..');
const source = await readFile(resolve(root, 'packages/react/src/index.ts'), 'utf8');
const modules = [...source.matchAll(/export \* from '\.\/(.+)\.js'/g)].map(match => match[1]).sort();
const entries = JSON.parse(await readFile(resolve(root, 'docs/flutter-parity.json'), 'utf8')) as { web: string; flutter: string[]; example: string }[];
assert.deepEqual(entries.map(entry => entry.web).sort(), modules, 'Every web family needs one Flutter parity entry.');
const dart = (await Promise.all((await readdir(resolve(root, 'packages/flutter/lib'), { recursive: true })).filter(path => path.endsWith('.dart')).map(path => readFile(resolve(root, 'packages/flutter/lib', path), 'utf8')))).join('\n');
const example = await readFile(resolve(root, 'packages/flutter/example/lib/main.dart'), 'utf8');
for (const entry of entries) {
  for (const symbol of entry.flutter) assert.match(dart, new RegExp(`\\b(class|enum|typedef)\\s+${symbol}\\b`), `${entry.web}: missing ${symbol}`);
  assert.ok(example.includes(`'${entry.example}'`), `${entry.web}: missing example ${entry.example}`);
}
console.log(`Flutter parity: ${entries.length} web component families have public implementations and examples.`);
