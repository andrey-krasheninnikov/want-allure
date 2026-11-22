#!/usr/bin/env node
import { cp, lstat, mkdir, mkdtemp, readdir, readFile, realpath, rename, rm, rmdir, unlink, writeFile } from 'node:fs/promises';
import { dirname, join, resolve, sep } from 'node:path';
import { createHash } from 'node:crypto';
import { homedir } from 'node:os';
import { fileURLToPath } from 'node:url';

const help = `Install the Want design skill.

Usage: want-design-install [--global | --dest PATH] [--check | --update]

  default       Install into .agents/skills/want-design in the current directory
  --global      Install into ~/.agents/skills/want-design
  --dest PATH   Use another parent skills directory
  --check       Compare installed resources without writing (exit 1 for differences)
  --update      Update an unmodified installation and retain additional local files
  --help        Show this help

The default command preserves the existing installation.
`;

export function parseArgs(args) {
  const options = { global: false, dest: undefined, help: false };
  for (let index = 0; index < args.length; index++) {
    const arg = args[index];
    if (arg === '--') continue;
    if (arg === '--global') options.global = true;
    else if (arg === '--check') options.check = true;
    else if (arg === '--update') options.update = true;
    else if (arg === '--help') options.help = true;
    else if (arg === '--dest') {
      const value = args[++index];
      if (options.dest !== undefined || !value?.trim() || value.startsWith('-')) throw new Error('--dest requires one directory path.');
      options.dest = value;
    } else throw new Error('Unknown argument: ' + arg);
  }
  if (options.global && options.dest !== undefined) throw new Error('Use either --global or --dest, not both.');
  if (options.check && options.update) throw new Error('Use either --check or --update.');
  return options;
}

async function inspect(path) {
  try { return await lstat(path); }
  catch (error) { if (error.code === 'ENOENT') return null; throw error; }
}

async function payload(directory, prefix = '') {
  const files = [];
  for (const entry of await readdir(join(directory, prefix), { withFileTypes: true })) {
    const name = join(prefix, entry.name);
    if (entry.isDirectory()) files.push(...await payload(directory, name));
    else if (entry.isFile()) files.push({ name, content: await readFile(join(directory, name)) });
    else throw new Error('Unsupported skill resource: ' + name);
  }
  return files;
}

const receipt = '.want-design-install.json';
const digest = bytes => createHash('sha256').update(bytes).digest('hex');
const legacy = {
  "SKILL.md": "e3d32c2c172919a6c65e3101969688c6c01ac9505f37208577ce6ffeff1c6155",
  "references/brand-ui.md": "0e600d155c6c60236a0fd24ed2f4c557c8d235171621ef8c8d860bbbb8c0055e",
  "references/flutter.md": "10e74338d2ac258974e1e7cf075e3d142f2d131d0f2a97afb9b0b06e63dcdbd5",
  "references/motion.md": "5f3d3080037f1737b9025d2a14c5a07ad3a75451a890905028b2f5878d4b8e87",
  "references/react.md": "a0deafc718682d4cf9d0dadeb29af203a4237dcd0fa64aa7d0458e64a66a3ce2",
  "references/voice.md": "ddb88c147a447a2d8ae1b16f02ab0dbadf9dce6a20783a06319dc331a3d2daef",
  "references/tokens.json": "0e5ab794d56026f1e620f58e6b589c3ceed8b40bb16037e25ed7907ca2183b61"
};

const legacy100 = {
  ...legacy,
  "references/flutter.md": "3a7cf7265305a4a603d1e78cbd097c6c39c458639d24a98ed12dab55b00bc7ef",
  "references/motion.md": "c49da856bd30dbb8f710ce9deec662cbd4db5506deab957e11e1774b265b86d2",
  "references/react.md": "1f36cfa93b5d10015e499a03f0d5952e4c927efe4a7b3135a313d0ee7741d571",
  "references/tokens.json": "32da55d7bfb813f8ae677e7c08fafd71e6168c700331f380b6663b96ae5daa0a"
};

async function readManaged(directory, name) {
  let path = directory;
  for (const part of name.split(sep)) {
    path = join(path, part);
    const entry = await inspect(path);
    if (!entry) return null;
    if (entry.isSymbolicLink() || (path === join(directory, name) ? !entry.isFile() : !entry.isDirectory())) {
      throw new Error('A different installation exists. Expected a regular resource: ' + path);
    }
  }
  return readFile(path);
}

async function populate(directory, files) {
  for (const { name, content } of files) {
    const file = join(directory, name);
    await mkdir(dirname(file), { recursive: true });
    await writeFile(file, content, { flag: 'wx' });
  }
}

export async function installSkill({ source, cwd = process.cwd(), global = false, dest, home = homedir(), check = false, update = false }) {
  if (global && dest !== undefined) throw new Error('Use either --global or --dest, not both.');
  if (check && update) throw new Error('Use either --check or --update.');
  const files = await payload(source);
  if (!files.some(file => file.name === 'SKILL.md')) throw new Error('The skill bundle is missing SKILL.md.');
  if (files.some(file => file.name === receipt)) throw new Error('Reserved skill resource: ' + receipt);
  const next = Object.fromEntries(files.map(file => [file.name, digest(file.content)]));
  const parent = global ? join(home, '.agents', 'skills') : dest !== undefined ? resolve(cwd, dest) : join(cwd, '.agents', 'skills');
  const target = join(parent, 'want-design');
  const inspectTarget = async (directory = target) => {
    const existing = await inspect(directory);
    if (!existing) return null;
    if (!existing.isDirectory() || existing.isSymbolicLink()) throw new Error('The skill destination must be a regular directory: ' + target);
    const saved = await readManaged(directory, receipt);
    const installed = Object.create(null);
    const hashes = async names => {
      for (const name of names) {
        if (Object.hasOwn(installed, name)) continue;
        const content = await readManaged(directory, name);
        if (content) installed[name] = digest(content);
      }
    };
    await hashes(Object.keys(next));
    if (saved) installed[receipt] = digest(saved);
    let previous;
    if (saved) {
      const data = JSON.parse(saved.toString());
      if (data?.schemaVersion !== 1 || !data.files || typeof data.files !== 'object' || Array.isArray(data.files)) throw new Error('Invalid skill receipt.');
      previous = data.files;
    } else {
      await hashes(Object.keys(legacy));
      previous = [legacy, legacy100].find(files =>
        Object.entries(files).every(([name, hash]) => installed[name] === hash));
    }
    for (const [name, hash] of Object.entries(previous ?? {})) {
      if (name === receipt || !name.split(/[\\/]/).every(part => part && part !== '.' && part !== '..') || !/^[0-9a-f]{64}$/.test(hash)) throw new Error('Invalid skill receipt.');
    }
    await hashes(Object.keys(previous ?? {}));
    const changed = Object.keys(next).filter(name => installed[name] !== next[name]);
    const removed = Object.keys(previous ?? {}).filter(name => !Object.hasOwn(next, name));
    return { previous, installed, changed: [...changed, ...removed] };
  };

  const current = await inspectTarget();
  if (check) return { target, alreadyInstalled: current?.changed.length === 0, differences: current?.changed ?? Object.keys(next) };
  if (current?.changed.length === 0 && (!update || current.installed[receipt])) return { target, alreadyInstalled: true };
  if (current && !update) throw new Error('A different installation exists. Check it with --check before updating: ' + target);

  await mkdir(parent, { recursive: true });
  const lock = join(parent, '.want-design-install.lock');
  await mkdir(lock);
  let staging, retainBackup = false;
  try {
    const state = await inspectTarget();
    if (state && !update) {
      if (!state.changed.length) return { target, alreadyInstalled: true };
      throw new Error('A different installation exists: ' + target);
    }
    if (state?.changed.length) {
      if (!state.previous) throw new Error('Unrecognized installation. Move it to a backup before installing: ' + target);
      for (const [name, hash] of Object.entries(state.previous)) {
        if (state.installed[name] !== hash) throw new Error('Local modification: ' + name);
      }
      for (const name of Object.keys(next)) {
        if (!Object.hasOwn(state.previous, name) && Object.hasOwn(state.installed, name)) throw new Error('Local file would be replaced: ' + name);
      }
    }
    staging = await mkdtemp(join(parent, '.want-design-stage-'));
    const ready = join(staging, 'next'), backup = join(staging, 'previous');
    if (state) {
      await cp(target, ready, { recursive: true, preserveTimestamps: true, verbatimSymlinks: true });
      const snapshot = await inspectTarget(ready);
      if (JSON.stringify(snapshot.installed) !== JSON.stringify(state.installed)) throw new Error('Installation changed during update. Retry after local edits finish.');
      for (const name of Object.keys(state.previous ?? next)) await unlink(join(ready, name));
      if (state.installed[receipt]) await unlink(join(ready, receipt));
    } else await mkdir(ready);
    await populate(ready, files);
    await writeFile(join(ready, receipt), JSON.stringify({ schemaVersion: 1, files: next }, null, 2) + '\n', { flag: 'wx' });
    if (state) await rename(target, backup);
    try { await rename(ready, target); }
    catch (error) {
      if (state) {
        retainBackup = true;
        await rename(backup, target);
        retainBackup = false;
      }
      throw error;
    }
    return { target, alreadyInstalled: false, updated: !!state };
  } finally {
    try { if (staging && !retainBackup) await rm(staging, { recursive: true, force: true }); }
    finally { await rmdir(lock); }
  }
}

if (process.argv[1] && await realpath(process.argv[1]).catch(() => null) === fileURLToPath(import.meta.url)) {
  try {
    const options = parseArgs(process.argv.slice(2));
    if (options.help) process.stdout.write(help);
    else {
      const result = await installSkill({ ...options, source: fileURLToPath(new URL('./skill/', import.meta.url)) });
      if (options.check && !result.alreadyInstalled) {
        console.error('Skill differs: ' + result.differences.join(', '));
        process.exitCode = 1;
      } else console.log((result.alreadyInstalled ? 'Already installed: ' : result.updated ? 'Updated: ' : 'Installed: ') + result.target);
    }
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
  }
}
