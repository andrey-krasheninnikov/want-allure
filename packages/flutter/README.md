# Want Allure for Flutter

For existing installations, follow the [1.0.0 migration guide](https://github.com/andrey-krasheninnikov/want-allure/blob/v1.0.0/docs/migration-1.0.0.md).

ForUI-based Want components for Android, iOS, web, macOS, Windows and Linux. The package shares the web UI kit's colors, geometry, typography, motion and component families.

## Install

Requires Flutter 3.47.7 and Dart 3.13.5 or newer.

```sh
flutter pub add want_allure:^1.2.2
```

Use your existing application shell and localization setup. Apply WantTheme in the application builder so routes and overlays inherit the theme:

```dart
import 'package:flutter/widgets.dart';
import 'package:want_allure/want_allure.dart';

Widget themedContent(BuildContext context, Widget child) {
  return WantTheme(
    data: WantThemeData.dark(),
    child: WantToaster(child: child),
  );
}

class ContinueAction extends StatelessWidget {
  final VoidCallback onContinue;
  const ContinueAction({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) => WantButton(
    onPressed: onContinue,
    child: const Text('Continue'),
  );
}
```

Add `FLocalizations.localizationsDelegates` and `FLocalizations.supportedLocales` to the application's localization configuration. These setup helpers and `FLucideIcons` are available from the public import. The example shows a complete application.

## Components

The public API covers all 44 web families: forms, navigation, cards, overlays, tables, pagination, file selection, date/time and URL fields, brand/media/contact/comment compositions, typography, loaders, shimmer, animated text, Glow and semantic snackbars. Native builders and slots replace React-only trigger and portal parts.

See the [component parity table](https://github.com/andrey-krasheninnikov/want-allure/blob/v1.0.0/docs/flutter-parity.md) and [interactive example source](https://github.com/andrey-krasheninnikov/want-allure/tree/v1.0.0/packages/flutter/example).

Components receive values, labels and callbacks. A null button callback disables interaction. WantCheckbox supports a controlled mixed state through indeterminate. Applications own routes, URLs launched by `onOpen`, data, persistence, time-zone conversion and uploads. The package adds no state-management framework or product services.

WantThemeData.light/dark provide the same primary #5962F0, success #7DF04A, info #28D7F5, warning #FFD43B and error #FF526D accents. Separate text roles preserve contrast. Override semantic values intentionally through the theme's overrides map. The source of truth remains the shared foundation JSON.

WantTypography provides display, h1–h6, lead, body, small, caption, label, overline, mono, code, codeBlock and quote. TTF fonts and their licenses are bundled; no font download occurs at runtime. The Wallpapers SVG remains available at `assets/brand/wallpapers.svg` in package `want_allure`; products supply their own logo when appropriate.

## Web selection and find

Wrap the application builder's content with `WantWebScope`, inside `WantTheme`. Supply `WantFindLabels` with localized search, previous, next and close labels, plus a match-status formatter. The scope enables text selection on web; native apps can opt in with `enabled: true`. Application find is disabled by default. Set `enableFind: true` to opt in; when false, no find controller, keyboard interception, text discovery or highlight overlay is mounted.

```dart
WantWebScope(
  enableFind: true, // Optional; false by default.
  labels: WantFindLabels(
    search: 'Find in page',
    previous: 'Previous match',
    next: 'Next match',
    close: 'Close find',
    matchStatus: (index, count) => count == 0
        ? 'No matches'
        : 'Match ${index + 1} of $count',
  ),
  child: child,
)
```

With find enabled, Cmd/Ctrl+F opens the bar, Enter and Shift+Enter navigate, and Escape closes it and restores focus. `WantWebScope.openFind(context)` opens it from an explicit action and returns false when disabled. Use `WantWebScope.findEnabledOf(context)` to show that action only when available. Turning the flag off closes and disposes an open find session. Search covers rendered plain text, rich text and Want component labels, including built content outside the viewport. Editable fields, passwords, collapsed content and icons are excluded. Unbuilt lazy-list rows need data registration through `find_in_page`; the catalogue builds its sections eagerly. Browser-menu Find still uses the browser's own engine and cannot search Flutter canvas text. Browsers can reserve shortcuts, so provide an explicit search action.

Use `WantIcons` and `WantIcon` for Phosphor regular and duotone icons. Existing `FLucideIcons` imports remain available. Mirror directional navigation when composing RTL controls; preserve artwork orientation.

## Feedback and motion

Wrap application content with WantToaster. Notifications use a scoped toastification instance with Want surfaces and entry/exit motion. Call showWantToast or showWantSnackbar from a descendant context with a title, localized close label and optional description/action. Snackbar variants are error, warning, info and success. Errors persist by default; other statuses last five seconds. Pass a duration to override or null to persist. Hover, keyboard focus, accessible navigation and inactive views pause timed dismissal.

WantLoader supports spinner, dots, bars and orbit. WantShimmer supports block, text, avatar and card. WantAnimatedText supports fade, slide and blur over 360 ms and retains only the current value. WantGlow decorates its child with a broad halo and two waves; leave space around the host for the waves.

Use paused for loops. WantTheme follows system reduced-motion settings; reduceMotion can explicitly override this for a preview. Reduced transparency keeps Glow visible and makes WantGlass opaque. High contrast hides decorative effects. Animation resources stop for inactive views and are disposed with the widget.

WantBackgroundMotion requires a caller-owned WantBackgroundController and localized pause/resume labels. Default wave delays are 8–18 seconds. pause, resume, toggle and triggerWave preserve the independent background phase. Dispose the controller when its owner ends. WantConfetti uses an integer trigger; increment it beside an action. WantWand is opt-in around an interactive control and preserves normal hit testing and pointers.

Shimmer and the background sphere use bundled fragment shaders through Canvas. Shader programs are cached; each mounted surface owns and disposes its shader instance. A static placeholder remains visible while loading or if the shader is unavailable. Reduced motion leaves static content. Consumers do not need to declare package shaders or download graphics at runtime.

Continuous loaders, shimmer, Glow and indeterminate progress pause their tickers outside the visible viewport. Visibility changes are coalesced by visibility_detector; the package does not change its global update interval. Hidden-document, reduced-motion and explicit pause controls still apply.

## Sheets

`showWantSheet` keeps its builder, side and result contract. Bottom sheets use smooth_sheets with scroll/drag integration. Top, left and right use ForUI. All directions have an opaque themed surface, 24 px exposed corners, safe-area and keyboard handling. Closing a sheet restores the opening control's focus. `WantSheet` provides the title/content/actions composition; applications own navigation and return values.

## Files and dates

WantFileUpload uses system file dialogs and native drop handling, including virtual file streams. It accepts controlled XFile lists, consumer labels, extension/MIME filters and optional size/count limits. Validation rejects the whole incoming batch on an error. Cancelling the dialog keeps existing files. Dropped streams enforce the configured size limit while reading. Image previews above 10 MiB use an icon. Applications perform uploads.

Android currently requires Gradle 8 because the native drop dependency still uses Project.exec, removed in Gradle 9. Match the example: Gradle 8.14.3, Android Gradle Plugin 8.11.1 and Kotlin 2.2.20, with org.jetbrains.kotlin.android applied before the Flutter plugin.

The native drop dependency uses precompiled binaries or its documented Rust build integration. Android builds need an NDK. macOS sandboxed consumers need `com.apple.security.files.user-selected.read-only` for file selection; the example includes this entitlement. No drag-out or clipboard UI is added.

WantDateField accepts DateTime values in years 0001–9999. Date/time editing preserves calendar fields without implicit local/UTC conversion. onChanged reports edits; onCommit reports a changed confirmed value. Supply localized labels and the application-chosen today value when needed. The application owns conversion to server timestamps.

## Example and checks

From the repository root:

```sh
fvm install
fvm flutter pub get --directory packages/flutter
bun run flutter:check
bun run flutter:test
bun run flutter:consumer
bun run flutter:example
```

The example contains every component family with theme, RTL and motion controls. Find is opt-in: run with `--dart-define=WANT_ENABLE_FIND=true` to show its action and enable the shortcut. Interactive labels keep action cursors and click priority; dragging a selection from adjacent content can include their text. Continuous effects and indeterminate progress repaint within their own boundaries. Release checks run locally; published commits use `[skip ci]` to prevent paid Actions runs. macOS can build web, macOS, iOS simulator and Android; Linux/Windows and physical-device behavior need their own environments. Widget tests, rendered screenshots, platform builds and physical-device behavior are reported separately.

## License

MIT for the package source. Bundled fonts use the SIL Open Font License; complete texts are in licenses/. Dependencies and brand assets retain their own notices.

## Allure artwork

The package includes light/dark Allure logos and backgrounds alongside the existing Wallpapers asset:

```dart
WantBrandLogo.asset(
  'assets/brand/allure/logos/light/transparent.svg',
  package: 'want_allure',
  label: 'Want Allure',
)
```

Choose `logos/dark/transparent.svg` for a dark surface. Other supplied logo backgrounds and PNG variants retain their filenames. The background artwork is under `assets/brand/allure/backgrounds/brand-light.svg` and `brand-dark.svg`. Consumers choose the asset for their current theme; the public widget constructors are unchanged.

The repository's web catalogue supports twelve locales through the Astro application, including `/flutter/`, `/ru/flutter/` and the other localized routes. Its browser integration and translations belong to the example application. Installing the UI package does not add a router, stored preference or host-page integration to a consumer.

## Sliders, hover and lightning

`WantSlider` accepts `value`, `onChanged`, `label`, `min`, `max`, `step`, optional `onChangeEnd` and `formatValue`. `WantRangeSlider` uses the same numeric settings and a record such as `(start: 25.0, end: 75.0)`. A null callback disables the control. ForUI supplies native interaction, RTL, keyboard and localized range semantics.

`WantCard` has `hoverEffect: true` by default. Set it to false for a quiet reading surface. The moving highlight and soft shadow preserve layout and native pointer/selection behavior. Motion stops when inactive and respects reduced motion.

Use `Positioned.fill(child: WantLightningBackground(paused: paused))` inside a bounded Stack. Its optional `colors` list contains exactly two colors; otherwise it uses primary and warning. The shader is bundled with the package. Loading failures and reduced motion use a static fallback; high contrast hides the decoration. The caller owns the pause control.

`WantTableColumn.alignment` controls cell alignment and `sortLabel` provides a consumer-localized sort action name. Columns retain their minimum widths, expand proportionally on larger surfaces and scroll horizontally when necessary.

The example groups components into seven categories. Its shared web header owns theme, language and RTL. The standalone example retains equivalent native controls. `sprung` is used for restrained feedback curves; drag positions and numeric values update directly.


## Extruded SVG

`WantSvg3D` builds front, back and side faces from filled SVG contours and preserves holes. Use `.asset`, `.string` or `.builder`; the builder returns `FutureOr<String>`. Give the widget bounded constraints and a localized `semanticsLabel`.

```dart
SizedBox(
  width: 280,
  height: 280,
  child: WantSvg3D.asset(
    'assets/logo.svg',
    semanticsLabel: 'Product logo. Drag or use arrow keys to rotate.',
    depth: .12,
  ),
)
```

`depth` is a fraction of the longest SVG dimension, greater than zero and at most one. `autoRotate`, `paused` and `glow` control presentation. System reduced motion, viewport visibility and application lifecycle stop automatic movement. Rotation supports pointer dragging and arrow keys. Geometry is cached between frames; animation updates at most 30 times per second.

The initial SVG contract supports paths with solid hex fills, plain rectangles, polygons, circles, ellipses and group transforms. Convert text, strokes and rounded rectangles to filled paths before use. Flatten opacity before extrusion. Filters, masks, clipping, external resources and raster images are outside this mesh contract. Supply `placeholderBuilder` and `errorBuilder` when loading or failure needs product-specific content. When parsing cannot create a mesh, the original SVG is the default fallback if its source was loaded.

`WantThemeData.light(locale: ...)` and `.dark(locale: ...)` select the preferred bundled font fallback. Chinese, Hindi and Hebrew use Noto Sans SC, Noto Sans Devanagari and Noto Sans Hebrew.

## Table transitions

Pass a stable `rowKey` and a `transitionKey` representing the current page or sort state to animate incoming rows in sequence. Without `transitionKey`, rows render immediately. Reduced motion removes transitions. Header and body cells share alignment and padding; pagination stays mounted while rows change.
