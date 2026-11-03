## 1.0.0

## 1.1.1

- Let Flutter consumers hide the background pause control while retaining reduced-motion and inactive-view suspension. The control remains visible by default.
- Add dialog width constraints and an optional hidden visual title while preserving the accessible dialog name.
- Keep foundation, React and Flutter release versions aligned.

## 1.1.0

- Refactor Flutter UI ownership into presentation libraries and strict barrel imports while preserving the public Want API.
- Use toastification for themed animated feedback, Phosphor icons and smooth_sheets for bottom sheets. Give every sheet direction an opaque rounded surface.
- Add web text selection with action-first pointer behavior and localized application find behind an opt-in `enableFind` flag.
- Isolate continuous effects and indeterminate progress from static page repaints, and pause their tickers outside the visible viewport.
- Improve attachment cards, control state motion and 360 ms text transitions. Render shimmer and the background sphere with bundled fragment shaders and static fallbacks.
- Keep foundation, React and Flutter versions aligned. Run release checks locally with Actions skipped.


- Rename the package to `want_allure` and the public import to `package:want_allure/want_allure.dart`.
- Update bundled font and asset package paths, documentation and six-platform example identifiers.
- Preserve all 44 component families, Want-prefixed APIs, themes, motion and accessibility behavior.
- Existing consumers replace the package dependency and imports; see the [migration guide](https://github.com/andrey-krasheninnikov/want-allure/blob/v1.0.0/docs/migration-1.0.0.md).

## 0.4.0

- First public Flutter release, based on ForUI 0.27.7.
- Implement all 44 web component families with shared Want themes and public Want-prefixed widget APIs.
- Include token-derived styling, 17 typography presets, local fonts and the original SVG asset.
- Add native file selection, cross-platform drop handling, controlled dates, URLs, comments and product compositions.
- Include animated snackbars, toast, loaders, shimmer, text transitions, Glow and optional background/interaction effects.
- Support keyboard interaction, RTL, text scaling, 44 px targets and accessibility motion settings.
- Provide a six-platform example, widget tests, visual references and isolated consumer verification.
