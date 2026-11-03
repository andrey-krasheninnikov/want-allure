import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialApp, Scaffold;
import 'package:want_allure/want_allure.dart';
import 'package:want_allure_example/src/feature/catalogue/presentation/_barrel.dart';

void main() => runApp(const WantCatalogue());

class WantCatalogue extends StatefulWidget {
  const WantCatalogue({super.key});
  @override
  State<WantCatalogue> createState() => _WantCatalogueState();
}

class _WantCatalogueState extends State<WantCatalogue> {
  late final CatalogueHost _host;
  String _category = 'foundation';
  Locale _locale = const Locale('en');
  CatalogueLocalizations get l => lookupCatalogueLocalizations(_locale);
  @override
  void initState() {
    super.initState();
    _host = CatalogueHost(
      onSettings: (theme, locale, direction, section) {
        if (!mounted) return;
        setState(() {
          _brightness = theme == 'light' ? Brightness.light : Brightness.dark;
          _locale = catalogueLocale(locale);
          _rtl = direction == 'rtl';
          _category = catalogueCategory(section);
        });
      },
    );
    _brightness = _host.theme == 'light' ? Brightness.light : Brightness.dark;
    _locale = catalogueLocale(_host.locale);
    _rtl = _host.direction == 'rtl';
    _category = _host.section;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _host.ready();
    });
  }

  @override
  void dispose() {
    _host.dispose();
    super.dispose();
  }

  Brightness _brightness = Brightness.dark;
  bool _rtl = false, _reduced = false, _opaque = false;
  @override
  Widget build(BuildContext context) {
    final theme = _brightness == Brightness.dark
        ? WantThemeData.dark(locale: _locale)
        : WantThemeData.light(locale: _locale);
    return MaterialApp(
      title: 'Want Allure · Flutter',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: [
        CatalogueLocalizations.delegate,
        ...FLocalizations.localizationsDelegates,
      ],
      supportedLocales: catalogueLocaleTags.map(catalogueLocale).toList(),
      builder: (context, child) => WantTheme(
        data: theme,
        reduceMotion: _reduced ? true : null,
        reduceTransparency: _opaque,
        child: WantDirectionProvider(
          direction: _rtl ? TextDirection.rtl : TextDirection.ltr,
          child: WantWebScope(
            enableFind: const bool.fromEnvironment('WANT_ENABLE_FIND'),
            labels: WantFindLabels(
              search: l.findInCatalogue,
              previous: l.previousMatch,
              next: l.nextMatch,
              close: l.closeFind,
              matchStatus: (active, count) => count == 0
                  ? l.noMatches
                  : l.matchActiveOfCount(active + 1, count),
            ),
            child: WantToaster(child: child!),
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          return ColoredBox(
            color: theme.color('background'),
            child: Scaffold(
              backgroundColor: const Color(0x00000000),
              body: SafeArea(
                child: _Gallery(
                  brightness: _brightness,
                  embedded: _host.embedded,
                  localeTag: _locale.toLanguageTag(),
                  onLocale: (tag) {
                    setState(() {
                      _locale = catalogueLocale(tag);
                      _rtl = catalogueDirection(tag) == 'rtl';
                    });
                    _host.chooseLocale(tag);
                  },
                  category: _category,
                  onCategory: (value) {
                    setState(() => _category = value);
                    _host.chooseSection(value);
                  },
                  rtl: _rtl,
                  reduced: _reduced,
                  opaque: _opaque,
                  onBrightness: (value) {
                    setState(() => _brightness = value);
                    _host.chooseTheme(
                      value == Brightness.light ? 'light' : 'dark',
                    );
                  },
                  onRtl: (value) {
                    setState(() => _rtl = value);
                    _host.chooseDirection(value ? 'rtl' : 'ltr');
                  },
                  onReduced: (value) => setState(() => _reduced = value),
                  onOpaque: (value) => setState(() => _opaque = value),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Gallery extends StatefulWidget {
  final String category;
  final ValueChanged<String> onCategory;
  final Brightness brightness;
  final bool rtl, reduced, opaque;
  final bool embedded;
  final ValueChanged<String> onLocale;
  final String localeTag;
  final ValueChanged<Brightness> onBrightness;
  final ValueChanged<bool> onRtl, onReduced, onOpaque;
  const _Gallery({
    required this.category,
    required this.onCategory,
    required this.brightness,
    required this.embedded,
    required this.onLocale,
    required this.localeTag,
    required this.rtl,
    required this.reduced,
    required this.opaque,
    required this.onBrightness,
    required this.onRtl,
    required this.onReduced,
    required this.onOpaque,
  });
  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  CatalogueLocalizations get l => CatalogueLocalizations.of(context);
  String _statusLabel(WantSnackbarVariant variant) => switch (variant) {
    WantSnackbarVariant.error => l.error,
    WantSnackbarVariant.warning => l.warning,
    WantSnackbarVariant.info => l.info,
    WantSnackbarVariant.success => l.success,
  };

  final _background = WantBackgroundController();
  final _visitedSections = <String>{};
  double _slider = 42;
  bool _ascending = true;
  ({double start, double end}) _range = (start: 25, end: 75);
  void _toggleEffects() {
    setState(() => _paused = !_paused);
    if (_paused) {
      _background.pause();
    } else {
      _background.resume();
    }
  }

  final _name = TextEditingController();
  bool _nameEdited = false, _updatingName = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_nameEdited && _name.text != l.violetHorizon) {
      _updatingName = true;
      _name.text = l.violetHorizon;
      _updatingName = false;
    }
  }

  final _url = TextEditingController(text: 'https://want.design');
  final _scroll = ScrollController();
  bool _checkbox = true,
      _switch = false,
      _paused = false,
      _mixed = true,
      _mixedValue = false;
  String? _select = 'desktop', _radio = 'desktop', _combo = 'violet';
  int _tab = 0, _page = 1, _pageSize = 10, _text = 0, _confetti = 0;
  DateTime? _date = DateTime(2026, 11, 2, 14, 30);
  List<XFile> _files = [];
  @override
  void dispose() {
    _background.dispose();
    _name.dispose();
    _url.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _message(String text) => showWantToast(
    context: context,
    title: Text(text),
    closeLabel: l.dismissMessage,
  );
  Widget _section(String id, String title, Widget child) {
    final active = catalogueSectionCategories[id] == widget.category;
    if (active) _visitedSections.add(id);
    if (!_visitedSections.contains(id)) return const SizedBox.shrink();
    return ExcludeFocus(
      excluding: !active,
      child: Offstage(
        offstage: !active,
        child: TickerMode(
          enabled: active,
          child: Padding(
            key: ValueKey(id),
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                WantTypography(title, variant: WantTypographyVariant.h2),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttons(List<Widget> children) => Wrap(
    spacing: 12,
    runSpacing: 12,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      for (final child in children)
        if (child is WantSwitch) SizedBox(width: 280, child: child) else child,
    ],
  );
  @override
  Widget build(BuildContext context) => RawScrollbar(
    controller: _scroll,
    child: SingleChildScrollView(
      controller: _scroll,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!widget.embedded)
                WantBrandLockup(
                  name: 'Want Allure',
                  subtitle: 'Flutter · ForUI · 1.3.0',
                  logo: WantBrandLogo.asset(
                    widget.brightness == Brightness.dark
                        ? 'assets/brand/allure/logos/dark/transparent.svg'
                        : 'assets/brand/allure/logos/light/transparent.svg',
                    package: 'want_allure',
                    label: 'Want Allure',
                  ),
                  onPressed: () => _scroll.animateTo(
                    0,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                  ),
                ),
              const SizedBox(height: 32),
              WantTypography(
                l.componentsInAction,
                variant: WantTypographyVariant.h1,
              ),
              const SizedBox(height: 16),
              WantProse(
                child: Text(l.theSameWantColorsControlsAndMotionAcrossWeb),
              ),
              const SizedBox(height: 24),
              _buttons([
                if (WantWebScope.findEnabledOf(context))
                  WantButton(
                    variant: WantButtonVariant.secondary,
                    onPressed: () => WantWebScope.openFind(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [WantIcon(WantIcons.search), Text(l.findCtrlF)],
                    ),
                  ),
                if (!widget.embedded)
                  SizedBox(
                    width: 200,
                    child: WantSelect<String>(
                      label: Text(l.changeLanguage),
                      value: widget.localeTag,
                      options: [
                        for (final tag in catalogueLocaleTags)
                          WantOption(
                            value: tag,
                            label: catalogueLocaleNames[tag]!,
                          ),
                      ],
                      onChanged: (tag) {
                        if (tag != null) widget.onLocale(tag);
                      },
                    ),
                  ),
                if (!widget.embedded)
                  WantSwitch(
                    value: widget.rtl,
                    onChanged: widget.onRtl,
                    label: const Text('RTL'),
                  ),
                WantSwitch(
                  value: widget.reduced,
                  onChanged: widget.onReduced,
                  label: Text(l.reduceMotion),
                ),
                WantSwitch(
                  value: widget.opaque,
                  onChanged: widget.onOpaque,
                  label: Text(l.opaqueSurfaces),
                ),
                WantButton(
                  variant: WantButtonVariant.secondary,
                  onPressed: _toggleEffects,
                  child: Text(_paused ? l.resumeEffects : l.pauseEffects),
                ),
              ]),
              const SizedBox(height: 32),
              WantTabs(
                value: catalogueCategories.indexOf(widget.category),
                onChanged: (index) =>
                    widget.onCategory(catalogueCategories[index]),
                tabs: [
                  for (final title in [
                    l.categoryFoundation,
                    l.categoryInputs,
                    l.categoryNavigation,
                    l.categoryData,
                    l.categoryFeedback,
                    l.categoryEffects,
                    l.categoryCompositions,
                  ])
                    WantTab(label: Text(title), child: const SizedBox.shrink()),
                ],
              ),
              const SizedBox(height: 28),
              _section(
                'sliders',
                l.sliders,
                WantFieldGroup(
                  children: [
                    WantSlider(
                      value: _slider,
                      onChanged: (value) => setState(() => _slider = value),
                      label: Text(l.intensity),
                      formatValue: (value) => '${value.round()}%',
                    ),
                    WantRangeSlider(
                      value: _range,
                      onChanged: (value) => setState(() => _range = value),
                      label: Text(l.range),
                    ),
                    WantSlider(
                      value: 60,
                      onChanged: null,
                      label: Text(l.disabledExample),
                    ),
                  ],
                ),
              ),
              _section(
                'background',
                l.pauseBackground,
                SizedBox(
                  height: 320,
                  child: WantBackgroundMotion(
                    controller: _background,
                    pauseLabel: l.pauseBackground,
                    resumeLabel: l.resumeBackground,
                    child: Center(
                      child: WantTypography(
                        l.lightAndSpace,
                        variant: WantTypographyVariant.h2,
                      ),
                    ),
                  ),
                ),
              ),
              _section(
                'lightning',
                l.backgroundLightning,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        height: 280,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            WantLightningBackground(paused: _paused),
                            Center(
                              child: WantTypography(
                                l.lightAndSpace,
                                variant: WantTypographyVariant.h2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    WantButton(
                      onPressed: _toggleEffects,
                      variant: WantButtonVariant.secondary,
                      child: Text(_paused ? l.resumeEffects : l.pauseEffects),
                    ),
                  ],
                ),
              ),
              _section(
                'svg3d',
                l.svg3D,
                SizedBox(
                  height: 320,
                  child: WantSvg3D.asset(
                    'assets/brand/allure/logos/dark/transparent.svg',
                    package: 'want_allure',
                    semanticsLabel: l.rotateLogo,
                    paused: _paused,
                  ),
                ),
              ),
              _section(
                'brand',
                l.brandAndTheme,
                WantFieldGroup(
                  children: [
                    WantBrandLockup(
                      name: 'Want Allure',
                      subtitle: l.componentPreview,
                      logo: WantBrandLogo.asset(
                        widget.brightness == Brightness.dark
                            ? 'assets/brand/allure/logos/dark/transparent.svg'
                            : 'assets/brand/allure/logos/light/transparent.svg',
                        package: 'want_allure',
                        label: 'Want Allure',
                      ),
                      onPressed: () => _scroll.animateTo(
                        0,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                      ),
                    ),
                    WantThemeToggle(
                      brightness: widget.brightness,
                      onChanged: widget.onBrightness,
                      lightLabel: l.useLightTheme,
                      darkLabel: l.useDarkTheme,
                    ),
                  ],
                ),
              ),
              _section(
                'palette',
                l.palette,
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final role in [
                      'primary',
                      'success',
                      'info',
                      'warning',
                      'error',
                    ])
                      Container(
                        width: 172,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: WantTheme.of(context).color(role),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 20,
                          children: [
                            Text(
                              role,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: WantTheme.of(context).color(
                                  role == 'primary'
                                      ? 'primary-foreground'
                                      : '$role-foreground',
                                ),
                              ),
                            ),
                            Text(
                              'Aa 123',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: WantTheme.of(context).color(
                                  role == 'primary'
                                      ? 'primary-foreground'
                                      : '$role-foreground',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              _section(
                'typography',
                l.typography,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    for (final variant in WantTypographyVariant.values)
                      WantTypography(
                        l.variantNameWantMakesRoomForYourContent(variant.name),
                        variant: variant,
                      ),
                    const WantTypography('日本語のインターフェース · واجهة واضحة'),
                  ],
                ),
              ),
              _section(
                'buttons',
                l.buttons,
                _buttons([
                  for (final variant in WantButtonVariant.values)
                    WantWand(
                      enabled: !_paused,
                      child: WantButton(
                        variant: variant,
                        onPressed: () =>
                            _message(l.variantNamePressed(variant.name)),
                        child: Text(variant.name),
                      ),
                    ),
                  for (final size in WantButtonSize.values)
                    WantButton(
                      size: size,
                      semanticsLabel: size.name,
                      onPressed: () => _message(size.name),
                      child: size.name.startsWith('icon')
                          ? const Icon(WantIcons.download)
                          : Text(size.name),
                    ),
                  WantButton(onPressed: null, child: Text(l.disabled)),
                  WantButton(
                    onPressed: () => _message(l.downloadSelected),
                    semanticsLabel: l.downloadExample,
                    size: WantButtonSize.icon,
                    child: const Icon(WantIcons.download),
                  ),
                ]),
              ),
              _section(
                'fields',
                l.fieldsInputAndTextarea,
                WantFieldGroup(
                  legend: Text(l.localExample),
                  children: [
                    WantInput(
                      controller: _name,
                      onChanged: (_) {
                        if (!_updatingName) _nameEdited = true;
                      },
                      label: Text(l.title),
                      description: Text(l.editableLocalValue),
                    ),
                    WantPasswordInput(
                      label: Text(l.password),
                      showPasswordLabel: l.showPassword,
                      hidePasswordLabel: l.hidePassword,
                    ),
                    WantInput(
                      label: Text(l.invalidExample),
                      error: Text(l.enterATitle),
                      initialValue: '',
                    ),
                    WantInput(
                      label: Text(l.disabledExample),
                      enabled: false,
                      initialValue: l.contoursOfSilence,
                    ),
                    WantTextarea(
                      label: Text(l.description),
                      hint: l.describeThePreview,
                    ),
                    WantField(
                      label: Text(l.fieldAndLabel),
                      description: Text(l.consumerOwnedHelperText),
                      child: WantInput(onChanged: (_) {}),
                    ),
                  ],
                ),
              ),
              _section(
                'selection',
                l.selectRadioCheckboxAndSwitch,
                WantFieldGroup(
                  children: [
                    WantSelect<String>(
                      value: _select,
                      label: Text(l.format),
                      options: [
                        WantOption(value: 'desktop', label: l.desktop),
                        WantOption(value: 'mobile', label: l.mobile),
                        WantOption(
                          value: 'disabled',
                          label: l.unavailable,
                          disabled: true,
                        ),
                      ],
                      onChanged: (value) => setState(() => _select = value),
                    ),
                    WantRadioGroup<String>(
                      value: _radio,
                      semanticsLabel: l.wallpaperOrientation,
                      options: [
                        WantOption(value: 'desktop', label: l.desktop),
                        WantOption(value: 'mobile', label: l.mobile),
                      ],
                      onChanged: (value) => setState(() => _radio = value),
                    ),
                    WantCheckbox(
                      value: _checkbox,
                      onChanged: (value) => setState(() => _checkbox = value),
                      label: Text(l.includePreview),
                      description: Text(l.aControlledCheckbox),
                    ),
                    WantCheckbox(
                      value: _mixedValue,
                      indeterminate: _mixed,
                      label: Text(l.mixedSelection),
                      onChanged: (value) => setState(() {
                        _mixed = false;
                        _mixedValue = value;
                      }),
                    ),
                    WantSwitch(
                      value: _switch,
                      onChanged: (value) => setState(() => _switch = value),
                      label: Text(l.enableExampleSetting),
                    ),
                    WantCheckbox(
                      value: false,
                      onChanged: null,
                      label: Text(l.disabledCheckbox),
                    ),
                  ],
                ),
              ),
              _section(
                'disclosure',
                l.tabsAndAccordion,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 24,
                  children: [
                    WantTabs(
                      value: _tab,
                      onChanged: (value) => setState(() => _tab = value),
                      tabs: [
                        WantTab(
                          label: Text(l.desktop),
                          child: Text(l.landscapePreview),
                        ),
                        WantTab(
                          label: Text(l.mobile),
                          child: Text(l.portraitPreview),
                        ),
                      ],
                    ),
                    WantAccordion(
                      items: [
                        WantAccordionItem(
                          title: Text(l.howAreComponentsShared),
                          child: Text(l.bothAdaptersUseTheSameFoundationTokens),
                        ),
                        WantAccordionItem(
                          title: Text(l.whoOwnsApplicationData),
                          child: Text(
                            l.theConsumingApplicationOwnsDataAndPersistence,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _section(
                'overlays',
                l.dialogSheetMenuTooltipAndPopover,
                _buttons([
                  WantButton(
                    onPressed: () => showWantDialog(
                      context: context,
                      builder: (context) => WantDialog(
                        title: l.previewSettings,
                        actions: WantButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l.done),
                        ),
                        child: WantInput(label: Text(l.previewName)),
                      ),
                    ),
                    child: Text(l.openDialog),
                  ),
                  for (final side in WantSheetSide.values)
                    WantButton(
                      variant: WantButtonVariant.secondary,
                      onPressed: () => showWantSheet(
                        context: context,
                        side: side,
                        builder: (context) => WantSheet(
                          title: l.panelSideName(side.name),
                          actions: WantButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(l.closePanel),
                          ),
                          child: Text(l.theSheetEntersFromItsSelectedSide),
                        ),
                      ),
                      child: Text(l.sideNameSheet(side.name)),
                    ),
                  WantDropdownMenu(
                    label: Text(l.actions),
                    items: [
                      WantMenuItem(
                        label: Text(l.copyLink),
                        onPressed: () => _message(l.copyActionSelected),
                      ),
                      WantMenuItem(label: Text(l.unavailable), disabled: true),
                    ],
                  ),
                  WantTooltip(
                    message: l.aKeyboardAndPointerHint,
                    child: WantButton(
                      variant: WantButtonVariant.secondary,
                      onPressed: () => _message(l.hintSelected),
                      child: Text(l.tooltip),
                    ),
                  ),
                  WantPopover(
                    child: Text(l.settings),
                    triggerBuilder: (context, toggle, child) => WantButton(
                      onPressed: toggle,
                      variant: WantButtonVariant.secondary,
                      child: child,
                    ),
                    contentBuilder: (context, close) => SizedBox(
                      width: 220,
                      child: WantFieldGroup(
                        children: [
                          WantInput(label: Text(l.note)),
                          WantButton(
                            onPressed: close,
                            child: Text(l.closeSettings),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              _section(
                'navigation',
                l.navigationAndBreadcrumbs,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    WantNavigationMenu(
                      semanticsLabel: l.exampleNavigation,
                      items: [
                        WantNavigationItem(
                          label: Text(l.collections),
                          current: true,
                          onPressed: () => _message(l.collectionsSelected),
                        ),
                        WantNavigationItem(
                          label: Text(l.search),
                          onPressed: () => _message(l.searchSelected),
                        ),
                      ],
                    ),
                    WantBreadcrumb(
                      semanticsLabel: l.breadcrumbs,
                      items: [
                        WantBreadcrumbItem(
                          label: Text(l.home),
                          onPressed: () => _message(l.homeSelected),
                        ),
                        WantBreadcrumbItem(label: Text(l.uiKit)),
                      ],
                    ),
                  ],
                ),
              ),
              _section(
                'feedback',
                l.badgesAlertsAndProgress,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    _buttons([
                      WantBadge(child: Text(l.primary)),
                      WantBadge(
                        variant: WantButtonVariant.secondary,
                        child: Text(l.desktop),
                      ),
                      WantBadge(
                        variant: WantButtonVariant.destructive,
                        child: Text(l.unavailable),
                      ),
                    ]),
                    WantAlert(
                      title: Text(l.previewAvailable),
                      description: Text(l.chooseAnExampleActionToContinue),
                    ),
                    WantAlert(
                      title: Text(l.couldNotLoadPreview),
                      description: Text(l.tryAgain),
                      destructive: true,
                    ),
                    WantProgress(label: l.exampleProgress, value: 64),
                    WantProgress(label: l.loadingPreview),
                    const WantSkeleton(height: 80),
                  ],
                ),
              ),
              _section(
                'notifications',
                l.toastAndSemanticSnackbars,
                _buttons([
                  WantButton(
                    onPressed: () => _message(l.localPreviewReady),
                    child: Text(l.showToast),
                  ),
                  for (final variant in WantSnackbarVariant.values)
                    WantButton(
                      variant: WantButtonVariant.secondary,
                      onPressed: () => showWantSnackbar(
                        context: context,
                        variant: variant,
                        variantLabel: _statusLabel(variant),
                        title: Text(
                          l.variantNameExampleStatus(_statusLabel(variant)),
                        ),
                        description: Text(
                          l.themeAwareFeedbackWithOneUsefulAction,
                        ),
                        closeLabel: l.dismissStatus,
                        actionLabel: l.viewDetails,
                        onAction: () => _message(l.detailsSelected),
                      ),
                      child: Text(_statusLabel(variant)),
                    ),
                ]),
              ),
              _section(
                'search',
                l.searchableCombobox,
                WantCombobox<String>(
                  value: _combo,
                  label: Text(l.collection),
                  emptyLabel: l.noMatches,
                  searchHint: l.searchCollections,
                  options: [
                    WantOption(value: 'violet', label: l.violetHorizon),
                    WantOption(value: 'woven', label: l.wovenSpectrum),
                    WantOption(
                      value: 'locked',
                      label: l.unavailable,
                      disabled: true,
                    ),
                  ],
                  onChanged: (value) => setState(() => _combo = value),
                ),
              ),
              _section(
                'table',
                l.tableAndPagination,
                WantTable<int>(
                  rowKey: (row) => row,
                  transitionKey: (_page, _pageSize, _ascending),
                  caption: l.localCollection,
                  emptyLabel: l.noRecords,
                  rows:
                      List.generate(
                        _pageSize,
                        (index) => (_page - 1) * _pageSize + index + 1,
                      ).where((value) => value <= 57).toList()..sort(
                        (a, b) => _ascending ? a.compareTo(b) : b.compareTo(a),
                      ),
                  columns: [
                    WantTableColumn(
                      label: l.name,
                      width: 320,
                      ascending: _ascending,
                      onSort: () => setState(() => _ascending = !_ascending),
                      cellBuilder: (value) => Text(l.previewValue(value)),
                    ),
                    WantTableColumn(
                      label: l.format,
                      cellBuilder: (_) => WantBadge(child: const Text('PNG')),
                    ),
                  ],
                  footer: WantPagination(
                    page: _page,
                    pageSize: _pageSize,
                    totalItems: 57,
                    onChanged: (page, size) => setState(() {
                      _page = page;
                      _pageSize = size;
                    }),
                    labels: WantPaginationLabels(
                      navigation: l.pages,
                      previous: l.previousPage,
                      next: l.nextPage,
                      pageSize: l.rowsPerPage,
                      page: (page) => l.pagePage(page),
                      results: (from, to, total) =>
                          l.fromToOfTotal(from, to, total),
                    ),
                  ),
                ),
              ),
              _section(
                'files',
                l.fileSelection,
                WantFileUpload(
                  files: _files,
                  onChanged: (files) => setState(() => _files = files),
                  label: Text(l.images),
                  extensions: const ['png', 'jpg', 'jpeg', 'webp'],
                  maxSize: 8 * 1024 * 1024,
                  maxFiles: 4,
                  labels: WantFileUploadLabels(
                    choose: l.chooseImages,
                    drop: l.dropImagesHereOrChooseAFile,
                    readFailed: l.couldNotReadTheSelectedFile,
                    remove: (name) => l.removeName(name),
                    invalidType: (name) => l.nameIsNotASupportedImage(name),
                    tooLarge: (name, limit) =>
                        l.nameExceedsLimitBytes(name, limit),
                    tooMany: (count) => l.chooseUpToCountFiles(count),
                  ),
                ),
              ),
              _section(
                'date-url-window',
                l.dateURLAndPageLayout,
                WantWindow(
                  title: l.createAPreview,
                  kicker: l.localComposition,
                  actions: WantButton(
                    onPressed: () => _message(l.previewActionSelected),
                    child: Text(l.preview),
                  ),
                  child: WantFieldGroup(
                    children: [
                      WantDateField(
                        value: _date,
                        onChanged: (value) => setState(() => _date = value),
                        label: Text(l.date),
                        mode: WantDateFieldMode.dateTime,
                        timeLabel: Text(l.time),
                        todayLabel: l.useToday,
                      ),
                      WantUrlField(
                        controller: _url,
                        label: Text(l.sourceURL),
                        openLabel: l.openSource,
                        onOpen: (uri) => _message(l.openUriHost(uri.host)),
                      ),
                    ],
                  ),
                ),
              ),
              _section(
                'cards',
                l.cardsMediaAndLiquidGlass,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 24,
                  children: [
                    WantMediaCard(
                      title: l.violetHorizon,
                      caption: l.localDemonstrationArtwork,
                      imageLabel: l.violetGradient,
                      index: 1,
                      onPressed: () => _message(l.previewSelected),
                      image: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF5962F0), Color(0xFF141414)],
                          ),
                        ),
                      ),
                    ),
                    WantCard(
                      title: Text(l.downloadPanel),
                      description: Text(l.aComposedCard),
                      child: Text(
                        l.publicSlotsKeepContentInTheConsumingApplication,
                      ),
                    ),
                    WantGlass(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          l.liquidGlassOpaqueWhenTransparencyIsReduced,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _section(
                'contact',
                l.contactCard,
                WantContactCard(
                  name: 'Want Studio',
                  subtitle: l.productDesign,
                  actions: [
                    WantContactAction(
                      title: l.website,
                      detail: 'want.design',
                      onPressed: () => _message(l.websiteSelected),
                    ),
                  ],
                ),
              ),
              _section(
                'comments',
                l.commentCarousel,
                WantCommentFeed(
                  labels: WantCommentFeedLabels(
                    title: l.comments,
                    empty: l.noComments,
                    previous: l.previousComments,
                    next: l.nextComments,
                    readMore: l.readMore,
                    collapse: l.collapse,
                  ),
                  comments: [
                    for (var index = 0; index < 4; index++)
                      WantComment(
                        id: '$index',
                        author: l.reviewerIndex(index + 1),
                        own: index == 0,
                        dateLabel: l.today,
                        text: index == 1
                            ? List.filled(
                                8,
                                l.readableCopyFollowsTheSameWantTypography,
                              ).join('\n')
                            : l.thePreviewIsReadyToExplore,
                        actions: [
                          WantCommentAction(id: 'reply', label: l.reply),
                        ],
                      ),
                  ],
                  onAction: (id, action) => _message(l.actionSelected(action)),
                ),
              ),
              _section(
                'loaders',
                l.customLoaders,
                _buttons([
                  for (final variant in WantLoaderVariant.values)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12,
                      children: [
                        WantLoader(
                          label: l.loadingVariantName(variant.name),
                          variant: variant,
                          paused: _paused,
                        ),
                        Text(variant.name),
                      ],
                    ),
                ]),
              ),
              _section(
                'shimmer',
                l.shimmerPlaceholders,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 24,
                  children: [
                    for (final variant in WantShimmerVariant.values)
                      WantShimmer(
                        label: l.loadingVariantName(variant.name),
                        variant: variant,
                        paused: _paused,
                      ),
                  ],
                ),
              ),
              _section(
                'animated-text',
                l.animatedText,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    for (final effect in WantTextEffect.values)
                      WantAnimatedText(
                        [
                          l.yourNextIdea,
                          l.madeWithWant,
                          l.readyToExplore,
                        ][_text % 3],
                        effect: effect,
                      ),
                    WantButton(
                      onPressed: () => setState(() => _text++),
                      child: Text(l.changeText),
                    ),
                  ],
                ),
              ),
              _section(
                'glow',
                l.reusableGlowAndConfetti,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 40,
                  children: [
                    WantGlow(
                      paused: _paused,
                      child: WantCard(
                        child: Text(l.aVisibleHaloWithTwoExpandingWaves),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: WantConfetti(
                        trigger: _confetti,
                        child: WantGlow(
                          paused: _paused,
                          borderRadius: BorderRadius.circular(100),
                          child: WantButton(
                            pill: true,
                            onPressed: () => setState(() => _confetti++),
                            child: Text(l.exploreWant),
                          ),
                        ),
                      ),
                    ),
                    WantButton(
                      variant: WantButtonVariant.secondary,
                      onPressed: _background.triggerWave,
                      child: Text(l.triggerBackgroundWave),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    ),
  );
}
