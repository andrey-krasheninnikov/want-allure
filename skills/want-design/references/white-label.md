# Using a product brand

Use the Want defaults for a Want product. For an outside product, ask for its approved assets and read its existing tokens and writing guidelines. Keep its name, copy, logo, fonts and icon choices. Both modes share interaction and accessibility behavior.

The smallest profile is `{"schemaVersion":1}`. A brand can add its own seed and a few overrides:

```json
{
  "schemaVersion": 1,
  "brandColor": "#FFFFBB",
  "paletteStyle": "smooth",
  "radii": { "field": 8, "panel": 16, "action": 12 },
  "density": "compact",
  "surface": "soft",
  "fonts": { "body": "product-body", "ja": "product-ja" },
  "logos": { "light": "wordmark-dark", "dark": "wordmark-light" },
  "icons": { "success": "check" },
  "motion": "quiet"
}
```

Use the raw brand color for artwork. Use the resolved primary, foreground, focus and status roles on controls. A pale or very dark seed can yield different control colors in each mode. For a semantic override use `colors.light` or `colors.dark`. An invalid color pair reports the affected role. Validate the whole profile before replacing the current one. The schema exported at `@want-foundation/allure/brand-profile.schema.json` describes the accepted keys. The SDK also checks contrast.

Keep resource IDs in JSON. Resolve them in the application to local fonts, icons and asset paths. Register both logo variants when the artwork depends on the surface. Register script-specific fonts for the locales the product uses. Package a font license with any new font. Direction and locale belong to each rendering scope.

## React

```tsx
import '@want-foundation/allure/scoped.css';
import '@want-foundation/allure/fonts/manrope.css';
import { parseBrandProfile } from '@want-foundation/allure';
import { AllureProvider, Button } from '@want-foundation/allure-react';

const profile = parseBrandProfile({ schemaVersion: 1, brandColor: '#FFFFBB' });
export function Billing() {
  return <AllureProvider profile={profile} mode="light" locale="en" dir="ltr">
    <Button type="submit">Save billing address</Button>
  </AllureProvider>;
}
```

Use `scoped.css` for an embedded interface and `styles.css` for an application that owns its page styles. Scoped styles require browser support for CSS `@scope`. Give each independent interface its own provider. Provide `resources.fonts` as a map of CSS font families, `resources.icons` as glyph components and `resources.logos` as asset URLs. Register trusted assets in the application, and store their IDs in the profile. Supply an explicit mode on the server to keep the first client render consistent.

## Flutter

```dart
import 'package:flutter/widgets.dart';
import 'package:want_allure/want_allure.dart';

Widget billing(BuildContext context, Widget form) {
  final profile = WantBrandProfileV1.fromJson({
    'schemaVersion': 1,
    'brandColor': '#FFFFBB',
  });
  return WantTheme(
    data: WantThemeData.fromProfile(profile,
      brightness: MediaQuery.platformBrightnessOf(context),
      locale: Localizations.localeOf(context),
    ),
    child: form,
  );
}
```

Declare application fonts and logo assets in the host's pubspec. Pass the matching IDs to `WantBrandResources` when constructing the theme. Run the same saved profile through both renderers and check one form, one overlay, one dense table and an RTL locale.
