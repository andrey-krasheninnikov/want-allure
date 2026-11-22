import { expect, test } from 'bun:test';
import { scopedCss } from '../scripts/scoped-css';

test('root resets and provider selectors target their scope without rewriting attribute values', () => {
  const result = scopedCss('html,:host{display:block}body{margin:0}[data-allure-scope] button{color:red}.type[data-variant=body]{font:inherit}@keyframes turn{to{rotate:1turn}}');
  expect(result).toContain('@scope ([data-allure-scope]) to ([data-allure-scope])');
  expect(result).toContain(':scope,:scope{display:block}');
  expect(result).toContain(':scope button{color:red}');
  expect(result).toContain('[data-variant=body]');
  expect(result.indexOf('@keyframes turn')).toBeLessThan(result.indexOf('@scope'));
});
