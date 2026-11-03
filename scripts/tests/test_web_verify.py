import hashlib
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
from pathlib import Path
import subprocess
import sys
import threading
import unittest
from urllib.parse import urlsplit

SCRIPT = Path(__file__).resolve().parents[1] / 'verify-web.py'


class VerificationTest(unittest.TestCase):
    def setUp(self):
        locales = ['', 'zh-Hans/', 'hi/', 'es/', 'ar/', 'fr/', 'pt-BR/', 'ru/', 'de/', 'ja/', 'tr/', 'he/']
        self.files = {}
        for locale in locales:
            for section in ['', 'react/', 'flutter/']:
                path = locale + section
                alternatives = ''.join('<link rel="alternate" hreflang="' + ('en' if not language else language[:-1]) + '" href="https://allure.want.foundation/' + language + '">' for language in locales)
                html = '<meta name="robots" content="' + ('noindex,follow' if section else 'index,follow') + '"><link rel="canonical" href="https://allure.want.foundation/' + path + '">'
                if not section:
                    html += alternatives + '<link rel="alternate" hreflang="x-default" href="https://allure.want.foundation/">'
                self.files[path + 'index.html'] = html.encode()
        for name in ['_flutter/flutter_bootstrap.js', '_flutter/main.dart.js', '_flutter/canvaskit/canvaskit.wasm', '_flutter/assets/packages/want_allure/shaders/shimmer.frag', '_flutter/assets/packages/want_allure/shaders/sphere.frag', '_flutter/assets/packages/want_allure/shaders/lightning.frag', 'brand/github/social-preview-light.png', 'favicon/favicon.svg', '_astro/example.woff2', '_astro/chunk.hash.js', 'fonts/example.ttf']:
            self.files[name] = b'current resource'
        self.files['robots.txt'] = b'Sitemap: https://allure.want.foundation/sitemap.xml'
        self.files['sitemap.xml'] = ('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' + ''.join('<url><loc>https://allure.want.foundation/' + locale + '</loc></url>' for locale in locales) + '</urlset>').encode()
        manifest = {'sourceRevision': 'a' * 40, 'files': {name: hashlib.sha256(body).hexdigest() for name, body in sorted(self.files.items())}}
        self.files['release.json'] = json.dumps(manifest).encode()
        files = self.files
        self.omit_transform = False
        state = self

        class Handler(BaseHTTPRequestHandler):
            def log_message(self, *arguments):
                pass

            def do_GET(self):
                if self.headers.get('User-Agent', '').startswith('Python-urllib/'):
                    self.send_response(403)
                    self.end_headers()
                    return
                path = urlsplit(self.path).path.lstrip('/')
                if not path.endswith('/') and path + '/index.html' in files:
                    self.send_response(301)
                    self.send_header('Cache-Control', 'public, max-age=0, must-revalidate, no-transform')
                    self.send_header('Location', '/' + path + '/?' + urlsplit(self.path).query)
                    self.end_headers()
                    return
                name = path + 'index.html' if not path or path.endswith('/') else path
                body = files.get(name)
                self.send_response(200 if body else 404)
                cache = 'immutable' if name.startswith('_astro/') else 'must-revalidate'
                if not body or name.endswith('.html') or name in ['release.json', '_flutter/flutter_bootstrap.js']:
                    cache = 'no-store'
                mime = {'.html': 'text/html', '.js': 'application/javascript', '.wasm': 'application/wasm', '.png': 'image/png', '.svg': 'image/svg+xml', '.woff2': 'font/woff2', '.ttf': 'font/ttf'}.get(Path(name).suffix, 'application/octet-stream')
                self.send_header('Content-Type', mime)
                self.send_header('Cache-Control', cache + ('' if state.omit_transform else ', no-transform'))
                self.send_header('X-Content-Type-Options', 'nosniff')
                self.end_headers()
                self.wfile.write(body or b'missing')

        self.server = ThreadingHTTPServer(('127.0.0.1', 0), Handler)
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()
        self.addCleanup(self.server.server_close)
        self.addCleanup(self.server.shutdown)

    def check(self):
        return subprocess.run([sys.executable, '-B', str(SCRIPT), '--url', 'http://127.0.0.1:' + str(self.server.server_port), '--revision', 'a' * 40], capture_output=True, text=True)

    def test_hashed_fonts_follow_the_immutable_resource_policy(self):
        result = self.check()
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_stale_bootstrap_with_fresh_release_metadata_is_rejected(self):
        self.files['_flutter/flutter_bootstrap.js'] = b'stale bootstrap'
        result = self.check()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('checksum', result.stderr.lower())

    def test_stale_html_with_fresh_release_metadata_is_rejected(self):
        self.files['index.html'] += b'old page'
        result = self.check()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('checksum', result.stderr.lower())

    def test_responses_without_no_transform_are_rejected(self):
        self.omit_transform = True
        result = self.check()
        self.assertNotEqual(result.returncode, 0)
