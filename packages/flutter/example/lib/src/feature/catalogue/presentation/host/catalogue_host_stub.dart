import 'package:want_allure/want_allure.dart';
import 'package:want_allure_example/src/feature/catalogue/presentation/_barrel.dart';

class CatalogueHost {
  CatalogueHost({
    required void Function(
      String theme,
      String locale,
      String direction,
      String section,
    )
    onSettings,
  });
  String get theme => 'dark';
  String get locale => 'en';
  String get direction => 'ltr';
  WantBrandProfileV1? get profile => null;
  String? get component => null;
  String get section => 'foundation';
  CatalogueAppearance get appearance => defaultCatalogueAppearance;
  bool get embedded => false;
  void chooseTheme(String value, {bool system = false}) {}
  void chooseLocale(String value) {}
  void chooseDirection(String value) {}
  void chooseSection(String value) {}
  void ready() {}
  void dispose() {}
}
