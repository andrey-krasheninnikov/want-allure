class CatalogueHost {
  CatalogueHost({
    required void Function(String theme, String locale) onSettings,
  });
  String get theme => 'dark';
  String get locale => 'en';
  bool get embedded => false;
  void ready() {}
  void dispose() {}
}
