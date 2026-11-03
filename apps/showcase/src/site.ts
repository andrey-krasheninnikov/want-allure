import packageInfo from '../../../packages/react/package.json';
export const version = packageInfo.version;
export const siteUrl = new URL(import.meta.env.SITE_URL || 'https://allure.want.foundation');
export type Locale = 'en' | 'ru';
export type Section = 'home' | 'react' | 'flutter';
export function route(locale: Locale, section: Section = 'home') {
  return (locale === 'ru' ? '/ru/' : '/') + (section === 'home' ? '' : section + '/');
}
export const copy = {
  en: {
    home: 'Overview', skip: 'Skip to content', navigation: 'Main navigation', theme: 'Dark theme', language: 'Switch to Russian',
    title: 'Want Allure: React and Flutter UI kits, one design system',
    description: 'Explore Want Allure: shared design tokens, React and Flutter components, typography, motion and brand resources. Try both UI kits and install the matching packages.',
    headline: 'One design language.', headlineEnd: 'React and Flutter.',
    intro: 'Shared colors, expressive type and considered motion. Build Want interfaces with components made for each framework.',
    react: 'Explore React', flutter: 'Explore Flutter', install: 'Start building',
    overview: 'A common foundation. Native controls.',
    overviewText: 'The same design decisions travel across frameworks. The controls keep the focus, keyboard and input behavior of their platform.',
    foundation: 'Design tokens', foundationText: 'Semantic colors, a complete type scale, local fonts and consistent geometry.',
    components: '44 component families', componentsText: 'From buttons and fields to sheets, notifications, file selection and product compositions.',
    motion: 'Motion with a purpose', motionText: 'Loaders, shimmer, text transitions and glow, with pause controls and accessibility preferences.',
    choose: 'Choose your framework', reactText: 'React 19 components built on Radix, with compiled styles and SSR support.',
    flutterText: 'ForUI-based Flutter components with native controls, Phosphor icons and shader effects.',
    installText: 'Install matching versions. Your application owns its content, state, localization and services.',
    faq: 'Before you begin', questions: [
      ['Can I use both kits in one product?', 'Yes. The adapters share Want foundation tokens, typography and component families. Each uses the conventions of its own framework.'],
      ['Are the fonts included?', 'Days One and Manrope are bundled locally, together with Japanese and Arabic font families. Keep their supplied license notices.'],
      ['Who owns data and translations?', 'The consuming application supplies data, labels, callbacks and persistence. The UI packages do not connect to product services.'],
      ['How does accessibility affect motion?', 'Effects respect reduced motion and other supported accessibility preferences. Persistent effects expose pause controls.'],
    ],
    final: 'See the details in action.', finalText: 'Explore every component in light and dark themes.', source: 'Source code', license: 'Code license',
    catalogue: 'Component catalogue', reactIntro: 'React components, local state and public package imports. Try the controls and their keyboard behavior.',
    flutterIntro: 'The Flutter catalogue runs here with the same theme and language as the site.',
    loading: 'Loading Flutter catalogue…', failed: 'Could not start the Flutter catalogue.', retry: 'Try again', standalone: 'Open standalone catalogue',
    notFound: 'Page not found', notFoundText: 'Choose the overview or a component catalogue from the navigation.',
  },
  ru: {
    home: 'Обзор', skip: 'Перейти к содержимому', navigation: 'Основная навигация', theme: 'Тёмная тема', language: 'Switch to English',
    title: 'Want Allure: UI-киты React и Flutter, единая дизайн-система',
    description: 'Want Allure объединяет дизайн-токены, компоненты React и Flutter, типографику, анимации и фирменную графику. Изучите оба UI-кита и установите совместимые пакеты.',
    headline: 'Единый язык интерфейсов.', headlineEnd: 'React и Flutter.',
    intro: 'Общие цвета, выразительная типографика и продуманная анимация. Создавайте интерфейсы Want с компонентами для своего фреймворка.',
    react: 'Смотреть React', flutter: 'Смотреть Flutter', install: 'Начать разработку',
    overview: 'Общая основа. Нативные элементы.',
    overviewText: 'Единые дизайн-решения работают в обоих фреймворках. Компоненты сохраняют привычное для платформы поведение фокуса, клавиатуры и ввода.',
    foundation: 'Дизайн-токены', foundationText: 'Семантические цвета, полная шкала типографики, локальные шрифты и единая геометрия.',
    components: '44 семейства компонентов', componentsText: 'От кнопок и полей до панелей, уведомлений, выбора файлов и готовых композиций.',
    motion: 'Осмысленная анимация', motionText: 'Индикаторы загрузки, shimmer, смена текста и свечение с паузой и учётом настроек доступности.',
    choose: 'Выберите фреймворк', reactText: 'Компоненты React 19 на Radix, с готовыми стилями и поддержкой SSR.',
    flutterText: 'Компоненты Flutter на ForUI с нативным поведением, иконками Phosphor и шейдерами.',
    installText: 'Устанавливайте совпадающие версии. Данные, состояние, переводы и сервисы остаются в вашем приложении.',
    faq: 'Перед началом', questions: [
      ['Можно использовать оба UI-кита в одном продукте?', 'Да. Адаптеры используют общие токены Want, типографику и семейства компонентов. Каждый следует соглашениям своего фреймворка.'],
      ['Шрифты входят в комплект?', 'Days One и Manrope поставляются локально вместе со шрифтами для японского и арабского языков. Сохраняйте приложенные лицензии.'],
      ['Кто управляет данными и переводами?', 'Приложение передаёт данные, подписи, обработчики и хранит состояние. UI-пакеты не подключаются к продуктовым сервисам.'],
      ['Как настройки доступности влияют на анимацию?', 'Эффекты учитывают уменьшение движения и другие поддерживаемые настройки доступности. Постоянные эффекты позволяют поставить анимацию на паузу.'],
    ],
    final: 'Посмотрите, как это работает.', finalText: 'Изучите каждый компонент в светлой и тёмной темах.', source: 'Исходный код', license: 'Лицензия кода',
    catalogue: 'Каталог компонентов', reactIntro: 'Компоненты React, локальное состояние и публичные импорты пакетов. Проверьте элементы и работу с клавиатурой.',
    flutterIntro: 'Каталог Flutter использует ту же тему и язык, что и сайт.',
    loading: 'Загружаем каталог Flutter…', failed: 'Не удалось запустить каталог Flutter.', retry: 'Попробовать снова', standalone: 'Открыть отдельный каталог',
    notFound: 'Страница не найдена', notFoundText: 'Выберите обзор или каталог компонентов в навигации.',
  },
} as const;
