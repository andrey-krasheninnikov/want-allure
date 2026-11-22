import 'dart:js_interop';

import 'package:web/web.dart' as web;
import 'package:want_allure/want_allure.dart';
import 'package:want_allure_example/src/feature/catalogue/presentation/_barrel.dart';

class CatalogueHost {
  final void Function(
    String theme,
    String locale,
    String direction,
    String section,
  )
  onSettings;
  late final JSFunction _listener, _history;
  String theme = Uri.base.queryParameters['theme'] == 'light'
      ? 'light'
      : 'dark';
  bool _systemTheme = Uri.base.queryParameters['theme'] == 'system';
  String locale = catalogueLocaleTag(Uri.base.queryParameters['locale']);
  String direction =
      ['ltr', 'rtl'].contains(Uri.base.queryParameters['direction'])
      ? Uri.base.queryParameters['direction']!
      : catalogueDirection(
          catalogueLocaleTag(Uri.base.queryParameters['locale']),
        );
  WantBrandProfileV1? profile;
  String? component = Uri.base.queryParameters['component'];
  String section = catalogueCategory(Uri.base.queryParameters['section']);
  CatalogueAppearance appearance = catalogueAppearance(
    Uri.base.queryParameters,
    defaultCatalogueAppearance,
  );
  final bool embedded = Uri.base.queryParameters['embedded'] == '1';
  CatalogueHost({required this.onSettings}) {
    section =
        catalogueSectionCategories[catalogueComponentSections[component]] ??
        section;
    _listener = ((web.Event event) {
      final message = event as web.MessageEvent;
      if (!embedded ||
          message.origin != web.window.location.origin ||
          message.source != web.window.parent) {
        return;
      }
      final data = message.data.dartify();
      if (data is! Map || data['type'] != 'want-allure:settings') return;
      final nextTheme = data['theme'], nextLocale = data['locale'];
      final nextDirection = data['direction'] ?? direction,
          nextSection = data['section'] ?? section;
      if ((nextTheme != 'light' && nextTheme != 'dark') ||
          !catalogueLocaleTags.contains(nextLocale) ||
          (nextDirection != 'ltr' && nextDirection != 'rtl') ||
          !catalogueCategories.contains(nextSection)) {
        return;
      }
      if (data.containsKey('profile')) {
        final raw = data['profile'];
        if (raw == null) {
          profile = null;
        } else if (raw is Map) {
          try {
            profile = WantBrandProfileV1.fromJson(raw);
          } on FormatException {
            return;
          }
        } else {
          return;
        }
      }
      final anchor = data['component'];
      component = anchor is String ? anchor : null;
      theme = nextTheme as String;
      locale = nextLocale as String;
      direction = nextDirection as String;
      section =
          catalogueSectionCategories[catalogueComponentSections[component]] ??
          nextSection as String;
      appearance = catalogueAppearance(data, appearance);
      _apply();
    }).toJS;
    _history = ((web.Event event) {
      if (embedded) return;
      component = Uri.base.queryParameters['component'];
      section =
          catalogueSectionCategories[catalogueComponentSections[component]] ??
          catalogueCategory(Uri.base.queryParameters['section']);
      _apply();
    }).toJS;
    web.window.addEventListener('message', _listener);
    web.window.addEventListener('popstate', _history);
  }
  void _apply() {
    if (!embedded) {
      final uri = Uri.base.replace(
        queryParameters: {
          ...Uri.base.queryParameters,
          'locale': locale,
          'theme': _systemTheme ? 'system' : theme,
          'direction': direction,
        },
      );
      web.window.history.replaceState(null, '', uri.toString());
    }
    web.document.documentElement?.setAttribute('data-theme', theme);
    web.document
        .querySelector('link[rel="icon"]')
        ?.setAttribute('href', 'favicon/$theme/favicon-512.svg');
    web.document
        .querySelector('link[rel="apple-touch-icon"]')
        ?.setAttribute('href', 'favicon/$theme/apple-touch-icon.png');
    web.document.documentElement?.setAttribute('lang', locale);
    web.document.documentElement?.setAttribute('dir', direction);
    web.document.documentElement?.setAttribute(
      'data-palette-style',
      profile?.paletteStyle.name ?? appearance.paletteStyle.name,
    );
    web.document.documentElement?.setAttribute(
      'data-typography',
      profile?.typographyPreset.name ?? appearance.typographyPreset.name,
    );
    final defaults = theme == 'light' ? WantTokens.light : WantTokens.dark;
    final seed = profile == null
        ? appearance.primaryColor
        : profile!.brandColor ?? defaults['primary']!;
    if (seed == null) {
      web.document.documentElement?.removeAttribute('data-primary-color');
    } else {
      web.document.documentElement?.setAttribute(
        'data-primary-color',
        '#${(seed.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}',
      );
    }
    final overrideColors = theme == 'light' ? profile?.light : profile?.dark;
    final background =
        overrideColors?['background'] ??
        defaults['background']!;
    web.document.body?.style.backgroundColor =
        '#${(background.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
    onSettings(theme, locale, direction, section);
  }

  void _send(String type, Map<String, String> values) {
    if (embedded) {
      web.window.parent?.postMessage(
        {'type': type, ...values}.jsify(),
        web.window.location.origin.toJS,
      );
    }
  }

  void chooseTheme(String value, {bool system = false}) {
    _systemTheme = system;
    theme = value;
    _apply();
    _send('want-allure:choose-theme', {'theme': value});
  }

  void chooseLocale(String value) {
    locale = catalogueLocaleTag(value);
    direction = catalogueDirection(locale);
    _apply();
  }

  void chooseDirection(String value) {
    direction = value;
    _apply();
    _send('want-allure:choose-direction', {'direction': value});
  }

  void chooseSection(String value) {
    section = catalogueCategory(value);
    component = null;
    if (embedded) {
      _send('want-allure:choose-section', {'section': section});
    } else {
      final uri = Uri.base.replace(
        queryParameters: {...Uri.base.queryParameters, 'section': section}
          ..remove('component'),
      );
      web.window.history.pushState(null, '', uri.toString());
    }
  }

  void ready() => _send('want-allure:ready', {});
  void dispose() {
    web.window.removeEventListener('message', _listener);
    web.window.removeEventListener('popstate', _history);
  }
}
