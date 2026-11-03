## 1.2.1

- Restore optional background pause controls and compact dialog constraints with an accessible hidden title.
- Alternate the Flutter sphere and lightning with a paused, accessibility-aware crossfade.
- Align Flutter toast status plates and multiline messages at the top.

# Changelog

## 1.2.0

- Add a guided framework and installation flow, an orbital selector, automatic logo rotation, letter halos and twelve interface languages.
- Add Flutter SVG extrusion with asset, string and asynchronous builder sources, cached meshes and reduced-motion support.
- Align toast content and table cells, animate page rows, and refine card actions in both adapters.
- Bundle Chinese, Devanagari and Hebrew fonts and add an opaque favicon background.

- Refine the landing page with a floating preference header, a rotatable pixel logo, glowing framework actions, installation instructions and animated FAQ.
- Organize bilingual catalogues into seven categories with shared RTL, direct links, history and retained form values.
- Add controlled Slider/RangeSlider and primary/warning lightning to both adapters; Flutter lightning uses a bundled fragment shader.
- Refine Flutter card hover, table surfaces, comment pagination and restrained spring feedback. Keep invalid input values readable on status fills.

- Disable reduced-motion transitions completely so theme colors update together.

- Fix the default multiline field limit so the textarea can grow from its minimum height.

- Add Want Allure pixel feather logos and backgrounds while preserving existing resource paths.
- Combine the Astro landing page and React/Flutter catalogues in one bilingual web application.
- Share theme and language navigation, and prepare localized search and social metadata.

## 1.1.0

- Refactor Flutter UI ownership into presentation libraries and strict barrel imports while preserving the public Want API.
- Use toastification for themed animated feedback, Phosphor icons and smooth_sheets for bottom sheets. Give every sheet direction an opaque rounded surface.
- Add web text selection with action-first pointer behavior and localized application find behind an opt-in `enableFind` flag.
- Isolate continuous effects and indeterminate progress from static page repaints, and pause their tickers outside the visible viewport.
- Improve attachment cards, control state motion and 360 ms text transitions. Render shimmer and the background sphere with bundled fragment shaders and static fallbacks.
- Keep foundation, React and Flutter versions aligned. Run release checks locally with Actions skipped.


## 1.0.0

- Rename the project to Want Allure and the repository to `want-allure`.
- Publish foundation as `@want-foundation/allure`, React as `@want-foundation/allure-react`, and Flutter as `want_allure`.
- Update imports, package resources, documentation, skill references and six-platform example identifiers.
- Preserve the component APIs, design tokens, fonts, motion and accessibility behavior.
- Document dependency and import changes in the [migration guide](docs/migration-1.0.0.md). Previous releases remain available.

## 0.4.0

### Added

- The `want_desyst` Flutter package, based on ForUI, with the same 44 component families as the web UI kit.
- Shared Dart tokens, bundled fonts and SVG, 17 typography presets, accessible controls and product compositions.
- Native file selection and drop support, animated status feedback, loaders, shimmer, Glow, text transitions and optional background effects.
- A six-platform example, parity checks, package consumer verification, widget tests and visual reference boards.
- Flutter integration guidance in the Want design skill.

### Migration

Flutter consumers can install `want_desyst: ^0.4.0` with Flutter 3.47.7 or newer. Wrap content in `WantTheme` and supply labels, values and callbacks. Web consumers upgrade foundation and React together to 0.4.0; existing exports remain compatible.

## 0.3.0

### Added

- Optional shimmerDelayMs bounds and the want:background-shimmer event for controlled background waves. Existing consumers retain the default interval and cleanup function.

### Migration

Upgrade foundation and React together to 0.3.0. Existing calls need no changes. Consumers may supply wave-delay bounds and dispatch the background event for an immediate wave.

## 0.2.1

### Fixed

- Preserve years 0001–0099 in DateField calendar navigation and formatting.
- Keep navigation and selection within 0001-01-01 through 9999-12-31, with focus on the selected day when opening the calendar. Public props remain unchanged.

## 0.2.0

### Added

- A reusable Want design skill covering brand, voice, composition, typography, motion, UI/UX, and React integration.
- The foundation package's want-design-install command, with project, personal, and custom destinations and preservation of existing installations.
- Checkbox, DropdownMenu, Toast, Tooltip, Combobox, Popover, Table, Pagination, FileUpload, and Progress, with local showcase examples.
- A 17-preset typography scale, Typography and Prose, Japanese/Arabic fonts, custom loaders, shimmers, and animated text.
- Reusable Glow and semantic error, warning, info, and success snackbars.

### Changed

- Use the same five brand/status accents in both themes, with separate readable text roles.
- Add state motion to controls and compact, theme-aware feedback surfaces.
- Center navigation and breadcrumb content while preserving 44 px targets.
- Keep Glow visible under reduced transparency. Reduced motion stops its waves; forced colors hide the decoration.

### Migration

Upgrade foundation and React together to 0.2.0. Existing component calls need no changes. Status surfaces use bright accents with dark ink; use status-text tokens for inline colored copy. New compositions receive controlled values, labels, and callbacks from the consumer. Place Glow in a glow-host and expose pause controls for persistent motion. Install the Want skill separately when needed; importing the UI packages does not install it.

## 0.1.2

### Added

- Public DateField, UrlField, OpenUrl and Window components with consumer-supplied labels.
- Calendar keyboard controls, responsive examples and independent package checks.

### Migration

Upgrade foundation and React together to 0.1.2. Existing component calls need no changes. New DateField calls supply a locale and DateFieldLabels; new UrlField calls supply an openLabel.

## 0.1.1

### Changed

- Publish the foundation and React adapter as @want-foundation/desyst-foundation and @want-foundation/desyst-react. Installation examples use the organization-scoped names.

## 0.1.0

### Added

- Framework-independent tokens, compiled theme styles, local fonts, logo assets and optional interaction effects.
- React 19 primitives and controlled brand, media, contact, theme and comment compositions.
- A local Astro showcase, package installation examples and an isolated consumer check.
