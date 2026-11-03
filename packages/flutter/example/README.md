# Want Allure Flutter catalogue

Run from the repository root with `bun run flutter:example`, or select a device using `fvm flutter run -d <device>` from this directory. The SDK is pinned in the root FVM configuration.

The catalogue exercises all public component families with local state. It includes light/dark themes, RTL, motion and transparency controls, native file selection, overlays and optional effects. It does not connect to a product backend.

Android and iOS projects are examples for local builds. Configure signing in a consuming application. The macOS example grants user-selected read-only file access for its system picker.

The catalogue supports English and Russian, including examples and accessibility labels. ARB sources and the built-in Flutter localization tool own its translations. Run `fvm flutter gen-l10n` after editing an ARB file.

The unified web application is built from the repository root with `bun run web:build` and previewed with `bun run web:preview --port 4321`. Astro embeds this catalogue on its Flutter route and supplies the current language and theme. Theme updates preserve the running engine and example state. Standalone and native launches retain their own theme and language controls. `WANT_ENABLE_FIND` remains opt-in.
