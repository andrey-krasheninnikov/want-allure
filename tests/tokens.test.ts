import { expect, test } from 'bun:test';
import tokens from '../packages/foundation/tokens.json';

test('the shared theme preserves primary and the graphite/porcelain grounds', () => {
  expect(tokens.themes.wallpapers.dark.primary).toBe('#5962F0');
  expect(tokens.themes.wallpapers.dark.background).toBe('#111216');
  expect(tokens.themes.wallpapers.light.background).toBe('#F7F7FA');
});

test('geometry and glass values remain usable outside CSS', () => {
  expect(tokens.geometry.fieldRadiusPx).toBe(12);
  expect(tokens.glass.blurPx).toBe(20);
  expect(tokens.glass.opacityPercent).toBe(68);
  expect(tokens.motion.feedbackMs).toBe(120);
});
