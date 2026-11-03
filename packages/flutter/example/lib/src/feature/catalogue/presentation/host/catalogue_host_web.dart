import 'dart:js_interop';

import 'package:web/web.dart' as web;
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
  String locale = Uri.base.queryParameters['locale'] == 'ru' ? 'ru' : 'en';
  String direction = Uri.base.queryParameters['direction'] == 'rtl'
      ? 'rtl'
      : 'ltr';
  String section = catalogueCategory(Uri.base.queryParameters['section']);
  final bool embedded = Uri.base.queryParameters['embedded'] == '1';
  CatalogueHost({required this.onSettings}) {
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
          (nextLocale != 'en' && nextLocale != 'ru') ||
          (nextDirection != 'ltr' && nextDirection != 'rtl') ||
          !catalogueCategories.contains(nextSection)) {
        return;
      }
      theme = nextTheme as String;
      locale = nextLocale as String;
      direction = nextDirection as String;
      section = nextSection as String;
      _apply();
    }).toJS;
    _history = ((web.Event event) {
      if (embedded) return;
      section = catalogueCategory(Uri.base.queryParameters['section']);
      _apply();
    }).toJS;
    web.window.addEventListener('message', _listener);
    web.window.addEventListener('popstate', _history);
  }
  void _apply() {
    web.document.documentElement?.setAttribute('data-theme', theme);
    web.document.documentElement?.setAttribute('lang', locale);
    web.document.documentElement?.setAttribute('dir', direction);
    web.document.body?.style.backgroundColor = theme == 'light'
        ? '#F6F5F3'
        : '#141414';
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

  void chooseTheme(String value) {
    theme = value;
    _send('want-allure:choose-theme', {'theme': value});
  }

  void chooseLocale(String value) {
    locale = value;
  }

  void chooseDirection(String value) {
    direction = value;
    _send('want-allure:choose-direction', {'direction': value});
  }

  void chooseSection(String value) {
    section = catalogueCategory(value);
    if (embedded) {
      _send('want-allure:choose-section', {'section': section});
    } else {
      final uri = Uri.base.replace(
        queryParameters: {...Uri.base.queryParameters, 'section': section},
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
