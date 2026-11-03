# Want Allure visual contract

The first product theme preserves the approved Want Wallpapers presentation. Shared primitives use semantic tokens, filled neutral surfaces and compact typography. The source of truth is packages/foundation/tokens.json.

Graphite background is #141414, main text #E8E8E8 and the primary action #5962F0. Light and dark palettes retain the source values. Preserve the original SVG logo separately from semantic action colors.

Days One is the display face and Manrope is the body face. Japanese uses Noto Sans JP, Arabic Noto Sans Arabic, simplified Chinese Noto Sans SC, Hindi Noto Sans Devanagari and Hebrew Noto Sans Hebrew. Fonts are local and optional through the fonts stylesheet. Body and inputs stay at least 16 px; labels stay at least 14 px. Controls retain 44 px touch targets.

Fields have 12 px corners, media and panels 24 px, prominent surfaces 32 px and CTA buttons capsule corners. Group content with fills, spacing and type. Outline variants remain filled; separators do not draw decorative rules. Focus retains the fill with a 2 px primary outline and 3 px offset. Forced colors use the system focus.

Liquid glass uses 68% neutral tint, 20 px blur and 120% saturation. Reading surfaces stay opaque. Reduced transparency, unsupported backdrop filtering and forced colors use opaque fills.

Component motion follows state changes: buttons compress on press, disclosure icons rotate, radio indicators appear, and tabs, accordions, dialogs, sheets and popovers animate on entry or exit. Use the existing 120 ms feedback and 180 ms transition tokens. Sheet movement follows its physical side; dialog centering and popover placement stay intact. Reduced motion removes these animations.

Card glow follows the source 2.6-second wave without tilt or movement. The wand follows active links and buttons, preserves selection and native cursors, and excludes ordinary text, editable fields and media. It emits at most three 12 px sparks with .45 peak opacity. Confetti lasts 800 ms and does not control downloads.

The background sphere is opt-in, with an explicit pause/resume control. It stops for hidden documents and reduced motion and disposes timers, observers and listeners. All decorative effects respect reduced motion, pointer capabilities and forced colors.

Use logical spacing, document direction and isolated technical text. Mirror navigation arrows in RTL, never artwork or logos. Keep the showcase useful at 320 px and demonstrate both themes, keyboard navigation and Arabic direction.

Typography has 17 presets backed by platform-neutral token values. Display headings keep Days One; body copy keeps Manrope, with the existing locale fonts. Body text remains at least 16 px and supporting text at least 14 px. The new scale is opt-in through Typography and Prose.

Feedback accents are identical in both themes: primary #5962F0, success #7DF04A, info #28D7F5, warning #FFD43B and error #FF526D. Status surfaces use those colors with #141414 ink. Separate text roles preserve readable inline status text on the light and dark canvas.

Toast and snackbar feedback form compact floating islands. The surface and copy follow the current theme; only the 32 px icon plate carries the status accent. Use an 18 px radius, a soft inset highlight and 44 px action targets. Desktop actions sit beside the message; narrow layouts move actions below it. Entry settles over 360 ms, the status icon follows over 420 ms, and exit takes 180 ms. Errors stay until dismissal unless the consumer supplies a duration.

Loaders, shimmer and Glow expose pause controls through their props. Glow combines a broad ambient halo with two expanding waves, staggered by 1.8 seconds over a 3.6-second cycle. Animate wave transforms and opacity; keep the blur and shadow geometry static. Text changes and snackbar entry and exit use short state animations. Reduced transparency preserves Glow and its waves. Reduced motion disables animated loops and transitions; forced colors keep functional indicators while hiding decorative glow.

The reusable Want interface skill lives in [skills/want-design/SKILL.md](skills/want-design/SKILL.md). Its references cover brand and UI, voice, motion, and React integration. Exact numeric values remain in the foundation tokens.

Consumers may set background wave-delay bounds and request a wave through want:background-shimmer on the background container. Manual requests restart only the light wave, preserve the other animation phases and respect the same pause and accessibility state.

Flutter uses logical pixels for the same geometry, ForUI for native control behavior, and `WantTheme` for semantic styling. Dart values derive from the canonical JSON. Fonts use TTF assets and package-qualified family names. Text, routes, uploads and persistence remain consumer-owned. See the Flutter parity document for native composition equivalents.

Flutter feedback uses toastification for scoped delivery and custom Want islands. Phosphor regular icons provide control glyphs; duotone icons identify status and file types. The existing Lucide export remains compatible. Bottom sheets use smooth_sheets; top and side panels retain ForUI. All sheet directions use an opaque popover surface with 24 logical-pixel exposed corners.

Flutter web text supports selection and an application find bar through WantWebScope, with localized labels supplied by the consumer. Find is opt-in through `enableFind: true`, disabled by default. Interactive labels keep click priority and action cursors while participating in adjacent text selection. Continuous effects and indeterminate progress use repaint boundaries. The find bar follows Want surfaces, keyboard behavior and logical direction. Shader shimmer and the background sphere use Canvas fragment programs, with static fallbacks. Flutter text replacement settles over 360 ms with a short slide or blur and no outgoing text queue.

The Allure landing stages an extrusion of the supplied dark transparent pixel feather SVG. Preserve its stepped front silhouette and holes. The local renderer rotates the object horizontally with smoothly varying speed and keeps the original SVG fallback. Automatic rotation stops for reduced motion and hidden surfaces. Header preferences reuse the Wallpapers theme switch and language Select in a sticky glass island. One header RTL switch controls the whole catalogue.

Catalogue examples use seven shared categories. Visited form values survive category switches; inactive panels stop their effects. Framework actions use recognizable React/Flutter silhouettes in Want colors and the public Glow. Landing lightning uses primary and warning without a full-screen flash. Flutter lightning uses a bounded fragment shader surface with static fallback and viewport/lifecycle pauses.

Flutter card hover may add the explicitly requested animated contour and soft shadow, without moving the card or changing its cursor. Disable it with hoverEffect for quiet surfaces. Tables use rounded filled surfaces, aligned cells and clear sort actions. Slider values follow input directly; spring curves are reserved for accent feedback and settling. FAQ disclosure takes 280 ms to open and 220 ms to close, with reduced-motion fallbacks.

The landing uses one guided sequence: framework selection, installation, then a horizontal FAQ and tips carousel. Framework cards orbit with their own 3D logos and stop for hover or keyboard focus. Hovering a headline grapheme reveals a soft halo that cycles through primary, info, warning, error and success over eight seconds. Text uses the readable color roles; Arabic and Indic shaping remain intact. The fixed, bounded effect does not extend the page width and clears on scroll, resize or hidden documents.

Flutter SVG extrusion preserves front, back, side faces and holes. Toast status plates and message blocks share their top edge; minimal status glyphs fade and settle on entry. Table rows enter in sequence when the consumer changes transitionKey, with stable row identity and reduced-motion support.

Flutter password fields use WantPasswordInput with a labelled 44 px show/hide action. Initial content is concealed. Visibility changes preserve value and selection; input-assistance and autofill defaults remain disabled in both states. Consumers supply localized labels, validation and clipboard policy.

Flutter consumers may set `showPauseControl: false` when the product omits that control. Reduced-motion and inactive-view suspension still apply. `WantDialog` supports consumer constraints and `showTitle: false`; its required title remains the accessible name.
