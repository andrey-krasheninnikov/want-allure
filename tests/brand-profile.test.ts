import { expect, test } from 'bun:test';
import { parseBrandProfile, resolveBrandProfile } from '../packages/foundation/src/brand-profile';
import { colorContrast } from '../packages/foundation/src/appearance';
import fixture from './fixtures/brand-profile-v1.json';

test('profile v1 resolves shared fixtures in both appearances', () => {
  expect(colorContrast('#000000', '#FFFFFF')).toBe(21);
  expect(() => colorContrast('#ffffff80', '#000000')).toThrow('#RRGGBB');
  for (const { profile, light, dark } of fixture.valid) {
    const parsed = parseBrandProfile(JSON.parse(JSON.stringify(profile)));
    expect(resolveBrandProfile(parsed, 'light')).toMatchObject(light);
    expect(resolveBrandProfile(parsed, 'dark')).toMatchObject(dark);
  }
  for (const { profile, path } of fixture.invalid) expect(() => parseBrandProfile(profile)).toThrow(path);
  expect(() => parseBrandProfile({ schemaVersion: 1, radii: { field: NaN } })).toThrow('field');
});
