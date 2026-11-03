"""Publish complete static releases from the MacBook through the existing Want SSH host."""
import argparse
import contextlib
import fcntl
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shlex
import shutil
import subprocess
import tarfile
import tempfile
import uuid

REPOSITORY = Path(__file__).resolve().parents[1]
REMOTE = '/opt/want/apps/allure'
REVISION = re.compile(r'[0-9a-f]{40}')
DIGEST = re.compile(r'[0-9a-f]{64}')
REQUIRED = {'index.html', '404.html', 'react/index.html', 'flutter/index.html',
            'ru/index.html', 'ru/react/index.html', 'ru/flutter/index.html',
            '_flutter/flutter_bootstrap.js', '_flutter/main.dart.js'}


def digest(path):
    with path.open('rb') as source:
        checksum = hashlib.sha256()
        for chunk in iter(lambda: source.read(1024 * 1024), b''):
            checksum.update(chunk)
        return checksum.hexdigest()


def current(root, name='current'):
    pointer = root / name
    if not pointer.is_symlink():
        if pointer.exists():
            raise ValueError('Release pointer must be a symlink')
        return None
    target = os.readlink(pointer)
    revision = target.removeprefix('releases/')
    if target != 'releases/' + revision or not REVISION.fullmatch(revision):
        raise ValueError('Invalid release pointer')
    return revision


def status(root):
    return {'current': current(root), 'previous': current(root, 'previous')}


def point(root, name, revision):
    temporary = root / ('.' + name + '-' + uuid.uuid4().hex)
    temporary.symlink_to('releases/' + revision)
    os.replace(temporary, root / name)


def verify_release(directory):
    if directory.is_symlink():
        raise ValueError('Release directory cannot be a symlink')
    manifest = json.loads((directory / 'release.json').read_text())
    if not REVISION.fullmatch(manifest['sourceRevision']):
        raise ValueError('Invalid source revision')
    files = manifest['files']
    if not REQUIRED.issubset(files):
        raise ValueError('Incomplete web artifact')
    for name, checksum in files.items():
        path = PurePosixPath(name)
        if not name or path.is_absolute() or '..' in path.parts or str(path) != name:
            raise ValueError('Unsafe artifact path')
        source = directory / name
        if source.is_symlink() or not DIGEST.fullmatch(checksum) or digest(source) != checksum:
            raise ValueError('Artifact file checksum mismatch: ' + name)
    return manifest


@contextlib.contextmanager
def locked(root):
    if root.is_symlink():
        raise ValueError('Deployment root cannot be a symlink')
    root.mkdir(parents=True, exist_ok=True)
    with (root / '.deploy.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        yield


def activate(root, archive, checksum, expected):
    if not DIGEST.fullmatch(checksum) or digest(archive) != checksum:
        raise ValueError('Archive checksum mismatch')
    with locked(root):
        if (current(root) or 'none') != expected:
            raise ValueError('Current release changed; inspect status before retrying')
        releases = root / 'releases'
        releases.mkdir(exist_ok=True)
        with tarfile.open(archive, 'r:gz') as source:
            members = source.getmembers()
            names = [member.name for member in members]
            if len(names) != len(set(names)) or len(names) > 10000:
                raise ValueError('Duplicate or excessive archive entries')
            size = sum(member.size for member in members)
            if size > 500 * 1024 * 1024 or shutil.disk_usage(root).free < size + 64 * 1024 * 1024:
                raise ValueError('Insufficient space or oversized artifact')
            for member in members:
                path = PurePosixPath(member.name)
                if not member.isfile() or path.is_absolute() or '..' in path.parts or str(path) != member.name:
                    raise ValueError('Unsafe archive entry')
            with tempfile.TemporaryDirectory(prefix='.incoming-', dir=releases) as temporary:
                staging = Path(temporary)
                for member in members:
                    destination = staging / member.name
                    destination.parent.mkdir(parents=True, exist_ok=True)
                    with source.extractfile(member) as incoming, destination.open('wb') as output:
                        shutil.copyfileobj(incoming, output)
                    destination.chmod(0o644)
                manifest = verify_release(staging)
                if set(names) != set(manifest['files']) | {'release.json'}:
                    raise ValueError('Manifest does not match archive contents')
                revision = manifest['sourceRevision']
                target = releases / revision
                if target.exists() or target.is_symlink():
                    verify_release(target)
                    if (target / '.archive-sha256').read_text() != checksum:
                        raise ValueError('A different artifact already uses this revision')
                else:
                    (staging / '.archive-sha256').write_text(checksum)
                    staging.chmod(0o755)
                    os.replace(staging, target)
                    # TemporaryDirectory still owns its original, now absent pathname.
                    staging.mkdir()
        previous = current(root)
        if previous != revision:
            if previous:
                verify_release(releases / previous)
                point(root, 'previous', previous)
            point(root, 'current', revision)
        return {**status(root), 'artifactSha256': checksum}


def restore(root, revision, expected):
    with locked(root):
        if (current(root) or 'none') != expected:
            raise ValueError('Current release changed; inspect status before retrying')
        if revision == 'none':
            if expected == 'none':
                return status(root)
            (root / 'current').unlink()
        else:
            if not REVISION.fullmatch(revision):
                raise ValueError('Invalid rollback revision')
            manifest = verify_release(root / 'releases' / revision)
            if manifest['sourceRevision'] != revision:
                raise ValueError('Rollback revision mismatch')
            previous = current(root)
            point(root, 'current', revision)
            if previous and previous != revision:
                point(root, 'previous', previous)
        return status(root)


def run(arguments, **options):
    return subprocess.run(arguments, check=True, text=True, **options)


def package(output):
    def git(*arguments):
        return run(['git', *arguments], cwd=REPOSITORY, capture_output=True).stdout.strip()
    if git('status', '--porcelain'):
        raise ValueError('Build requires a clean checkout')
    revision = git('rev-parse', 'HEAD')
    run(['git', 'fetch', 'origin', 'main'], cwd=REPOSITORY)
    if revision != git('rev-parse', 'origin/main'):
        raise ValueError('Build requires the exact merged origin/main revision')
    run(['bun', 'run', 'web:build'], cwd=REPOSITORY)
    run(['bun', 'run', 'web:check'], cwd=REPOSITORY)
    if git('status', '--porcelain'):
        raise ValueError('Build changed tracked source')
    artifact = REPOSITORY / 'apps/showcase/dist'
    files = sorted(path for path in artifact.rglob('*') if path.is_file() and path != artifact / 'release.json')
    if any(path.is_symlink() for path in artifact.rglob('*')):
        raise ValueError('Artifact cannot contain symlinks')
    manifest = {'sourceRevision': revision, 'files': {
        path.relative_to(artifact).as_posix(): digest(path) for path in files}}
    (artifact / 'release.json').write_text(json.dumps(manifest, sort_keys=True) + '\n')
    output.mkdir(parents=True, exist_ok=True)
    archive = output / ('allure-' + revision + '.tgz')
    with archive.open('xb') as stream, tarfile.open(fileobj=stream, mode='w:gz') as bundle:
        for path in [*files, artifact / 'release.json']:
            bundle.add(path, arcname=path.relative_to(artifact).as_posix(), recursive=False)
    return archive


def ssh(host, *arguments):
    return run(['ssh', '-oBatchMode=yes', '-oStrictHostKeyChecking=yes', '-oUpdateHostKeys=no',
                host, shlex.join(arguments)], capture_output=True).stdout.strip()


def remote(host, *arguments):
    return json.loads(ssh(host, 'sudo', '-n', 'python3', REMOTE + '/deploy-web.py',
                          *arguments, '--root', REMOTE + '/data'))


def publish(arguments):
    if not re.fullmatch(r'[a-zA-Z0-9][a-zA-Z0-9._-]*', arguments.host):
        raise ValueError('Use an SSH config host alias')
    installed = ssh(arguments.host, 'sudo', '-n', 'sha256sum', REMOTE + '/deploy-web.py').split()[0]
    if installed != digest(Path(__file__).resolve()):
        raise ValueError('Install the reviewed deployment helper before publishing')
    before = remote(arguments.host, 'status')['current']
    if arguments.command == 'rollback':
        result = remote(arguments.host, 'restore', arguments.revision, '--expected', before or 'none')
        run(['python3', str(REPOSITORY / 'scripts/verify-web.py'), '--revision', arguments.revision])
        return result
    archive = arguments.artifact or package(arguments.output)
    with tarfile.open(archive, 'r:gz') as source:
        revision = json.load(source.extractfile('release.json'))['sourceRevision']
    if not REVISION.fullmatch(revision):
        raise ValueError('Invalid artifact revision')
    run(['git', 'fetch', 'origin', 'main'], cwd=REPOSITORY)
    run(['git', 'merge-base', '--is-ancestor', revision, 'origin/main'], cwd=REPOSITORY)
    checksum = digest(archive)
    upload = ssh(arguments.host, 'mktemp', '-d', '/tmp/allure-upload-XXXXXXXX')
    if not re.fullmatch(r'/tmp/allure-upload-[a-zA-Z0-9]+', upload):
        raise ValueError('Unexpected upload directory')
    try:
        run(['scp', '-oBatchMode=yes', '-oStrictHostKeyChecking=yes', '-oUpdateHostKeys=no',
             str(archive), arguments.host + ':' + upload + '/site.tgz'])
        result = remote(arguments.host, 'activate', upload + '/site.tgz', checksum,
                        '--expected', before or 'none')
        try:
            run(['python3', str(REPOSITORY / 'scripts/verify-web.py'), '--revision', result['current']])
        except subprocess.CalledProcessError:
            remote(arguments.host, 'restore', before or 'none', '--expected', result['current'])
            raise
        return {**result, 'artifact': str(archive)}
    finally:
        ssh(arguments.host, 'rm', '-f', upload + '/site.tgz')
        ssh(arguments.host, 'rmdir', upload)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='command', required=True)
    for command in ['activate', 'restore', 'status']:
        sub = commands.add_parser(command)
        sub.add_argument('--root', type=Path, required=True)
        if command == 'activate':
            sub.add_argument('archive', type=Path)
            sub.add_argument('checksum')
        if command == 'restore':
            sub.add_argument('revision')
        if command != 'status':
            sub.add_argument('--expected', required=True)
    for command in ['deploy', 'rollback']:
        sub = commands.add_parser(command)
        sub.add_argument('--host', default='wf-landings')
        if command == 'rollback':
            sub.add_argument('revision')
        else:
            sub.add_argument('--artifact', type=Path)
            sub.add_argument('--output', type=Path, default=Path.home() / '.local/share/want-allure/releases')
    arguments = parser.parse_args()
    if arguments.command == 'activate':
        result = activate(arguments.root, arguments.archive, arguments.checksum, arguments.expected)
    elif arguments.command == 'restore':
        result = restore(arguments.root, arguments.revision, arguments.expected)
    elif arguments.command == 'status':
        result = status(arguments.root)
    else:
        result = publish(arguments)
    print(json.dumps(result, sort_keys=True))


if __name__ == '__main__':
    main()
