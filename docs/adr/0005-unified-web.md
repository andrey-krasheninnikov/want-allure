# 0005: One localized web application

Status: accepted.

The existing Astro showcase owns the public landing page and both framework catalogues. English uses the root URLs; Russian uses /ru/. React runs as an island on its catalogue route. Flutter runs in a same-origin iframe under /_flutter/ and initializes only when its catalogue is opened. Browser history may suspend and restore the catalogue document. Its lifecycle handlers preserve settings and readiness when that document returns.

The application shell owns the saved theme, system-theme subscription, navigation and language. It sends validated settings to the Flutter example without restarting the engine. Flutter reports readiness or startup failure. The host checks message origin and source, and exposes loading, retry and standalone recovery. The native example uses a platform stub and retains its controls. No host integration or translation dictionary is added to the public UI package API.

Landing pages for all twelve supported locales are prerendered semantic HTML. They have canonical URLs, reciprocal language alternatives, social metadata and factual project structured data. Catalogues and technical runtime pages are noindex,follow. Production canonical URLs use allure.want.foundation; actual hosting remains issue #20.

Brand originals are versioned in assets/brand. The root resource command mirrors logos and backgrounds into npm/Flutter package resources and prepares site artwork. Runtime mirrors are checked against source bytes. Existing Wallpapers resources and package imports remain compatible. Unrelated products retain their own identity.

The root library build stays independent of Flutter. The web build prepares one complete static artifact; development prepares Flutter once and provides an explicit rebuild command. Generated runtime files stay out of Git. Checks and publication run locally, with matching 1.2.0 packages and an immutable release tag. The main checkout and its live linked worktrees share the project's source-code directory; historical branches and contents are preserved.

Catalogue settings now include direction and category. The host validates origin, source and each value before applying settings. Category changes update same-document history and preserve the Flutter engine. The landing uses isolated React enhancements for the supplied logo, Glow, lightning, commands and FAQ; its main copy and metadata remain prerendered HTML.

The locale manifest orders English, simplified Chinese, Hindi, Spanish, Arabic, French, Brazilian Portuguese, Russian, German, Japanese, Turkish and Hebrew by total speaker population. Regional choices use the parent language for ranking, following [the total-speaker table](https://en.wikipedia.org/wiki/List_of_languages_by_total_number_of_speakers). Arabic and Hebrew default to RTL. Direction preferences are scoped to the current locale. React receives only its selected catalogue dictionary; Flutter example strings use ARB with regional fallback inputs. Runtime translation requests are absent.

The landing replaces separate framework, installation and FAQ sections with one reversible flow. The main SVG and framework logos are extruded locally. System reduced motion disables automatic movement, and offscreen or hidden content stops its effects.
