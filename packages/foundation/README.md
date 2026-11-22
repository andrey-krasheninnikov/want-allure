# @want-foundation/allure

Shared design tokens, compiled styles, local fonts and brand resources. Import @want-foundation/allure/styles.css and optionally @want-foundation/allure/fonts.css. Read tokens through @want-foundation/allure/tokens.json.

Browser effects are opt-in and return cleanup functions. Call burstConfetti with the clicked control; application events and downloads remain with the consumer.

See the repository README for usage, compatibility and release instructions.

## Appearance

Import `styles.css` and `fonts.css` to use the built-in theme and font presets. Apply the variables returned by `createThemeVariables({ theme: 'dark', primaryColor: '#29C38F', paletteStyle: 'neon' })` to the document root with the corresponding `data-theme`. Set `data-typography` to `brand`, `geometric`, `editorial`, `technical`, `humanist`, or `pixel`. The generator works during SSR and accepts `#RRGGBB` seeds with HSL saturation from 45% to 90% and lightness from 40% to 70%, inclusive. Use `isSupportedPrimaryColor` before passing user input. Palette styles adjust primary, field outlines and status colors. The seed hue also influences the four status colors within their semantic families. Use `*-text` for inline status copy, and put `*-foreground` on the matching `*-surface`. Status fills match across modes, while the inline text colors account for the active background.

## Embedded applications

Use `parseBrandProfile(json)` to validate a v1 profile, then `resolveBrandProfile(profile, mode)` to get semantic CSS variables and `colorScheme`. Import `scoped.css` and wrap the region with `AllureProvider` from the React adapter. Import a family such as `@want-foundation/allure/fonts/noto-sans-jp.css` for individual local font assets. The complete schema is exported at `@want-foundation/allure/brand-profile.schema.json`.

## Want design skill

Install the bundled brand, UI/UX, motion, composition, and product-voice skill from the target project's root:

```sh
npx --yes --package=@want-foundation/allure@1.4.0 want-design-install
```

The default destination is `.agents/skills/want-design`. Add `--global` for `~/.agents/skills/want-design`, or `--dest PATH` for another parent skills directory. Run `--check` to compare the bundle with its installed files. In 1.4.0, `--update` upgrades an unchanged managed installation while keeping extra files. An edited installation requires a manual review. See the [repository instructions](https://github.com/andrey-krasheninnikov/want-allure/tree/v1.4.0#want-design-skill) for invocation and updates.

## Allure artwork

Logo variants and backgrounds are exported below `@want-foundation/allure/assets/allure/`. For example, a Vite consumer can import `@want-foundation/allure/assets/allure/logos/light/transparent.svg?url`; use `logos/dark/transparent.svg` for a dark surface. `backgrounds/brand-light.svg` and `backgrounds/brand-dark.svg` supply the matching artwork. PNG variants use the same paths and `.png` suffix.

Choose the supplied variant for the surface, preserve proportions, and keep the brand color distinct from semantic action colors. `@want-foundation/allure/assets/wallpapers.svg` remains available.
