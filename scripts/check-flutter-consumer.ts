import { cp, mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { resolve } from 'node:path';
import assert from 'node:assert/strict';

const root = resolve(import.meta.dir, '..');
const packageSpec = await readFile(resolve(root, 'packages/flutter/pubspec.yaml'), 'utf8');
const version = /^version: (\S+)$/m.exec(packageSpec)?.[1];
assert(version);
const temporary = await mkdtemp(resolve(tmpdir(), 'want-flutter-consumer-'));
const hosted = process.argv.includes('--hosted');
async function run(args: string[], cwd: string) {
  const result = Bun.spawn(['fvm', ...args], { cwd, stdout: 'inherit', stderr: 'inherit' });
  assert.equal(await result.exited, 0, args.join(' '));
}
try {
  const archive = resolve(temporary, 'package'), app = resolve(temporary, 'app');
  for (const path of ['lib', 'assets', 'shaders', 'licenses', 'pubspec.yaml', 'LICENSE', 'README.md', 'CHANGELOG.md', 'THIRD_PARTY_NOTICES.md']) {
    await cp(resolve(root, 'packages/flutter', path), resolve(archive, path), { recursive: true });
  }
  const pubspec = await readFile(resolve(archive, 'pubspec.yaml'), 'utf8');
  assert.match(pubspec, /name: want_allure\n/); assert(pubspec.includes(`version: ${version}\n`));
  assert.ok((await readFile(resolve(archive, 'assets/fonts/Manrope.ttf'))).length > 100000);
  await run(['flutter', 'create', '--no-pub', '--platforms=web', '--project-name=want_package_consumer', app], root);
  await cp(resolve(root, '.fvmrc'), resolve(app, '.fvmrc'));
  await writeFile(resolve(app, 'pubspec.yaml'), `name: want_package_consumer\npublish_to: none\nenvironment:\n  sdk: ^3.13.5\ndependencies:\n  flutter:\n    sdk: flutter\n  flutter_localizations:\n    sdk: flutter\n  forui: ^0.27.7\n  material_ui: ^1.9.0\n  intl: ^0.20.3\n  web: ^1.1.1\n  want_allure:${hosted ? ' ' + version : '\n    path: ' + archive}\nflutter:\n  uses-material-design: true\n  generate: true\n`);
  await cp(resolve(root, 'packages/flutter/example/lib'), resolve(app, 'lib'), { recursive: true });
  await cp(resolve(root, 'packages/flutter/example/l10n.yaml'), resolve(app, 'l10n.yaml'));
  const main = resolve(app, 'lib/main.dart');
  await writeFile(main, (await readFile(main, 'utf8')).replaceAll('package:want_allure_example/', 'package:want_package_consumer/'));
  await run(['flutter', 'pub', 'get'], app);
  await run(['flutter', 'build', 'web', '--release', '--no-pub'], app);
  for (const name of ['shimmer', 'sphere']) {
    assert((await readFile(resolve(app, `build/web/assets/packages/want_allure/shaders/${name}.frag`))).length > 0);
  }
  for (const theme of ['light', 'dark']) assert((await readFile(resolve(app, `build/web/assets/packages/want_allure/assets/brand/allure/logos/${theme}/transparent.svg`))).length > 0);
  const manifest = await readFile(resolve(app, 'build/web/assets/FontManifest.json'), 'utf8');
  assert.match(manifest, /packages\/want_allure\/Manrope/);
  assert.match(manifest, /packages\/want_allure\/Days One/);
  assert.match(manifest, /packages\/phosphoricons_flutter\/PhosphorRegular/);
  console.log(`Flutter consumer passed using ${hosted ? 'pub.dev ' + version : 'isolated distribution files'}.`);
} finally {
  await rm(temporary, { recursive: true, force: true });
}
