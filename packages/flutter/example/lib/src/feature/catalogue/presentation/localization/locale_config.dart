import 'package:flutter/widgets.dart';

const catalogueLocaleTags = [
  'en',
  'zh-Hans',
  'hi',
  'es',
  'ar',
  'fr',
  'pt-BR',
  'ru',
  'de',
  'ja',
  'tr',
  'he',
];
String catalogueLocaleTag(String? value) =>
    catalogueLocaleTags.contains(value) ? value! : 'en';
Locale catalogueLocale(String tag) {
  final parts = catalogueLocaleTag(tag).split('-');
  return Locale.fromSubtags(
    languageCode: parts.first,
    scriptCode: parts.length > 1 && parts[1].length == 4 ? parts[1] : null,
    countryCode: parts.length > 1 && parts[1].length == 2 ? parts[1] : null,
  );
}

const catalogueLocaleNames = {
  'en': 'English',
  'zh-Hans': '简体中文',
  'hi': 'हिन्दी',
  'es': 'Español',
  'ar': 'العربية',
  'fr': 'Français',
  'pt-BR': 'Português (Brasil)',
  'ru': 'Русский',
  'de': 'Deutsch',
  'ja': '日本語',
  'tr': 'Türkçe',
  'he': 'עברית',
};

String catalogueDirection(String tag) =>
    tag == 'ar' || tag == 'he' ? 'rtl' : 'ltr';

const catalogueLocaleFlags = {
  'en': '🇬🇧',
  'zh-Hans': '🇨🇳',
  'hi': '🇮🇳',
  'es': '🇪🇸',
  'ar': '🇸🇦',
  'fr': '🇫🇷',
  'pt-BR': '🇧🇷',
  'ru': '🇷🇺',
  'de': '🇩🇪',
  'ja': '🇯🇵',
  'tr': '🇹🇷',
  'he': '🇮🇱',
};
const catalogueSystemThemeTag = {
  'en': 'System theme',
  'zh-Hans': '系统主题',
  'hi': 'सिस्टम थीम',
  'es': 'Tema del sistema',
  'ar': 'سمة النظام',
  'fr': 'Thème système',
  'pt-BR': 'Tema do sistema',
  'ru': 'Системная тема',
  'de': 'Systemdesign',
  'ja': 'システムテーマ',
  'tr': 'Sistem teması',
  'he': 'ערכת נושא של המערכת',
};
