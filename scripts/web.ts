import { cp, rm, access } from 'node:fs/promises';
import { resolve } from 'node:path';

const root = resolve(import.meta.dir, '..');
async function run(args: string[], cwd = root) {
  const result = Bun.spawn(args, { cwd, stdout: 'inherit', stderr: 'inherit' });
  const code = await result.exited;
  if (code !== 0) process.exit(code);
}
const mode = process.argv[2] ?? 'build';
const args = process.argv.slice(3);
if (!['build', 'dev', 'flutter', 'preview'].includes(mode)) throw new Error('Unknown web command: ' + mode);
const runtime = resolve(root, 'apps/showcase/public/_flutter');
if (mode === 'preview') {
  await access(resolve(root, 'apps/showcase/dist/_flutter/flutter_bootstrap.js'));
  await run(['bun', 'run', '--cwd', 'apps/showcase', 'preview', '--host', '127.0.0.1', ...args]);
} else {
  await run(['bun', 'scripts/brand-assets.ts']);
  if (mode !== 'flutter') await run(['bun', 'run', 'build']);
  const example = resolve(root, 'packages/flutter/example');
  await run(['fvm', 'flutter', 'pub', 'get'], example);
  await run(['fvm', 'flutter', 'gen-l10n'], example);
  await run(['fvm', 'flutter', 'build', 'web', '--release', '--no-pub', '--base-href=/_flutter/', '--no-wasm-dry-run', '--no-web-resources-cdn'], example);
  await rm(runtime, { recursive: true, force: true });
  await cp(resolve(example, 'build/web'), runtime, { recursive: true });
  if (mode === 'build') await run(['bun', 'run', '--cwd', 'apps/showcase', 'build']);
  if (mode === 'dev') await run(['bun', 'run', '--cwd', 'apps/showcase', 'dev', '--host', '127.0.0.1', ...args]);
}
