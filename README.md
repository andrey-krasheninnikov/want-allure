# Want Allure

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/brand/readme/banner-dark.svg">
  <img src="assets/brand/readme/banner-light.svg" alt="Want Allure: design system and brand identity" width="1600" height="640">
</picture>

Shared design foundations and UI kits for Want products across web and mobile.

## Packages

- @want-foundation/allure: JSON tokens, compiled CSS, local fonts, brand assets and opt-in browser effects.
- @want-foundation/allure-react: React 19 primitives and generic product compositions built on Radix.
- want_allure: Flutter themes, controls, compositions and motion built on ForUI, for Android, iOS, web, macOS, Windows and Linux.

Foundation, React and Flutter use version 1.4.0. The Flutter adapter is published as `want_allure` on pub.dev and uses ForUI with the same Want tokens and component families.

Upgrading from the previous package names? Follow the [1.0.0 migration guide](docs/migration-1.0.0.md).

## Install a release

For a published release, install the matching versions:

```sh
npm install @want-foundation/allure@1.4.0 @want-foundation/allure-react@1.4.0
```

Import the stylesheet once in the application's entry point. The font stylesheet is optional and serves its font files locally.

```tsx
import '@want-foundation/allure/styles.css';
import '@want-foundation/allure/fonts.css';
import { Button, Field, FieldLabel, Input } from '@want-foundation/allure-react';

export function Example() {
  return <Field>
    <FieldLabel htmlFor="name">Name</FieldLabel>
    <Input id="name" autoComplete="name" />
    <Button type="button">Continue</Button>
  </Field>;
}
```

No stylesheet copying, source aliases or scanning library sources with Tailwind is required. Consumers may bring their own layout styles through className and override semantic variables intentionally. React and React DOM are peers and are not bundled. A consumer that also uses Tailwind 4 can import @want-foundation/allure/tailwind.css after Tailwind to register the same semantic utilities for its own source files. This integration is optional; library components already have compiled CSS.

## Embed a second brand

React and Flutter accept the same versioned brand profile. The minimal JSON document is `{"schemaVersion":1}`. Import it with `parseBrandProfile` or `WantBrandProfileV1.fromJson`. In React, wrap the interface in `AllureProvider` and import `@want-foundation/allure/scoped.css`. In Flutter, pass `WantThemeData.fromProfile` to `WantTheme`. Use `fonts/manrope.css` or another family entry when only one bundled font is needed.

The [React and Flutter quick starts](skills/want-design/references/white-label.md) include working imports, local resource maps and fields for both appearances. See the [52 component families](docs/flutter-parity.md), [composition recipes](skills/want-design/references/recipes.md) and [50 improvements](docs/improvements-50.md).

## Flutter

```sh
flutter pub add want_allure:^1.4.0
```

Import `package:want_allure/want_allure.dart` and wrap the application content with `WantTheme`. The package includes local fonts, SVG assets and Flutter counterparts for the shared component families. See [Flutter documentation](packages/flutter/README.md) and [component parity](docs/flutter-parity.md).

From this checkout, use FVM with Flutter 3.47.7 and Dart 3.13.5:

```sh
fvm install
fvm flutter pub get --directory packages/flutter
bun run flutter:check
bun run flutter:test
bun run flutter:consumer
bun run flutter:example
```

The example supports six platforms and demonstrates themes, RTL, accessibility settings and controlled state. Build and device evidence remain separate.

## Appearance

The landing editor and the header's Appearance menu share settings with both catalogues. Choose a primary color, palette style and typography preset. Scroll the landing preview to see the selection on typography, form feedback and a table. Reset restores `#5962F0`, Contrast and Days One × Manrope. Choose the system, light or dark mode separately.

| Style | Treatment |
| --- | --- |
| Smooth | Sage, mist blue, sand and dusty rose with soft field outlines |
| Contrast | Jade, azure, amber and watermelon on crisp neutral surfaces |
| Neon | Electric mint, cyan, apricot and hot pink |
| Acid | Lime, turquoise, citron and vermilion with a shifted focus hue |

The legacy primary-color API accepts opaque sRGB with HSL saturation from 45% to 90% and lightness from 40% to 70%, inclusive. A v1 profile accepts any opaque `#RRGGBB` brand color and derives accessible UI roles for each appearance. Validate profiles before storing them.

Each style has a palette for violet, warm and teal brand colors. Other hues blend between their neighbors. For a teal primary in Contrast, success is leaf green, info is cornflower blue, warning is apricot and error is rose. Gray seeds keep the style’s original status colors. Each status keeps its color family and uses the same fill in both modes. The SDK resolves separate colors for inline status text and text on a colored fill. Neon preserves bright, saturated seeds such as `#0FFFE3` in both modes. Use `primary-foreground` for text and icons on the action fill and `primary-edge` for thin control marks. The edge stays visible on light surfaces without darkening the entire button.

| Typography preset | Display / body |
| --- | --- |
| Brand | Days One / Manrope |
| Geometric | Unbounded / Manrope |
| Editorial | Literata / Manrope |
| Technical | IBM Plex Mono / IBM Plex Sans |
| Humanist | Atkinson Hyperlegible Next |
| Pixel | Pixelify Sans / Manrope |

Built-in icon variants follow the typography preset. Locale fallbacks cover Japanese, simplified Chinese, Arabic, Hindi and Hebrew. Fonts ship locally with their licenses.

The examples below use the 1.4.0 APIs.

For React, import the styles and fonts as above, then set CSS variables on the themed root. For document-wide themes, set these on the document element so overlays rendered in portals inherit the variables.

```tsx
import { createThemeVariables } from '@want-foundation/allure';

const style = createThemeVariables({
  theme: 'dark',
  primaryColor: '#29C38F',
  paletteStyle: 'neon',
});

// On the application's document root:
<html data-theme="dark" data-typography="pixel" style={style}>…</html>
```

For Flutter, configure the data passed to `WantTheme`. Reuse the same options with `WantThemeData.light` for the other mode.

```dart
final theme = WantThemeData.dark(
  primaryColor: const Color(0xFF29C38F),
  paletteStyle: WantPaletteStyle.neon,
  typographyPreset: WantTypographyPreset.pixel,
);
```

Your application owns the chosen settings and their persistence. The foundation generator runs during SSR. Explicit Flutter color overrides take precedence.

Use the controlled `ThemePicker` and `LanguagePicker` in React, or `WantThemePicker` and `WantLanguagePicker` in Flutter. Pass the saved theme mode and the resolved light or dark appearance separately. Supply localized labels, language names, short codes and emoji flags. See the [React package guide](packages/react/README.md) and [Flutter package guide](packages/flutter/README.md).

## Want design skill

The reusable skill in [skills/want-design/SKILL.md](skills/want-design/SKILL.md) covers Want brand rules, typography, composition, UI/UX, motion, and a calm, concrete product voice. It includes React and Flutter integration guidance and English/Russian UI-copy examples. Product-specific instructions and approved themes take precedence over shared defaults.

Inside this repository, build once and use the root script for a personal installation:

```sh
bun run build
bun run skill:install --global
```

Use `bun run skill:install` for this checkout, or add `--dest /path/to/project/.agents/skills` to select another project. The script supports the same installer options. In this Bun workspace, npm can select the local foundation package without a root bin link, causing `npx` to report `want-design-install: command not found`.

From a consumer project's root, install the published skill with Node.js and npm:

```sh
npx --yes --package=@want-foundation/allure@1.4.0 want-design-install
```

This creates `.agents/skills/want-design` in the current directory. The published skill includes its references and a token snapshot, so it does not need this repository afterward.

For a personal installation shared across projects:

```sh
npx --yes --package=@want-foundation/allure@1.4.0 want-design-install --global
```

This uses `~/.agents/skills/want-design`. Use `--dest PATH` instead of `--global` to select another parent skills directory; `want-design` is appended to that path. Quote paths containing spaces. `--help` lists the options. The installer does not change project configuration or install UI dependencies.

Invoke `$want-design` when working on a Want interface. Discovery also uses the skill's Want-specific description. If the current session has already loaded its skill catalog, start a new session after installation.

From outside this workspace, add `--global --update` to the published installer command to upgrade a personal installation, then use `--global --check` to verify it. In this checkout, `bun run skill:install --check` lists changed resources without writing. `bun run skill:install --update` upgrades a verified installation, retains additional files and stops on local edits. Both flags accept `--global` and `--dest`. For a locally edited or unrecognized installation, keep a backup and review the differences.

## Upgrade

Upgrade foundation and React together to the same released version. Read the changelog and any migration notes, update both dependencies, then run the consumer application's checks. Keep product wrappers and service calls in the consumer.

## Public contracts

Foundation exports its tokens as JSON at @want-foundation/allure/tokens.json and as the tokens JavaScript export. The assets export includes @want-foundation/allure/assets/wallpapers.svg. Importing the JavaScript entry is safe during SSR.

React exports the existing accordion, alert, badge, breadcrumb, button, card, dialog, field, input, label, navigation menu, radio group, select, separator, sheet, skeleton, switch, tabs and textarea families. Their public variants and native element props remain available.

Shared compositions are BrandLogo, BrandLockup, MediaCard, ContactCard, ThemeToggle and CommentFeed. Each exports its props type. Supply product names, images, labels, URLs, prepared comment authors and dates, and action callbacks. CommentFeed does not fetch, reorder or limit records. Optional createdAt contains a machine-readable dateTime and a consumer-prepared label, so SSR and hydration use the same text. ThemeToggle is controlled through theme and onThemeChange; consumers own saved preferences, system-theme subscriptions and telemetry.

DateField accepts a local date (YYYY-MM-DD) or local date and time (YYYY-MM-DDTHH:mm) without changing its wall time. Pass mode, value, onChange, locale and every label in DateFieldLabels. The optional today value lets the consumer supply the current time in its chosen time zone. onCommit fires when a changed value is selected or the calendar closes. The consumer owns storage and conversion to server timestamps. UrlField accepts a controlled URL string and an accessible openLabel. OpenUrl renders a new-tab link only for HTTP(S) URLs. Window renders a page section with a named heading, optional kicker and actions, and consumer content.

Additional controls are Checkbox, DropdownMenu, Toast, Tooltip, Combobox, Popover, Table, Pagination, FileUpload and Progress. Their composition parts and controlled APIs are described in packages/react/README.md.

Set data-theme="light" or data-theme="dark" on the document root for explicit selection. Also toggle the dark class for class-based Tailwind states. Without an explicit choice, the stylesheet follows the system color preference.

## Workspace and guided setup

React and Flutter include a controlled sidebar, resizable panes, search toolbar, list rows, sensitive fields and inline copy feedback. Pass values, labels and callbacks from the application. The catalogue stores its example pane proportions locally and demonstrates setup, JSON export, QR and deletion confirmation with sample data.

Theme changes can opt in to a 360 ms transition through `transitionTheme` on the web and `WantTheme(animateTransitions: true)` in Flutter. The Effects section demonstrates pointer and keyboard rotation, an animated lock shackle, background scenes and a logo wave. Each effect has a reduced-motion fallback.

## Component showcases

The React and Flutter catalogues share seven categories: Foundation, Inputs, Navigation, Data, Feedback, Effects and Compositions. A `section` query parameter opens a category directly. Browser history, language changes and the common theme/RTL controls preserve catalogue context. Visited examples keep edited values; hidden panels pause their motion.

The landing pairs a rotatable feather extrusion with an appearance editor and component previews. Framework selection opens installation commands, then FAQ and tips in the same section. Three.js loads on demand for interactive artwork. The supplied SVG shape remains available as a static fallback.

## Optional effects

```ts
import { initInteractionEffects, burstConfetti, initBackgroundMotion } from '@want-foundation/allure';

const disposeInteractions = initInteractionEffects();
const disposeBackground = initBackgroundMotion({ background, control, shimmerDelayMs: [5000, 10000] });
background.dispatchEvent(new Event('want:background-shimmer'));
const disposeConfetti = burstConfetti(clickedElement);

// Dispose when the owning page unmounts.
disposeInteractions();
disposeBackground();
disposeConfetti();
```

The background container uses the page-background class with one child element. The control supplies data-pause-label and data-play-label. Mount it outside the content flow inside a positioned, clipped page wrapper. The default storage key is want-background-motion; storageKey may override it. Keep this decoration outside administration and reading surfaces.

The optional shimmerDelayMs pair sets the minimum and maximum pause between waves in milliseconds; the default remains [8000, 18000]. Delays must be finite, ordered and within 0 to 2147483647 ms. Dispatch want:background-shimmer on the background container to start or restart its four-second wave. Requests while paused, hidden, reduced-motion or forced-colors are ignored. Restarting a wave preserves the sphere and gradient phases. The consumer owns click targets and hit testing. Cleanup removes the event listener and pending timers.

Effects do not subscribe to application download events or start downloads. Call confetti beside the native download action. Reduced motion, unsuitable pointers and forced colors disable decorative interaction effects.

## Unified web application

The Astro application serves English at `/` and localized pages under `/zh-Hans/`, `/hi/`, `/es/`, `/ar/`, `/fr/`, `/pt-BR/`, `/ru/`, `/de/`, `/ja/`, `/tr/` and `/he/`. Each locale has `/react/` and `/flutter/` catalogues. Language choices follow total first- and second-language speakers; Mandarin represents `zh-Hans` and Portuguese represents `pt-BR`. Navigation preserves the selected category and theme. Arabic and Hebrew default to RTL, with a direction override stored per locale. Flutter initializes only on its catalogue route.

Landing lightning picks a color from the active palette for each stroke. The headline fades in and pulses a background glow behind a character every second. The feather and framework marks use the resolved primary. When the pointer leaves a framework mark, it speeds up to finish the turn and returns to its resting angle. Reduced motion and hidden views stop decorative movement.

Use Bun 1.3.14 and the pinned FVM SDK:

```sh
bun install --frozen-lockfile
bun run dev
```

This prepares the package assets and Flutter runtime, then starts Astro on http://localhost:4321. Astro and React changes reload during development. After editing Flutter, run `bun run web:flutter` to rebuild its embedded runtime. `bun run flutter:example` still runs the standalone example on a selected device.

Build and preview the complete static application:

```sh
bun run web:build
bun run web:preview --port 4321
```

The artifact is `apps/showcase/dist`, including `/_flutter/`. Generated runtime files are ignored by Git. `bun run build` continues to build only the public npm packages. The default canonical origin is `https://allure.want.foundation`; `SITE_URL` may override it at build time. For local publication, HTTP verification and rollback on the existing Want hosting, see [deployment instructions](docs/deployment.md). Production acceptance is tracked in [issue #20](https://github.com/andrey-krasheninnikov/want-allure/issues/20).

## Brand resources

The source artwork lives in `assets/brand`. Logo variants, backgrounds, favicon, social images and README banners preserve the supplied geometry and colors. The source set includes its original usage notes and font licenses. The ZIP duplicate is not stored.

Run `bun run assets:sync` after changing the source artwork. `bun run assets:check` verifies the package and Flutter web copies. Runtime logos and backgrounds are distributed under `@want-foundation/allure/assets/allure/` and Flutter's `assets/brand/allure/`. The existing Wallpapers asset remains available. Product applications choose their own approved identity.

`LightningBackground` (React) and `WantLightningBackground` (Flutter) show primary and warning discharges by default. Both accept a pause flag and a custom color pair. React also accepts a `colorPool` of CSS colors, including semantic variables. Flutter uses a bundled fragment shader with a static fallback. Effects pause outside the viewport and when the document or application is inactive. Reduced motion keeps a static drawing.

## Develop and verify

```sh
bun run check
bun test tests
bun run flutter:check
bun run flutter:test
bun run web:build
bun run test:ui
bun run test:consumer
bun run flutter:consumer
```

Checks run locally. Browser checks use the combined production artifact and cover localized landing pages, navigation, themes, Flutter initialization and existing React controls. Reports and screenshots stay outside the source tree. Consumer checks install separate distributions and remove their temporary projects afterward. Production, physical-device and local test evidence remain distinct.

## Release

Build and verify the final candidate before publishing. Inspect both tarballs, keep only distribution files and license notices, and publish foundation before React with public access. The shared release uses the v1.4.0 tag. Never overwrite a published version; reconcile a registry response before retrying a timed-out publish.

The npm organization is want-foundation. Publishing requires a signed-in owner with the required npm authentication. Credentials never belong in source files. Registry availability is confirmed as part of release, separately from the source merge.

## Boundaries and licensing

Read AGENTS.md, DESIGN.md, GLOSSARY.md and docs/adr. Repository workflow configuration lives in docs/agents and can be edited directly.

The initial source is Want Wallpapers main at 27370a2b8228b54e0c1b9432f01373bc8bf000ef. The catalogue, backend, application routes, analytics and advertising stay there. Consumer adoption is tracked separately in https://github.com/andrey-krasheninnikov/want-wallpapers/issues/174.

MIT applies to this repository's code. Preserve the included font licenses and third-party notices. Brand resources retain their existing notices.
