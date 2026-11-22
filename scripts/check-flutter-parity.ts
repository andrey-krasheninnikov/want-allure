import { readFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import assert from 'node:assert/strict';
import ts from 'typescript';

const root = resolve(import.meta.dir, '..');
const source = await readFile(resolve(root, 'packages/react/src/index.ts'), 'utf8');
const modules = [...source.matchAll(/export \* from '\.\/(.+)\.js'/g)].map(match => match[1]).sort();
const entries = JSON.parse(await readFile(resolve(root, 'docs/flutter-parity.json'), 'utf8')) as { web: string; react: string; flutter: string[]; example: string }[];
assert.deepEqual(entries.map(entry => entry.web).sort(), modules, 'Every web family needs one Flutter parity entry.');
const dart = await readFile(resolve(root, 'packages/flutter/lib/want_allure.dart'), 'utf8');
const entrypoint = resolve(root, 'packages/react/src/index.ts');
const config = ts.parseJsonConfigFileContent({ compilerOptions: { moduleResolution: 'Bundler', jsx: 'react-jsx' } }, ts.sys, root);
const program = ts.createProgram([entrypoint], config.options);
const checker = program.getTypeChecker();
const symbol = checker.getSymbolAtLocation(program.getSourceFile(entrypoint)!);
assert(symbol);
const publicReact = new Set(checker.getExportsOfModule(symbol).map(entry => entry.name));
const example = await readFile(resolve(root, 'packages/flutter/example/lib/main.dart'), 'utf8');
for (const entry of entries) {
  const path = resolve(root, 'packages/react/src', entry.web);
  const family = program.getSourceFile(path + '.tsx') ?? program.getSourceFile(path + '.ts');
  const familySymbol = family && checker.getSymbolAtLocation(family);
  assert(familySymbol && checker.getExportsOfModule(familySymbol).some(item => item.name === entry.react), `${entry.web}: missing ${entry.react} in this family`);
  assert(publicReact.has(entry.react), `${entry.web}: missing React export ${entry.react}`);
  for (const symbol of entry.flutter) assert.match(dart, new RegExp(`\\b${symbol}\\b`), `${entry.web}: missing public Dart export ${symbol}`);
  assert.ok(example.includes(`'${entry.example}'`), `${entry.web}: missing example ${entry.example}`);
}
console.log(`Flutter parity: ${entries.length} web component families have public implementations and examples.`);
