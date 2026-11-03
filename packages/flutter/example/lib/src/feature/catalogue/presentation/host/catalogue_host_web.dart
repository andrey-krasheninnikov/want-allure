import 'dart:js_interop';

import 'package:web/web.dart' as web;

class CatalogueHost {
  final void Function(String theme, String locale) onSettings;
  late final JSFunction _listener;
  final String theme = Uri.base.queryParameters['theme'] == 'light'
      ? 'light'
      : 'dark';
  final String locale = Uri.base.queryParameters['locale'] == 'ru'
      ? 'ru'
      : 'en';
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
      if (data is! Map || data['type'] != 'want-allure:settings') {
        return;
      }
      final theme = data['theme'], locale = data['locale'];
      if ((theme == 'light' || theme == 'dark') &&
          (locale == 'en' || locale == 'ru')) {
        web.document.documentElement?.setAttribute(
          'data-theme',
          theme as String,
        );
        web.document.documentElement?.setAttribute('lang', locale as String);
        web.document.body?.style.backgroundColor = theme == 'light'
            ? '#F6F5F3'
            : '#141414';
        onSettings(theme, locale);
      }
    }).toJS;
    web.window.addEventListener('message', _listener);
  }
  void ready() {
    if (embedded) {
      web.window.parent?.postMessage(
        {'type': 'want-allure:ready'}.jsify(),
        web.window.location.origin.toJS,
      );
    }
  }

  void dispose() => web.window.removeEventListener('message', _listener);
}
