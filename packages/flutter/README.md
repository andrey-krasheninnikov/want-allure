# Want Desyst for Flutter

ForUI-based Want components for Android, iOS, web, macOS, Windows and Linux. The package shares the web UI kit's colors, geometry, typography, motion and component families.

## Install

Requires Flutter 3.47.7 and Dart 3.13.5 or newer.

```sh
flutter pub add want_desyst:^0.4.0
```

Use your existing application shell and localization setup. Apply WantTheme in the application builder so routes and overlays inherit the theme:

```dart
import 'package:flutter/widgets.dart';
import 'package:want_desyst/want_desyst.dart';

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

See the [component parity table](https://github.com/andrey-krasheninnikov/want-desyst/blob/v0.4.0/docs/flutter-parity.md) and [interactive example source](https://github.com/andrey-krasheninnikov/want-desyst/tree/v0.4.0/packages/flutter/example).

Components receive values, labels and callbacks. A null button callback disables interaction. WantCheckbox supports a controlled mixed state through indeterminate. Applications own routes, URLs launched by `onOpen`, data, persistence, time-zone conversion and uploads. The package adds no state-management framework or product services.

WantThemeData.light/dark provide the same primary #5962F0, success #7DF04A, info #28D7F5, warning #FFD43B and error #FF526D accents. Separate text roles preserve contrast. Override semantic values intentionally through the theme's overrides map. The source of truth remains the shared foundation JSON.

WantTypography provides display, h1–h6, lead, body, small, caption, label, overline, mono, code, codeBlock and quote. TTF fonts and their licenses are bundled; no font download occurs at runtime. The Wallpapers SVG remains available at `assets/brand/wallpapers.svg` in package `want_desyst`; products supply their own logo when appropriate.

## Feedback and motion

Wrap application content with WantToaster. Call showWantToast or showWantSnackbar from a descendant context with a title, localized close label and optional description/action. Snackbar variants are error, warning, info and success. Errors persist by default; other statuses last five seconds. Pass a duration to override or null to persist. Hover, keyboard focus, accessible navigation and inactive views pause timed dismissal.

WantLoader supports spinner, dots, bars and orbit. WantShimmer supports block, text, avatar and card. WantAnimatedText supports fade, slide and blur and retains only the current value. WantGlow decorates its child with a broad halo and two waves; leave space around the host for the waves.

Use paused for loops. WantTheme follows system reduced-motion settings; reduceMotion can explicitly override this for a preview. Reduced transparency keeps Glow visible and makes WantGlass opaque. High contrast hides decorative effects. Animation resources stop for inactive views and are disposed with the widget.

WantBackgroundMotion requires a caller-owned WantBackgroundController and localized pause/resume labels. Default wave delays are 8–18 seconds. pause, resume, toggle and triggerWave preserve the independent background phase. Dispose the controller when its owner ends. WantConfetti uses an integer trigger; increment it beside an action. WantWand is opt-in around an interactive control and preserves normal hit testing and pointers.

## Files and dates

WantFileUpload uses system file dialogs and native drop handling, including virtual file streams. It accepts controlled XFile lists, consumer labels, extension/MIME filters and optional size/count limits. Validation rejects the whole incoming batch on an error. Cancelling the dialog keeps existing files. Dropped streams enforce the configured size limit while reading. Image previews above 10 MiB use an icon. Applications perform uploads.

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

The example contains every component family with theme, RTL and motion controls. CI builds it for six targets. Widget tests, rendered screenshots, platform builds and physical-device behavior are reported separately.

## License

MIT for the package source. Bundled fonts use the SIL Open Font License; complete texts are in licenses/. Dependencies and brand assets retain their own notices.
