import os
import unittest
from urllib.error import HTTPError
from urllib.request import HTTPRedirectHandler, build_opener


class NoRedirect(HTTPRedirectHandler):
    def redirect_request(self, request, response, code, message, headers, new_url):
        return None


@unittest.skipUnless(os.environ.get('ALLURE_HTTP_URL'), 'Set ALLURE_HTTP_URL to the isolated Nginx fixture')
class HttpTest(unittest.TestCase):
    def request(self, path):
        try:
            response = build_opener(NoRedirect()).open(os.environ['ALLURE_HTTP_URL'] + path, timeout=10)
        except HTTPError as error:
            response = error
        with response:
            return response.status, response.headers, response.read()

    def test_six_routes_have_real_html(self):
        for path in ['/', '/react/', '/flutter/', '/ru/', '/ru/react/', '/ru/flutter/']:
            with self.subTest(path=path):
                status, headers, body = self.request(path)
                self.assertEqual(status, 200)
                self.assertTrue(body)
                self.assertIn('text/html', headers['Content-Type'])
                self.assertEqual(headers['Cache-Control'], 'no-store')

    def test_trailing_slash_redirect_preserves_query(self):
        for path in ['/react', '/flutter', '/ru', '/ru/react', '/ru/flutter']:
            status, headers, _ = self.request(path + '?section=data')
            self.assertEqual(status, 301)
            self.assertEqual(headers['Location'], path + '/?section=data')

    def test_missing_resources_are_uncached_real_404(self):
        for path in ['/missing/', '/_flutter/missing.js', '/_astro/missing.js', '/.env', '/.archive-sha256']:
            status, headers, _ = self.request(path)
            self.assertEqual(status, 404, path)
            self.assertEqual(headers['Cache-Control'], 'no-store', path)

    def test_current_and_previous_hashed_chunks_remain_immutable(self):
        for path, expected in [('/_astro/current.hash.js', b'current chunk'), ('/_astro/previous.hash.js', b'previous chunk')]:
            status, headers, body = self.request(path)
            self.assertEqual(status, 200)
            self.assertEqual(body, expected)
            self.assertIn('immutable', headers['Cache-Control'])

    def test_bootstrap_and_release_metadata_are_never_cached(self):
        for path in ['/release.json', '/_flutter/flutter_bootstrap.js', '/_flutter/flutter_service_worker.js', '/?theme=dark']:
            status, headers, _ = self.request(path)
            self.assertEqual(status, 200, path)
            self.assertEqual(headers['Cache-Control'], 'no-store', path)

    def test_runtime_and_fonts_have_correct_types_and_revalidate(self):
        for path, mime in [('/_flutter/main.dart.js', 'application/javascript'), ('/_flutter/canvaskit.wasm', 'application/wasm'), ('/font.woff2', 'font/woff2'), ('/font.ttf', 'font/ttf'), ('/shader.frag', 'application/octet-stream')]:
            status, headers, _ = self.request(path)
            self.assertEqual(status, 200, path)
            self.assertIn(mime, headers['Content-Type'], path)
            self.assertIn('must-revalidate', headers['Cache-Control'], path)
            self.assertEqual(headers['X-Content-Type-Options'], 'nosniff')
