# AGENTS.md

## Agent skills

### Issue tracker

Issues live in GitHub Issues for `andrey-krasheninnikov/want-allure`.
See `docs/agents/issue-tracker.md`.

### Triage labels

Use the five default triage labels.
See `docs/agents/triage-labels.md`.

### Domain docs

Use a single-context glossary and ADR layout.
See `docs/agents/domain.md`.

### Want interfaces

For Want interface, component, and UI-copy work, use the repository skill at `skills/want-design/SKILL.md`.

### Flutter architecture

For work in `packages/flutter`, use `$flutter-project-template`, `$flutter-domain-error`, `$flutter-domain-layer`, `$flutter-application-layer` and `$flutter-barrel-imports`. Read their contracts before changing the relevant structure or behavior. Keep widgets and visual controllers in presentation, use strict root-layer barrel imports, and preserve the public package API. Add domain or application layers only for a real scenario; do not introduce empty layers or business dependencies into UI components.

## Implementation contracts

Use Bun 1.3.14 and the root scripts. Flutter uses the root FVM pin (3.47.7) and the Flutter scripts; use public ForUI primitives and derive Dart tokens from the canonical foundation JSON. Work from the issue-specific persistent worktree. Read GLOSSARY.md, DESIGN.md and relevant docs/adr before changes.

Keep foundation code independent of React and product services. React components use public props, semantic tokens and the installed Radix primitives. Never import wallpapers catalogue data, APIs, telemetry, advertising or routes into public packages. Consumers own persistence and localized copy.

Preserve the approved product theme, labels, keyboard behavior, RTL, 44 px targets and reduced-motion/transparency fallbacks. Do not add a visual redesign or decorative divider rules. Package exports, compiled CSS, assets, declarations and a separate consumer check form one contract.

After context compaction, fully re-read applicable instructions, every selected skill and its required references before continuing. Preserve the current review budget and successful checks when their inputs are unchanged.

## Unified web application

Use the root web commands for the complete Astro/React/Flutter application. The library build remains independent. Brand source files live in `assets/brand`; run `assets:sync` and verify `assets:check` when changing artwork. Keep catalogue localization and browser-host settings in the example applications. Do not initialize Flutter on landing or React routes.

Run checks locally. Do not use GitHub Actions for this repository's delivery. Published commits and merges include `[skip ci]`.
