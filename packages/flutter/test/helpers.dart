import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialApp, Scaffold;
import 'package:want_allure/want_allure.dart';
import 'package:visibility_detector/visibility_detector.dart';

Widget harness(
  Widget child, {
  Brightness brightness = Brightness.dark,
  bool? reduced = true,
  bool opaque = false,
  TextDirection direction = TextDirection.ltr,
  double textScale = 1,
  bool web = false,
  bool find = false,
}) {
  VisibilityDetectorController.instance.updateInterval = Duration.zero;
  return MaterialApp(
    localizationsDelegates: FLocalizations.localizationsDelegates,
    supportedLocales: FLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: WantTheme(
        data: brightness == Brightness.dark
            ? WantThemeData.dark()
            : WantThemeData.light(),
        reduceMotion: reduced,
        reduceTransparency: opaque,
        child: Directionality(
          textDirection: direction,
          child: WantWebScope(
            enabled: web,
            enableFind: find,
            labels: WantFindLabels(
              search: 'Find text',
              previous: 'Previous match',
              next: 'Next match',
              close: 'Close find',
              matchStatus: (index, count) =>
                  count == 0 ? 'No matches' : 'Match ${index + 1} of $count',
            ),
            child: WantToaster(child: child!),
          ),
        ),
      ),
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}

Future<void> loadWantFonts() async {
  final icons = FontLoader('packages/forui_lucide/ForuiLucideIcons')
    ..addFont(rootBundle.load('packages/forui_lucide/assets/lucide.ttf'));
  await icons.load();
  for (final style in ['Regular', 'Duotone']) {
    final loader = FontLoader('packages/phosphoricons_flutter/Phosphor$style')
      ..addFont(
        rootBundle.load(
          'packages/phosphoricons_flutter/lib/fonts/${style == 'Regular' ? 'Phosphor' : 'Phosphor-$style'}.ttf',
        ),
      );
    await loader.load();
  }
  for (final entry in {
    'Days One': 'DaysOne-Regular.ttf',
    'Manrope': 'Manrope.ttf',
    'Noto Sans JP': 'NotoSansJP.ttf',
    'Noto Sans Arabic': 'NotoSansArabic.ttf',
  }.entries) {
    final loader = FontLoader('packages/want_allure/${entry.key}')
      ..addFont(
        rootBundle.load('packages/want_allure/assets/fonts/${entry.value}'),
      );
    await loader.load();
  }
}
