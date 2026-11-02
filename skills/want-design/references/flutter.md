# Flutter integration

Install the matching `want_allure` release from pub.dev. Import `package:want_allure/want_allure.dart`. Use the public `Want*` components and theme before adding wrappers or dependencies.

Wrap application content with `WantTheme(data: WantThemeData.light() or WantThemeData.dark(), child: ...)`. The adapter styles ForUI from the same foundation tokens. Product overrides belong in `WantThemeData` or an intentional product composition. Keep the application router and saved theme preference outside the package.

Use Flutter values and callbacks. Labels, error messages, dates for display, media, comment data and actions come from the consumer. URL controls call `onOpen` with a validated HTTP(S) URI; the application chooses routing or launching behavior. FileUpload selects and validates files without sending them to a service.

Include ForUI localization delegates in the application. Preserve Directionality, Semantics, keyboard focus and logical spacing. Controls retain at least 44 logical pixels for interaction. Allow TextScaler and long labels to reflow.

Use WantTypography for the 17 shared presets and WantProse for reading measures. Fonts are bundled TTF assets with package-qualified names; no runtime font download is required. Keep the product's chosen logo distinct from the supplied Wallpapers asset.

Place WantToaster around content that shows notifications. Use showWantToast or showWantSnackbar with consumer labels and at most one action. Error snackbars persist by default; null duration explicitly keeps any status visible.

Glow, shimmer, loaders and background motion respect pause, accessibility and inactive views. Keep persistent decorative motion optional and expose its pause control. Dispose caller-owned WantBackgroundController instances. Reduced transparency keeps Glow visible; reduced motion stops animation.

Use the package example and parity table when choosing a native composition equivalent for a web component. Native builders replace React-only trigger and portal parts. Verify the rendered flow in both themes, a narrow layout, RTL and enlarged text. Platform builds and widget tests do not establish physical-device behavior.
