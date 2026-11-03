import fcntl
import hashlib
import io
import json
from pathlib import Path
import subprocess
import sys
import tarfile
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / 'deploy-web.py'


class DeploymentTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory(prefix='allure-deploy-test-')
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)

    def archive(self, revision, extra=None):
        files = {'index.html': b'landing', '404.html': b'not found',
                 'react/index.html': b'react', 'flutter/index.html': b'flutter',
                 'ru/index.html': b'ru', 'ru/react/index.html': b'react ru',
                 'ru/flutter/index.html': b'flutter ru',
                 '_flutter/flutter_bootstrap.js': b'bootstrap',
                 '_flutter/main.dart.js': b'runtime', '_astro/old.hash.js': b'chunk'}
        files.update(extra or {})
        manifest = {'sourceRevision': revision, 'files': {
            name: hashlib.sha256(content).hexdigest() for name, content in files.items()}}
        files['release.json'] = json.dumps(manifest).encode()
        archive = self.root / (revision + '.tgz')
        with tarfile.open(archive, 'w:gz') as output:
            for name, content in files.items():
                member = tarfile.TarInfo(name)
                member.size = len(content)
                output.addfile(member, io.BytesIO(content))
        return archive, hashlib.sha256(archive.read_bytes()).hexdigest()

    def run_command(self, *arguments):
        return subprocess.run([sys.executable, '-B', str(SCRIPT), *map(str, arguments),
                               '--root', str(self.root / 'data')], capture_output=True, text=True)

    def test_publish_and_repeat_preserve_the_release_identity(self):
        archive, checksum = self.archive('a' * 40)
        result = self.run_command('activate', archive, checksum, '--expected', 'none')
        self.assertEqual(result.returncode, 0, result.stderr)
        status = self.run_command('status')
        self.assertEqual(json.loads(status.stdout)['current'], 'a' * 40)
        repeated = self.run_command('activate', archive, checksum, '--expected', 'a' * 40)
        self.assertEqual(repeated.returncode, 0, repeated.stderr)
        self.assertEqual((self.root / 'data/current/index.html').read_text(), 'landing')

    def test_corrupt_archive_does_not_replace_the_current_release(self):
        first, checksum = self.archive('a' * 40)
        self.assertEqual(self.run_command('activate', first, checksum, '--expected', 'none').returncode, 0)
        second, _ = self.archive('b' * 40)
        result = self.run_command('activate', second, '0' * 64, '--expected', 'a' * 40)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(json.loads(self.run_command('status').stdout)['current'], 'a' * 40)

    def test_stale_expected_revision_does_not_publish(self):
        archive, checksum = self.archive('b' * 40)
        result = self.run_command('activate', archive, checksum, '--expected', 'a' * 40)
        self.assertNotEqual(result.returncode, 0)
        self.assertIsNone(json.loads(self.run_command('status').stdout)['current'])

    def test_rollback_restores_the_original_bytes_and_keeps_previous_chunks(self):
        first, checksum = self.archive('a' * 40)
        self.assertEqual(self.run_command('activate', first, checksum, '--expected', 'none').returncode, 0)
        second, checksum = self.archive('b' * 40, {'index.html': b'new landing'})
        self.assertEqual(self.run_command('activate', second, checksum, '--expected', 'a' * 40).returncode, 0)
        self.assertEqual((self.root / 'data/previous/_astro/old.hash.js').read_bytes(), b'chunk')
        result = self.run_command('restore', 'a' * 40, '--expected', 'b' * 40)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.root / 'data/current/index.html').read_bytes(), b'landing')

    def test_archive_path_traversal_is_rejected(self):
        archive, checksum = self.archive('a' * 40, {'../escape.txt': b'unsafe'})
        result = self.run_command('activate', archive, checksum, '--expected', 'none')
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse((self.root / 'data/escape.txt').exists())

    def test_existing_revision_cannot_be_overwritten(self):
        archive, checksum = self.archive('a' * 40)
        self.assertEqual(self.run_command('activate', archive, checksum, '--expected', 'none').returncode, 0)
        archive, checksum = self.archive('a' * 40, {'index.html': b'different content'})
        result = self.run_command('activate', archive, checksum, '--expected', 'a' * 40)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((self.root / 'data/current/index.html').read_bytes(), b'landing')

    def test_parallel_activation_is_rejected(self):
        archive, checksum = self.archive('a' * 40)
        data = self.root / 'data'
        data.mkdir()
        with (data / '.deploy.lock').open('a') as lock:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            result = self.run_command('activate', archive, checksum, '--expected', 'none')
        self.assertNotEqual(result.returncode, 0)
        self.assertIsNone(json.loads(self.run_command('status').stdout)['current'])


if __name__ == '__main__':
    unittest.main()
