"""Check the public HTTP contract of a complete Want Allure release."""
import argparse
from html.parser import HTMLParser
import hashlib
import json
from urllib.error import HTTPError
from urllib.parse import urljoin, urlsplit
from urllib.request import HTTPRedirectHandler, Request, build_opener
import xml.etree.ElementTree as ET


class NoRedirect(HTTPRedirectHandler):
    def redirect_request(self, request, response, code, message, headers, new_url):
        return None


class Metadata(HTMLParser):
    def __init__(self, html):
        super().__init__()
        self.links = []
        self.meta = {}
        self.feed(html)

    def handle_starttag(self, tag, attributes):
        values = dict(attributes)
        if tag == 'link':
            self.links.append(values)
        if tag == 'meta':
            self.meta[values.get('name') or values.get('property')] = values.get('content')


def verify(base, revision=None):
    if not __debug__:
        raise RuntimeError('HTTP verification requires assertions enabled')
    opener = build_opener(NoRedirect())
    manifest = None

    def get(path, expected=200):
        try:
            response = opener.open(Request(urljoin(base, path)), timeout=30)
        except HTTPError as error:
            response = error
        with response:
            body = response.read()
            assert response.status == expected, (path, response.status, expected)
            if manifest and expected == 200:
                name = urlsplit(path).path.lstrip('/')
                if not name or name.endswith('/'):
                    name += 'index.html'
                if name != 'release.json':
                    assert hashlib.sha256(body).hexdigest() == manifest['files'][name], ('Response checksum mismatch', path)
            return response.headers, body

    headers, body = get('/release.json')
    manifest = json.loads(body)
    if revision:
        assert manifest['sourceRevision'] == revision, 'Unexpected deployed source revision'
    assert 'no-store' in headers.get('Cache-Control', ''), 'Release metadata must not be cached'
    for locale in ['', 'ru/']:
        for section in ['', 'react/', 'flutter/']:
            path = '/' + locale + section
            headers, body = get(path)
            html = body.decode()
            assert 'text/html' in headers.get('Content-Type', ''), path
            assert 'no-store' in headers.get('Cache-Control', ''), path
            metadata = Metadata(html)
            canonical = 'https://allure.want.foundation' + path
            assert any(link.get('rel') == 'canonical' and link.get('href') == canonical
                       for link in metadata.links), path
            assert metadata.meta['robots'] == ('noindex,follow' if section else 'index,follow'), path
            if not section:
                alternatives = {link.get('hreflang'): link.get('href') for link in metadata.links
                                if link.get('rel') == 'alternate'}
                assert len(alternatives) == 13 and alternatives['x-default'] == 'https://allure.want.foundation/'
                assert 'flutter_bootstrap.js' not in html and 'main.dart.js' not in html
            else:
                redirect, _ = get(path.rstrip('/') + '?section=navigation', 301)
                assert redirect['Location'] == path + '?section=navigation', path
    for missing in ['/__allure_missing__/', '/_flutter/missing.js', '/_astro/missing.js', '/.env']:
        headers, _ = get(missing, 404)
        assert 'no-store' in headers.get('Cache-Control', ''), missing
    files = manifest['files']
    resources = {
        '_flutter/flutter_bootstrap.js': ('javascript', 'no-store'),
        '_flutter/main.dart.js': ('javascript', 'must-revalidate'),
        '_flutter/canvaskit/canvaskit.wasm': ('application/wasm', 'must-revalidate'),
        '_flutter/assets/packages/want_allure/shaders/shimmer.frag': ('application/octet-stream', 'must-revalidate'),
        '_flutter/assets/packages/want_allure/shaders/sphere.frag': ('application/octet-stream', 'must-revalidate'),
        '_flutter/assets/packages/want_allure/shaders/lightning.frag': ('application/octet-stream', 'must-revalidate'),
        'brand/github/social-preview-light.png': ('image/png', 'must-revalidate'),
        'favicon/favicon.svg': ('image/svg+xml', 'must-revalidate'),
    }
    for suffix, mime in [('.woff2', 'font/woff2'), ('.ttf', 'font/ttf')]:
        path = next(name for name in files if name.endswith(suffix))
        resources[path] = (mime, 'immutable' if path.startswith('_astro/') else 'must-revalidate')
    chunk = next(name for name in files if name.startswith('_astro/') and name.endswith('.js'))
    resources[chunk] = ('javascript', 'immutable')
    for path, (mime, cache) in resources.items():
        headers, body = get('/' + path)
        assert body and mime in headers.get('Content-Type', ''), (path, headers.get('Content-Type'))
        assert cache in headers.get('Cache-Control', ''), (path, headers.get('Cache-Control'))
        assert headers.get('X-Content-Type-Options') == 'nosniff', path
    _, robots = get('/robots.txt')
    assert b'Sitemap: https://allure.want.foundation/sitemap.xml' in robots
    _, sitemap = get('/sitemap.xml')
    locations = [node.text for node in ET.fromstring(sitemap).iter('{http://www.sitemaps.org/schemas/sitemap/0.9}loc')]
    assert len(locations) == 12 and len(set(locations)) == 12
    for location in locations:
        assert location.startswith('https://allure.want.foundation/')
        get(urlsplit(location).path)
    if base.startswith('https://'):
        try:
            opener.open('http://' + urlsplit(base).netloc + '/react/?section=navigation', timeout=30)
            raise AssertionError('HTTP must redirect to HTTPS')
        except HTTPError as error:
            assert error.code in [301, 308]
            assert error.headers['Location'] == base.rstrip('/') + '/react/?section=navigation'
    print(json.dumps({'sourceRevision': manifest['sourceRevision'], 'routes': 6,
                      'landingLocales': 12, 'resources': len(resources), 'http': 'passed'}))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--url', default='https://allure.want.foundation')
    parser.add_argument('--revision')
    arguments = parser.parse_args()
    verify(arguments.url, arguments.revision)
