# Want Allure

Пиксельный павлин и набор графики Want Allure. Квадратные фирменные фоны используют индиговое свечение и расходящиеся контуры перьев.

![Обзор вариантов](preview.png)

## Основные файлы

| Вариант | SVG | PNG 2048×2048 |
| --- | --- | --- |
| Светлая тема | [Вектор](want-allure-brand-light.svg) | [Растр](want-allure-brand-light.png) |
| Тёмная тема | [Вектор](want-allure-brand-dark.svg) | [Растр](want-allure-brand-dark.png) |

Исходные `want-allure-peacock.svg` и `want-allure-peacock.png` сохранены. Геометрия полного знака во всех новых вариантах соответствует исходнику. Надписи в баннерах переведены в контуры; устанавливать шрифты не требуется.

## Темы и фоны

В `logos/light/` и `logos/dark/` находятся четыре варианта в SVG и PNG 2048×2048:

| Имя | Фон |
| --- | --- |
| `transparent` | Прозрачный |
| `light` | Светлый |
| `dark` | Тёмный |
| `brand` | Фирменный фон с градиентом и контурами |

Для непрозрачных фонов цвет знака подобран с учётом контраста. На прозрачном фоне светлая тема использует `#5962F0`, а тёмная использует `#B8BFFF`. На тёмном фирменном фоне знак имеет цвет `#F6F7FF`.

Отдельные фирменные фоны без знака: [светлый SVG](backgrounds/brand-light.svg), [светлый PNG](backgrounds/brand-light.png), [тёмный SVG](backgrounds/brand-dark.svg), [тёмный PNG](backgrounds/brand-dark.png).

## Telegram

В `telegram/light/` и `telegram/dark/` находятся все четыре фона:

- `avatar-{фон}-1024.svg`: векторный мастер.
- `avatar-{фон}-1024.png`, `-512.png`, `-256.png`: квадратные экспорты.
- `avatar-brand-1024.jpg`: фирменный аватар в JPEG.
- `avatar-brand-circle-preview.svg` и `.png`: предварительный просмотр круглой обрезки.

Для загрузки аватара используйте непрозрачный PNG или JPEG. Прозрачные версии предназначены для компоновки. Размер и положение павлина оставляют запас под круглую обрезку.

Основные варианты: [светлый PNG 1024](telegram/light/avatar-brand-1024.png), [тёмный PNG 1024](telegram/dark/avatar-brand-1024.png).

Баннеры для описания или приветственного сообщения, 640×360: [светлый PNG](telegram/description-light.png), [тёмный PNG](telegram/description-dark.png), [светлый SVG](telegram/description-light.svg), [тёмный SVG](telegram/description-dark.svg).

## GitHub

В `github/light/` и `github/dark/` находятся аватары со всеми четырьмя фонами: SVG 512×512 и PNG 256×256, 512×512.

Социальные карточки: [светлая PNG](github/social-preview-light.png), [тёмная PNG](github/social-preview-dark.png), [светлая SVG](github/social-preview-light.svg), [тёмная SVG](github/social-preview-dark.svg). Размер PNG составляет 1280×640, каждый файл меньше 1 MB, как указано в [требованиях GitHub](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/customizing-your-repositorys-social-media-preview).

## Баннер README

В `readme/` находятся `banner-light.svg`, `banner-dark.svg` и соответствующие PNG 1600×640.

Баннеры README, GitHub и Telegram используют стилистику [Want Wallpapers](https://wallpapers.want.foundation/) и [Want design](https://github.com/andrey-krasheninnikov/want-allure/blob/main/skills/want-design/SKILL.md): Days One для названия, Manrope 400 для подписей, нейтральные фоны `#F6F5F3` и `#141414`, заполненные капсулы и мягкую фиолетовую сферу. Павлин сохраняет исходный цвет `#5962F0` в обеих темах. Фон статичен.

[HTML-превью всех шести баннеров](banners.html) работает локально без сети. Шрифты встроены в страницу; лицензии находятся в `font-licenses/`. В SVG надписи переведены в контуры, а PNG отрендерены из тех же SVG в HTML. Дизайн сверен с foundation из ревизии `51444a2d37ad25f0b9f03723716ce7d5d439b0ff`.

Для README, рядом с которым расположен каталог `assets`:

```html
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/readme/banner-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset="assets/readme/banner-light.svg">
  <img src="assets/readme/banner-light.svg" alt="Want Allure: Design system &amp; brand identity" width="1600" height="640">
</picture>
```

## Favicon

Для favicon используется отдельная микроверсия павлина. В ней сохранены птица и пять перьев веера, а мелкие детали упрощены для размера 16 px. Полный знак находится в остальных наборах.

В `favicon/light/` и `favicon/dark/`:

- PNG: 16, 32, 48, 64, 96, 128, 180, 192, 256 и 512 px.
- `favicon-512.svg`: векторная микроверсия.
- `favicon.ico`: размеры 16, 32, 48, 64 и 256 px внутри одного файла.
- `apple-touch-icon.png`: 180×180 на непрозрачном фоне.
- `maskable-512.svg` и `.png`: знак с дополнительными полями для обрезки системной маской.
- `site.webmanifest`: ссылки на иконки 192, 512 и maskable 512 px.

В корне `favicon/` находятся адаптивный `favicon.svg`, стандартный светлый `favicon.ico` и монохромный `safari-pinned-tab.svg`. Адаптивный SVG выбирает цвет по `prefers-color-scheme`.

![Favicon в разных размерах](favicon/preview.png)

После копирования `favicon/` в публичный каталог сайта:

```html
<link rel="icon" href="/favicon/favicon.ico" sizes="16x16 32x32 48x48 64x64 256x256">
<link rel="icon" href="/favicon/favicon.svg" type="image/svg+xml" sizes="any">
<link rel="apple-touch-icon" href="/favicon/light/apple-touch-icon.png" sizes="180x180">
<link rel="mask-icon" href="/favicon/safari-pinned-tab.svg" color="#5962F0">
<link rel="manifest" href="/favicon/light/site.webmanifest">
```

Пути в манифесте относительны его каталогу. Перед включением манифеста в приложение проверьте нужную тему и добавьте параметры запуска приложения.

## Использование

Для загрузки в сервисы используйте PNG или JPEG. Для вёрстки и масштабирования используйте SVG. Сохраняйте пропорции знака и поля аватаров. Не растягивайте пиксельный знак по одной оси.

SVG содержат векторные контуры и градиенты без внешних изображений, шрифтов и скриптов. В прозрачных PNG все просветы между перьями, внутри перьев и вокруг птицы также прозрачны.
