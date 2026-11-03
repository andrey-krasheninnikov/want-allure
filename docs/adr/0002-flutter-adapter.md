# 0002: A ForUI-based Flutter adapter

Status: accepted.

`want_allure` is the Flutter adapter in this monorepository. It implements the web component families using public ForUI primitives, Flutter composition and the shared Want theme. All packages use the same release version. The first Flutter release was 0.4.0 as `want_desyst`; current package names follow [0003: Want Allure naming and release](0003-want-allure.md).

The canonical token JSON stays in foundation. A deterministic build step derives the Dart constants, and a check rejects drift. Flutter bundles TTF fonts and the original SVG with their licenses, without depending on npm or network font loading at runtime.

Public components use Want-prefixed names, values, callbacks and native controllers. Applications own routes, business validation, persistence, uploads and localized copy. ForUI supplies control and most overlay behavior; toastification delivers notifications and smooth_sheets supplies bottom-sheet motion, as recorded in [0004](0004-flutter-presentation.md); the adapter supplies Want styling and missing compositions. React-specific composition parts map to native builders and slots.

The supported targets are Android, iOS, web, macOS, Windows and Linux. File selection uses file_selector. Cross-platform drop handling uses super_drag_and_drop because the current six-platform desktop_drop release requires a cross_file version incompatible with file_selector. No dependency overrides are used. The native bridge requires Gradle 8 until its CargoKit integration supports Gradle 9; the Android example pins a compatible Gradle, AGP and Kotlin combination.

Package distribution files, fonts, public imports, example builds and an isolated consumer form one contract. Release checks distinguish source tests, CI builds, rendered behavior and physical-device evidence.
