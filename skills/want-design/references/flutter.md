# Flutter integration

Install the matching `want_allure` release from pub.dev. Import `package:want_allure/want_allure.dart`. Use the public `Want*` components and theme before adding wrappers or dependencies.

Wrap application content with `WantTheme(data: WantThemeData.light() or WantThemeData.dark(), child: ...)`. The adapter styles ForUI from the same foundation tokens. Product overrides belong in `WantThemeData` or an intentional product composition. Keep the application router and saved theme preference outside the package.

Use Flutter values and callbacks. Labels, error messages, dates for display, media, comment data and actions come from the consumer. URL controls call `onOpen` with a validated HTTP(S) URI; the application chooses routing or launching behavior. FileUpload selects and validates files without sending them to a service.

Include ForUI localization delegates in the application. Preserve Directionality, Semantics, keyboard focus and logical spacing. Controls retain at least 44 logical pixels for interaction. Allow TextScaler and long labels to reflow.

Use WantTypography for the 17 shared presets and WantProse for reading measures. Fonts are bundled TTF assets with package-qualified names; no runtime font download is required. Keep the product's chosen logo distinct from the supplied Wallpapers asset.

Place WantToaster around content that shows notifications. Use showWantToast or showWantSnackbar with consumer labels and at most one action. Error snackbars persist by default; null duration explicitly keeps any status visible.

Glow, shimmer, loaders and background motion respect pause, accessibility and inactive views. Keep persistent decorative motion optional and expose its pause control. Dispose caller-owned WantBackgroundController instances. Reduced transparency keeps Glow visible; reduced motion stops animation.

Use the package example and parity table when choosing a native composition equivalent for a web component. Native builders replace React-only trigger and portal parts. Verify the rendered flow in both themes, a narrow layout, RTL and enlarged text. Platform builds and widget tests do not establish physical-device behavior.

For web selection and application find, place `WantWebScope` inside `WantTheme` around the application builder's content. Supply `WantFindLabels`; the scope owns and disposes its find resources. Find is disabled by default; opt in with `enableFind: true`. With it disabled, search resources, keyboard interception and highlight painting are absent. Show an explicit action calling `WantWebScope.openFind(context)` only when `WantWebScope.findEnabledOf(context)` is true. Interactive labels keep click priority and action cursors while participating in a selection started from adjacent content. Only rendered content is discovered automatically; unbuilt lazy-list rows need data registration. Editable fields and passwords stay outside the find index. Browser-menu Find remains separate.

Use `WantIcons` and `WantIcon` for the shared Phosphor set. Notifications use toastification internally while preserving the public Want API. Bottom sheets use smooth_sheets; other directions use ForUI. Sheet surfaces are opaque and clip to the shared 24 px corners.

Shimmer and the background sphere use bundled Canvas fragment shaders with static loading/error fallbacks. Preserve their pause and accessibility behavior. Animated text uses a 360 ms transition and keeps only the latest value. Keep animation, selection and find controllers in presentation; they do not create a business domain or application layer.

Continuous loaders, shimmer, Glow and indeterminate progress pause their tickers outside the visible viewport. Visibility changes are coalesced by visibility_detector; the package does not change its global update interval. Hidden-document, reduced-motion and explicit pause controls still apply.

Use WantSlider and WantRangeSlider for controlled numeric input. Supply labels and value formatting; a null onChanged disables the control. WantCard offers an optional hover contour and shadow, with hoverEffect enabled by default. Keep non-action cards selectable and preserve the cursor of their contents. WantLightningBackground uses a bundled fragment shader and requires bounded constraints plus a caller-owned pause control. Its default colors are primary and warning. Use spring motion sparingly; input values must follow the pointer directly.

Flutter consumers may hide the background pause control with `showPauseControl: false`. `alternateWithLightning: true` switches effects every 30 seconds with a 1200 ms crossfade; `switchInterval` and `transitionDuration` configure that timing. Hidden effects pause, inactive applications retain their phase, reduced motion keeps a static sphere, and high contrast removes decoration. `WantDialog` accepts `constraints` and `showTitle: false`; the required title remains its accessible name.
