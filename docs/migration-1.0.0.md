# Migrate to Want Allure 1.0.0

Want Allure replaces the Want Desyst package names. Component behavior, public component names, themes and tokens remain the same. Previous package versions remain available.

## Web

Replace both dependencies together:

| Previous package | Replacement |
| --- | --- |
| `@want-foundation/desyst-foundation` | `@want-foundation/allure` |
| `@want-foundation/desyst-react` | `@want-foundation/allure-react` |

```sh
npm uninstall @want-foundation/desyst-foundation @want-foundation/desyst-react
npm install @want-foundation/allure@1.0.0 @want-foundation/allure-react@1.0.0
```

Keep React 19 and React DOM installed as peers. Replace the package prefix in JavaScript, TypeScript and CSS imports, including stylesheet, font, token, asset and optional Tailwind entrypoints:

```tsx
import '@want-foundation/allure/styles.css';
import '@want-foundation/allure/fonts.css';
import { tokens } from '@want-foundation/allure';
import { Button, Glow } from '@want-foundation/allure-react';
```

The paths `/tokens.json`, `/assets/wallpapers.svg` and `/tailwind.css` retain their structure under `@want-foundation/allure`. CSS variables and classes retain their names. Keep the same component props and callbacks.

Install the shared Want design skill from the new foundation package:

```sh
npx --yes --package=@want-foundation/allure@1.0.0 want-design-install
```

The command and installed skill remain `want-design-install` and `want-design`. An existing installation with different content is never overwritten. Move that installation to a backup first, then run the command again with the same destination options.

## Flutter

Replace the dependency:

```yaml
dependencies:
  want_allure: ^1.0.0
```

Remove `want_desyst` from `pubspec.yaml` and replace imports:

```dart
import 'package:want_allure/want_allure.dart';
```

Use the same `WantTheme`, `WantButton` and other public Want-prefixed APIs. Update any direct asset references from `package: 'want_desyst'` to `package: 'want_allure'`, and package-qualified font names from `packages/want_desyst/` to `packages/want_allure/`. The bundled font files and `assets/brand/wallpapers.svg` retain their paths.

Run `flutter pub get` and rebuild the application so generated package and font manifests use the new name. The pinned Flutter version, ForUI integration and Android Gradle 8 requirement remain unchanged.

The catalogue project is `want_allure_example`. Its native identifiers use `design.want.want_allure_example` on Android and Linux, and `design.want.wantAllureExample` on iOS and macOS. These example identities do not change identifiers in consuming applications.

## Repository

The repository is now `https://github.com/andrey-krasheninnikov/want-allure`. Update existing clone remotes:

```sh
git remote set-url origin https://github.com/andrey-krasheninnikov/want-allure.git
```

Existing tags and release history retain their original contents. Historical package names in earlier changelog entries describe those releases.
