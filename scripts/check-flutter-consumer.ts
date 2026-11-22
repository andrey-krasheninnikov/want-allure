import { cp, mkdtemp, readFile, readdir, rm, writeFile } from 'node:fs/promises';
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
  const exampleSpec = await readFile(resolve(root, 'packages/flutter/example/pubspec.yaml'), 'utf8');
  const sourcePath = '  want_allure:\n    path: ../';
  assert(exampleSpec.includes(sourcePath));
  const consumerSpec = exampleSpec
    .replace('name: want_allure_example', 'name: want_package_consumer')
    .replace(sourcePath, hosted ? '  want_allure: ' + version : '  want_allure:\n    path: ' + JSON.stringify(archive));
  await writeFile(resolve(app, 'pubspec.yaml'), consumerSpec);
  await cp(resolve(root, 'packages/flutter/example/lib'), resolve(app, 'lib'), { recursive: true });
  await cp(resolve(root, 'packages/flutter/example/l10n.yaml'), resolve(app, 'l10n.yaml'));
  for(const file of await readdir(resolve(app,'lib'),{recursive:true})) {
    if(!file.endsWith('.dart'))continue;
    const target=resolve(app,'lib',file);
    await writeFile(target,(await readFile(target,'utf8')).replaceAll('package:want_allure_example/','package:want_package_consumer/'));
  }
  await run(['flutter', 'pub', 'get'], app);
  const matrix = JSON.parse(await readFile(resolve(root, 'docs/flutter-parity.json'), 'utf8')) as { flutter: string[] }[];
  const names = [...new Set(matrix.flatMap(entry => entry.flutter))];
  await writeFile(resolve(app, 'lib/public_contract.dart'),
    "import 'package:want_allure/want_allure.dart' as kit;\nfinal publicTypes = <Type>[\n" + names.map(name => '  kit.' + name + ',').join('\n') + '\n];\n');
  await run(['dart', 'analyze', 'lib/public_contract.dart'], app);
  await run(['flutter', 'build', 'web', '--release', '--no-pub'], app);
  for (const name of ['shimmer', 'sphere', 'lightning', 'threads']) {
    assert((await readFile(resolve(app, `build/web/assets/packages/want_allure/shaders/${name}.frag`))).length > 0);
  }
  for (const theme of ['light', 'dark']) assert((await readFile(resolve(app, `build/web/assets/packages/want_allure/assets/brand/allure/logos/${theme}/transparent.svg`))).length > 0);
  const manifest = await readFile(resolve(app, 'build/web/assets/FontManifest.json'), 'utf8');
  assert.match(manifest, /packages\/want_allure\/Manrope/);
  assert.match(manifest, /packages\/want_allure\/Days One/);
  assert.match(manifest, /packages\/want_allure\/Pixelify Sans/);
  assert.match(manifest, /packages\/want_allure\/ZCOOL XiaoWei/);
  assert.match(manifest, /packages\/phosphoricons_flutter\/PhosphorRegular/);
  console.log(`Flutter consumer passed using ${hosted ? 'pub.dev ' + version : 'isolated distribution files'}.`);
} finally {
  await rm(temporary, { recursive: true, force: true });
}
