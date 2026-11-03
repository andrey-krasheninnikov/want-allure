import assert from 'node:assert/strict';
import {locales,localeDirection} from '../apps/showcase/src/site';
import { readFile, stat } from 'node:fs/promises';
import { resolve } from 'node:path';
const root = resolve(import.meta.dir, '../apps/showcase/dist');
const origin = new URL(process.env.SITE_URL || 'https://allure.want.foundation');
for (const locale of locales) {
  const prefix = locale === 'en' ? '' : locale + '/';
  for (const section of ['', 'react/', 'flutter/']) {
    const html = await readFile(resolve(root, prefix + section + 'index.html'), 'utf8');
    assert(html.includes(`lang="${locale}"`));
    assert(html.includes(`dir="${localeDirection(locale)}"`));
    if (!section) assert.equal((html.match(/<h1[ >]/g) ?? []).length, 1);
    assert(html.includes(`href="/${prefix}react/"`) && html.includes(`href="/${prefix}flutter/"`));
    assert(html.includes(`content="${section ? 'noindex,follow' : 'index,follow'}"`));
    if (!section) {
      assert(html.includes(new URL('/' + prefix, origin).href));
      for (const language of [...locales, 'x-default']) assert(html.includes(`hreflang="${language}"`));
      assert(!html.includes('flutter_bootstrap.js') && !html.includes('main.dart.js'));
      const schema = /<script type="application\/ld\+json">([^<]+)<\/script>/.exec(html)?.[1];
      assert(schema && JSON.parse(schema).some((entry: { '@type': string }) => entry['@type'] === 'SoftwareSourceCode'));
    }
  }
}
const sitemap = await readFile(resolve(root, 'sitemap.xml'), 'utf8');
assert.equal((sitemap.match(/<loc>/g) ?? []).length, locales.length);
assert((await readFile(resolve(root, 'robots.txt'), 'utf8')).includes(new URL('/sitemap.xml', origin).href));
assert((await readFile(resolve(root, '_flutter/index.html'), 'utf8')).includes('<base href="/_flutter/">'));
for (const file of ['_flutter/flutter_bootstrap.js', '_flutter/main.dart.js', '_flutter/canvaskit/canvaskit.wasm', '_flutter/assets/packages/want_allure/shaders/shimmer.frag', '_flutter/assets/packages/want_allure/shaders/sphere.frag', '_flutter/assets/packages/want_allure/shaders/lightning.frag', 'favicon/favicon.svg', 'brand/github/social-preview-light.png']) assert((await stat(resolve(root, file))).size > 0, file);
console.log('Unified static web artifact passed route, metadata and runtime checks.');
