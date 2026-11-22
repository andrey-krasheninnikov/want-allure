# Brand and UI

## Identity and color

Want interfaces put the user's content first. Allure combines precise graphite/porcelain surfaces with a stepped light detail taken from its pixel feather. Use the approved artwork. Preserve the shape, proportions and colors of product logos. When the design explicitly calls for a tinted decorative mark, keep the approved shape and use the resolved accent. Allure's landing uses this treatment for the feather and framework marks.

The current shared theme uses these roles:

| Role | Dark | Light |
| --- | --- | --- |
| Canvas | #0D0D0F | #F7F7FA |
| Main text | #F0F0F2 | #1B1C24 |
| Card | #161618 | #FFFFFF |
| Popover and feedback | #262628 | #FFFFFF |
| Secondary surface | #222224 | #ECEEF4 |
| Muted text | #A6A6AB | #606371 |
| Field outline | #85858A | #7A7E90 |
| Focus ring | #A3A8FF | #5962F0 |
| Primary | #5962F0 | #5962F0 |
| Success | #39B986 | #39B986 |
| Info | #48A6D9 | #48A6D9 |
| Warning | #F0AF43 | #F0AF43 |
| Error | #E66A78 | #E66A78 |

Default status surfaces use #15161A ink. Custom palettes resolve readable ink from the status fill. The `*-text` roles supply readable colored copy on ordinary surfaces. The `*-foreground` roles are ink on the corresponding bright status surfaces. Do not interchange these roles. Ordinary text needs at least 4.5:1 contrast; meaningful icons and control states need 3:1. Pair status color with an icon, label, or explanatory copy.

Use primary for action fills and primary-foreground for their labels and icons. Use primary-edge for thin controls and outlines, primary-text for inline copy, and ring for keyboard focus. A vivid Neon seed can stay bright on a light canvas because the control edge supplies the contrast. Use semantic variables and component variants. Do not scatter raw brand hex values through product components or substitute a different palette because a generic design reference suggests it.

### Product themes

For a v1 brand profile, use the approved primary color as an opaque sRGB seed. Applications that call the legacy primary-color API must use its supported range. Validate editable colors before applying them. Show the resolved primary when it differs from the seed. Smooth uses sage, mist blue, sand and dusty rose. Contrast pairs jade and azure with amber and watermelon. Neon uses mint, cyan, apricot and hot pink. Acid pairs lime and turquoise with citron and vermilion. Resolve both light and dark modes through the SDK. Keep backgrounds graphite or porcelain. Let the SDK blend the style’s violet, warm and teal palettes for the chosen primary. For a teal brand, check that success is visibly greener than the main action. When contrast leaves little room to change a button’s lightness, its hover and pressed fills also change hue and saturation. If a seed needs adjustment, use the resolved colors. Verify ordinary text at 4.5:1 and meaningful outlines at 3:1.

## Typography

Days One is the display face at its available weight. Manrope is the body face. Use Noto Sans JP for Japanese and Noto Sans Arabic for Arabic. Serve the supplied font files locally; retain the fallback stacks and licenses.

Products can opt into Geometric (Unbounded × Manrope), Editorial (Literata × Manrope), Technical (IBM Plex Mono × IBM Plex Sans), Humanist (Atkinson Hyperlegible Next), or Pixel (Pixelify Sans × Manrope). Pixel stays in headings. Japanese and Russian display text use DotGothic16 with Pixel, simplified Chinese uses ZCOOL XiaoWei with Editorial, and Arabic uses Noto Kufi Arabic with Geometric. Keep the relevant Noto fallback and the license for every distributed font.

The scale contains display, h1 through h6, lead, body, small, caption, label, overline, mono, code, code-block, and quote. Use the token scale rather than making each screen's own headings. Match the HTML heading level to document structure, even when the visual variant differs.

Body text and inputs stay at least 16 px; supporting copy and labels stay at least 14 px. Keep reading text around 65 characters per line. Allow text wrapping, localization, and text enlargement. Use monospace and isolated LTR direction for technical values when needed, without forcing the whole interface into LTR.

## Geometry and composition

- Use the 4 px spacing rhythm. Start with content, relationships, and the primary action, then choose a layout that serves them.
- Use the canonical material highlight and shadow roles for depth. A small stepped highlight may mark an active surface; reading areas stay quiet. Fields use 12 px corners; panels and media use 24 px; prominent surfaces use 32 px; CTA buttons use capsule corners. Compact feedback islands use 18 px corners.
- Group with fills, spacing, and type. Outline variants remain filled. Do not draw decorative divider rules or wrap every piece of text in a card.
- Let reading surfaces stay opaque. Liquid glass is for suitable action surfaces: 68% neutral tint, 20 px blur, and 120% saturation. Reduced transparency, unsupported filtering, and forced colors use opaque surfaces.
- Use one clear primary action in each decision area. Keep secondary and destructive actions distinct. Destructive labels name what will be removed or changed.
- Preserve the 2 px focus outline with a 3 px offset. Focus remains visible without hover. Forced colors use system focus colors.

A marketing page may use an expressive content composition; a form or reading screen needs a quieter one. Do not impose a hero, a fixed number of cards, oversized headings, or decorative motion on every Want project.

## Controls and feedback

Reuse the project's controls before adding a new one. Interactive targets are at least 44 by 44 px, including icon-only actions. Provide names for icon buttons, labels for fields, associated helper/error text, and native keyboard behavior.

Use shared glyphs that match the active typography preset. Keep the meaning of status, navigation and control icons consistent when their shape or weight changes. Give icon-only controls a text label for assistive technology.

Theme pickers offer system, light and dark. Language pickers show an emoji flag and short code in the trigger and each language name in its own script in the menu. Keep localized labels and preference storage in the application.

Navigation chips and breadcrumbs center their content. Long labels wrap or reflow without losing targets or focus. Preserve logical ordering and logical spacing in RTL; mirror navigation arrows, not artwork or logos.

Toast and snackbar surfaces follow the light or dark theme. Status belongs in the 32 px icon plate, not across the entire message surface. Keep a clear title, optional useful detail, a 44 px close target, and at most one relevant action. Desktop actions sit beside the message; narrow layouts move them below. Errors stay until dismissal by default. Hover and keyboard focus pause timed notifications.

Tables use semantic foregrounds on opaque surfaces for headers, body cells and captions. Check text contrast against the actual hover and selected fills. Keep sort icons aligned with their column labels and give sort actions visible focus.

Choose loading feedback that matches the wait: a small Loader for a local operation, Shimmer or Skeleton for a known layout, and Progress when progress is measurable. Supply an accessible label. Do not leave a loading illustration after the state has resolved.

Empty states explain what belongs in the area and how to proceed. Errors explain the observed problem and an available recovery action. Do not imply data was lost, saved, uploaded, or retried without evidence.

Use the shared sidebar, split panes and search toolbar for workspaces. The compact rail is 56 px. Preserve adjacent pane minimums and keep saved proportions in the application. Pin icon actions to a stable 44 px target. Show confirmed copy feedback in place and keep failures beside their action.

## Responsive behavior

Keep the changed flow useful at 320 px as well as desktop. Reduce columns and reposition secondary actions before shrinking type or targets. Prevent page-wide horizontal overflow; use deliberate local scrolling for data or code that needs it. Do not crop labels or remove actions to make a screenshot fit.

Keep horizontal previews inside their own scroll region, with keyboard access and explicit previous and next controls. Reserve room for changing content in multi-step sections so focus and the page position stay stable.

Check text enlargement and long translated copy. Preserve keyboard order, headings, native form behavior, focus restoration, and announcements. Consumer code owns localized labels and prepared dates; rendering should not change their text between server and client.
