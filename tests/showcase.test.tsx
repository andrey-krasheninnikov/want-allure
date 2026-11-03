import { expect, test } from 'bun:test';
import { renderToStaticMarkup } from 'react-dom/server';
import Showcase from '../apps/showcase/src/components/Showcase';
import { translate } from '../apps/showcase/src/i18n/catalogue';

test('catalogue server rendering localizes controls and accessible names', () => {
  const en = renderToStaticMarkup(<Showcase locale="en" />);
  const ru = renderToStaticMarkup(<Showcase locale="ru" />);
  expect(en).toContain('Shared by design.');
  expect(ru).toContain('Общий дизайн.');
  expect(ru).toContain('aria-label="Пример навигации"');
  expect(ru).toContain('Открыть диалог');
  expect(ru).toContain('Бренд и тема');
  expect(ru).toContain('aria-label="Тема компонента"');
  expect(ru).toContain('Выбрать вложения');
  expect(ru).toContain('Фиолетовый горизонт');
  expect(ru).not.toContain('>Open dialog<');
  expect(en).toContain('WANT / ALLURE / REACT / 1.2.0');
});

test('translation preserves spacing, placeholders and technical text', () => {
  expect(translate('ru', ' Guest ')).toBe(' Гость ');
  expect(translate('ru', 'Notifications ({hotkey})')).toBe('Уведомления ({hotkey})');
  expect(translate('en', 'Guest')).toBe('Guest');
  expect(translate('ru', 'const theme = "dark";')).toBe('const theme = "dark";');
});
