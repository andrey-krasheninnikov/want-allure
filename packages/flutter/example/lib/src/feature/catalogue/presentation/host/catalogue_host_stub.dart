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
  String get section => 'foundation';
  bool get embedded => false;
  void chooseTheme(String value) {}
  void chooseLocale(String value) {}
  void chooseDirection(String value) {}
  void chooseSection(String value) {}
  void ready() {}
  void dispose() {}
}
