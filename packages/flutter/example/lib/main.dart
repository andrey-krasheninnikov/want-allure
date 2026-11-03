import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show MaterialApp, Scaffold;
import 'package:want_allure/want_allure.dart';

void main() => runApp(const WantCatalogue());

class WantCatalogue extends StatefulWidget {
  const WantCatalogue({super.key});
  @override
  State<WantCatalogue> createState() => _WantCatalogueState();
}

class _WantCatalogueState extends State<WantCatalogue> {
  Brightness _brightness = Brightness.dark;
  bool _rtl = false, _reduced = false, _opaque = false;
  @override
  Widget build(BuildContext context) {
    final theme = _brightness == Brightness.dark
        ? WantThemeData.dark()
        : WantThemeData.light();
    return MaterialApp(
      title: 'Want Allure · Flutter',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: FLocalizations.localizationsDelegates,
      supportedLocales: FLocalizations.supportedLocales,
      builder: (context, child) => WantTheme(
        data: theme,
        reduceMotion: _reduced ? true : null,
        reduceTransparency: _opaque,
        child: WantDirectionProvider(
          direction: _rtl ? TextDirection.rtl : TextDirection.ltr,
          child: WantWebScope(
            enableFind: const bool.fromEnvironment('WANT_ENABLE_FIND'),
            labels: WantFindLabels(
              search: 'Find in catalogue',
              previous: 'Previous match',
              next: 'Next match',
              close: 'Close find',
              matchStatus: (active, count) =>
                  count == 0 ? 'No matches' : 'Match ${active + 1} of $count',
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
                  rtl: _rtl,
                  reduced: _reduced,
                  opaque: _opaque,
                  onBrightness: (value) => setState(() => _brightness = value),
                  onRtl: (value) => setState(() => _rtl = value),
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
  final Brightness brightness;
  final bool rtl, reduced, opaque;
  final ValueChanged<Brightness> onBrightness;
  final ValueChanged<bool> onRtl, onReduced, onOpaque;
  const _Gallery({
    required this.brightness,
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
  final _background = WantBackgroundController();
  final _name = TextEditingController(text: 'Violet Horizon');
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
    closeLabel: 'Dismiss message',
  );
  Widget _section(String id, String title, Widget child) => Padding(
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
  );
  Widget _buttons(List<Widget> children) => Wrap(
    spacing: 12,
    runSpacing: 12,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: children,
  );
  @override
  Widget build(BuildContext context) => WantBackgroundMotion(
    controller: _background,
    pauseLabel: 'Pause background',
    resumeLabel: 'Resume background',
    child: RawScrollbar(
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
                WantBrandLockup(
                  name: 'Want Allure',
                  subtitle: 'Flutter · ForUI · 1.1.0',
                  logo: WantBrandLogo.asset(
                    'assets/brand/wallpapers.svg',
                    package: 'want_allure',
                    label: 'Want Wallpapers',
                  ),
                  onPressed: () => _scroll.animateTo(
                    0,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                  ),
                ),
                const SizedBox(height: 32),
                const WantTypography(
                  'One Want. Every platform.',
                  variant: WantTypographyVariant.display,
                ),
                const SizedBox(height: 16),
                const WantProse(
                  child: Text(
                    'The same Want colors, controls and motion across web and Flutter. Explore components with keyboard, touch and pointer input.',
                  ),
                ),
                const SizedBox(height: 24),
                _buttons([
                  if (WantWebScope.findEnabledOf(context))
                    WantButton(
                      variant: WantButtonVariant.secondary,
                      onPressed: () => WantWebScope.openFind(context),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          WantIcon(WantIcons.search),
                          Text('Find · ⌘/Ctrl F'),
                        ],
                      ),
                    ),
                  WantThemeToggle(
                    brightness: widget.brightness,
                    onChanged: widget.onBrightness,
                    lightLabel: 'Use light theme',
                    darkLabel: 'Use dark theme',
                  ),
                  WantSwitch(
                    value: widget.rtl,
                    onChanged: widget.onRtl,
                    label: const Text('RTL'),
                  ),
                  WantSwitch(
                    value: widget.reduced,
                    onChanged: widget.onReduced,
                    label: const Text('Reduce motion'),
                  ),
                  WantSwitch(
                    value: widget.opaque,
                    onChanged: widget.onOpaque,
                    label: const Text('Opaque surfaces'),
                  ),
                  WantButton(
                    variant: WantButtonVariant.secondary,
                    onPressed: () => setState(() => _paused = !_paused),
                    child: Text(_paused ? 'Resume effects' : 'Pause effects'),
                  ),
                ]),
                const WantSeparator(space: 40),
                _section(
                  'palette',
                  'Palette',
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
                  'Typography',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: [
                      for (final variant in WantTypographyVariant.values)
                        WantTypography(
                          '${variant.name} · Want makes room for your content.',
                          variant: variant,
                        ),
                      const WantTypography('日本語のインターフェース · واجهة واضحة'),
                    ],
                  ),
                ),
                _section(
                  'buttons',
                  'Buttons',
                  _buttons([
                    for (final variant in WantButtonVariant.values)
                      WantWand(
                        enabled: !_paused,
                        child: WantButton(
                          variant: variant,
                          onPressed: () => _message('${variant.name} pressed'),
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
                    const WantButton(onPressed: null, child: Text('Disabled')),
                    WantButton(
                      onPressed: () => _message('Download selected'),
                      semanticsLabel: 'Download example',
                      size: WantButtonSize.icon,
                      child: const Icon(WantIcons.download),
                    ),
                  ]),
                ),
                _section(
                  'fields',
                  'Fields, input and textarea',
                  WantFieldGroup(
                    legend: const Text('Local example'),
                    children: [
                      WantInput(
                        controller: _name,
                        label: const Text('Title'),
                        description: const Text('Editable local value.'),
                      ),
                      const WantInput(
                        label: Text('Invalid example'),
                        error: Text('Enter a title.'),
                        initialValue: '',
                      ),
                      const WantInput(
                        label: Text('Disabled example'),
                        enabled: false,
                        initialValue: 'Contours of Silence',
                      ),
                      const WantTextarea(
                        label: Text('Description'),
                        hint: 'Describe the preview',
                      ),
                      WantField(
                        label: const Text('Field and label'),
                        description: const Text('Consumer-owned helper text.'),
                        child: WantInput(onChanged: (_) {}),
                      ),
                    ],
                  ),
                ),
                _section(
                  'selection',
                  'Select, radio, checkbox and switch',
                  WantFieldGroup(
                    children: [
                      WantSelect<String>(
                        value: _select,
                        label: const Text('Format'),
                        options: const [
                          WantOption(value: 'desktop', label: 'Desktop'),
                          WantOption(value: 'mobile', label: 'Mobile'),
                          WantOption(
                            value: 'disabled',
                            label: 'Unavailable',
                            disabled: true,
                          ),
                        ],
                        onChanged: (value) => setState(() => _select = value),
                      ),
                      WantRadioGroup<String>(
                        value: _radio,
                        semanticsLabel: 'Wallpaper orientation',
                        options: const [
                          WantOption(value: 'desktop', label: 'Desktop'),
                          WantOption(value: 'mobile', label: 'Mobile'),
                        ],
                        onChanged: (value) => setState(() => _radio = value),
                      ),
                      WantCheckbox(
                        value: _checkbox,
                        onChanged: (value) => setState(() => _checkbox = value),
                        label: const Text('Include preview'),
                        description: const Text('A controlled checkbox.'),
                      ),
                      WantCheckbox(
                        value: _mixedValue,
                        indeterminate: _mixed,
                        label: const Text('Mixed selection'),
                        onChanged: (value) => setState(() {
                          _mixed = false;
                          _mixedValue = value;
                        }),
                      ),
                      WantSwitch(
                        value: _switch,
                        onChanged: (value) => setState(() => _switch = value),
                        label: const Text('Enable example setting'),
                      ),
                      const WantCheckbox(
                        value: false,
                        onChanged: null,
                        label: Text('Disabled checkbox'),
                      ),
                    ],
                  ),
                ),
                _section(
                  'disclosure',
                  'Tabs and accordion',
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 24,
                    children: [
                      WantTabs(
                        value: _tab,
                        onChanged: (value) => setState(() => _tab = value),
                        tabs: const [
                          WantTab(
                            label: Text('Desktop'),
                            child: Text('Landscape preview.'),
                          ),
                          WantTab(
                            label: Text('Mobile'),
                            child: Text('Portrait preview.'),
                          ),
                        ],
                      ),
                      const WantAccordion(
                        items: [
                          WantAccordionItem(
                            title: Text('How are components shared?'),
                            child: Text(
                              'Both adapters use the same foundation tokens.',
                            ),
                          ),
                          WantAccordionItem(
                            title: Text('Who owns application data?'),
                            child: Text(
                              'The consuming application owns data and persistence.',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _section(
                  'overlays',
                  'Dialog, sheet, menu, tooltip and popover',
                  _buttons([
                    WantButton(
                      onPressed: () => showWantDialog(
                        context: context,
                        builder: (context) => WantDialog(
                          title: 'Preview settings',
                          actions: WantButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Done'),
                          ),
                          child: const WantInput(label: Text('Preview name')),
                        ),
                      ),
                      child: const Text('Open dialog'),
                    ),
                    for (final side in WantSheetSide.values)
                      WantButton(
                        variant: WantButtonVariant.secondary,
                        onPressed: () => showWantSheet(
                          context: context,
                          side: side,
                          builder: (context) => WantSheet(
                            title: 'Panel ${side.name}',
                            actions: WantButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close panel'),
                            ),
                            child: const Text(
                              'The sheet enters from its selected side.',
                            ),
                          ),
                        ),
                        child: Text('${side.name} sheet'),
                      ),
                    WantDropdownMenu(
                      label: const Text('Actions'),
                      items: [
                        WantMenuItem(
                          label: const Text('Copy link'),
                          onPressed: () => _message('Copy action selected'),
                        ),
                        const WantMenuItem(
                          label: Text('Unavailable'),
                          disabled: true,
                        ),
                      ],
                    ),
                    WantTooltip(
                      message: 'A keyboard and pointer hint',
                      child: WantButton(
                        variant: WantButtonVariant.secondary,
                        onPressed: () => _message('Hint selected'),
                        child: const Text('Tooltip'),
                      ),
                    ),
                    WantPopover(
                      child: const Text('Settings'),
                      triggerBuilder: (context, toggle, child) => WantButton(
                        onPressed: toggle,
                        variant: WantButtonVariant.secondary,
                        child: child,
                      ),
                      contentBuilder: (context, close) => SizedBox(
                        width: 220,
                        child: WantFieldGroup(
                          children: [
                            const WantInput(label: Text('Note')),
                            WantButton(
                              onPressed: close,
                              child: const Text('Close settings'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                _section(
                  'navigation',
                  'Navigation and breadcrumbs',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 20,
                    children: [
                      WantNavigationMenu(
                        semanticsLabel: 'Example navigation',
                        items: [
                          WantNavigationItem(
                            label: const Text('Collections'),
                            current: true,
                            onPressed: () => _message('Collections selected'),
                          ),
                          WantNavigationItem(
                            label: const Text('Search'),
                            onPressed: () => _message('Search selected'),
                          ),
                        ],
                      ),
                      WantBreadcrumb(
                        semanticsLabel: 'Breadcrumbs',
                        items: [
                          WantBreadcrumbItem(
                            label: const Text('Home'),
                            onPressed: () => _message('Home selected'),
                          ),
                          const WantBreadcrumbItem(label: Text('UI kit')),
                        ],
                      ),
                    ],
                  ),
                ),
                _section(
                  'feedback',
                  'Badges, alerts and progress',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: [
                      _buttons([
                        const WantBadge(child: Text('Primary')),
                        const WantBadge(
                          variant: WantButtonVariant.secondary,
                          child: Text('Desktop'),
                        ),
                        const WantBadge(
                          variant: WantButtonVariant.destructive,
                          child: Text('Unavailable'),
                        ),
                      ]),
                      const WantAlert(
                        title: Text('Preview available'),
                        description: Text(
                          'Choose an example action to continue.',
                        ),
                      ),
                      const WantAlert(
                        title: Text('Could not load preview'),
                        description: Text('Try again.'),
                        destructive: true,
                      ),
                      const WantProgress(label: 'Example progress', value: 64),
                      const WantProgress(label: 'Loading preview'),
                      const WantSkeleton(height: 80),
                    ],
                  ),
                ),
                _section(
                  'notifications',
                  'Toast and semantic snackbars',
                  _buttons([
                    WantButton(
                      onPressed: () => _message('Local preview ready'),
                      child: const Text('Show toast'),
                    ),
                    for (final variant in WantSnackbarVariant.values)
                      WantButton(
                        variant: WantButtonVariant.secondary,
                        onPressed: () => showWantSnackbar(
                          context: context,
                          variant: variant,
                          variantLabel: variant.name,
                          title: Text('${variant.name}: example status'),
                          description: const Text(
                            'Theme-aware feedback with one useful action.',
                          ),
                          closeLabel: 'Dismiss status',
                          actionLabel: 'View details',
                          onAction: () => _message('Details selected'),
                        ),
                        child: Text(variant.name),
                      ),
                  ]),
                ),
                _section(
                  'search',
                  'Searchable combobox',
                  WantCombobox<String>(
                    value: _combo,
                    label: const Text('Collection'),
                    emptyLabel: 'No matches',
                    searchHint: 'Search collections',
                    options: const [
                      WantOption(value: 'violet', label: 'Violet Horizon'),
                      WantOption(value: 'woven', label: 'Woven Spectrum'),
                      WantOption(
                        value: 'locked',
                        label: 'Unavailable',
                        disabled: true,
                      ),
                    ],
                    onChanged: (value) => setState(() => _combo = value),
                  ),
                ),
                _section(
                  'table',
                  'Table and pagination',
                  WantTable<int>(
                    caption: 'Local collection',
                    emptyLabel: 'No records',
                    rows: List.generate(4, (index) => index + 1),
                    columns: [
                      WantTableColumn(
                        label: 'Name',
                        width: 220,
                        cellBuilder: (value) => Text('Preview $value'),
                      ),
                      WantTableColumn(
                        label: 'Format',
                        cellBuilder: (_) => const Text('PNG'),
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
                        navigation: 'Pages',
                        previous: 'Previous page',
                        next: 'Next page',
                        pageSize: 'Rows per page',
                        page: (page) => 'Page $page',
                        results: (from, to, total) => '$from–$to of $total',
                      ),
                    ),
                  ),
                ),
                _section(
                  'files',
                  'File selection',
                  WantFileUpload(
                    files: _files,
                    onChanged: (files) => setState(() => _files = files),
                    label: const Text('Images'),
                    extensions: const ['png', 'jpg', 'jpeg', 'webp'],
                    maxSize: 8 * 1024 * 1024,
                    maxFiles: 4,
                    labels: WantFileUploadLabels(
                      choose: 'Choose images',
                      drop: 'Drop images here or choose a file.',
                      readFailed: 'Could not read the selected file.',
                      remove: (name) => 'Remove $name',
                      invalidType: (name) => '$name is not a supported image.',
                      tooLarge: (name, limit) => '$name exceeds $limit bytes.',
                      tooMany: (count) => 'Choose up to $count files.',
                    ),
                  ),
                ),
                _section(
                  'date-url-window',
                  'Date, URL and page layout',
                  WantWindow(
                    title: 'Create a preview',
                    kicker: 'Local composition',
                    actions: WantButton(
                      onPressed: () => _message('Preview action selected'),
                      child: const Text('Preview'),
                    ),
                    child: WantFieldGroup(
                      children: [
                        WantDateField(
                          value: _date,
                          onChanged: (value) => setState(() => _date = value),
                          label: const Text('Date'),
                          mode: WantDateFieldMode.dateTime,
                          timeLabel: const Text('Time'),
                          todayLabel: 'Use today',
                        ),
                        WantUrlField(
                          controller: _url,
                          label: const Text('Source URL'),
                          openLabel: 'Open source',
                          onOpen: (uri) => _message('Open ${uri.host}'),
                        ),
                      ],
                    ),
                  ),
                ),
                _section(
                  'cards',
                  'Cards, media and liquid glass',
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 24,
                    children: [
                      WantMediaCard(
                        title: 'Violet Horizon',
                        caption: 'Local demonstration artwork',
                        imageLabel: 'Violet gradient',
                        index: 1,
                        onPressed: () => _message('Preview selected'),
                        image: const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF5962F0), Color(0xFF141414)],
                            ),
                          ),
                        ),
                      ),
                      const WantCard(
                        title: Text('Download panel'),
                        description: Text('A composed card'),
                        child: Text(
                          'Public slots keep content in the consuming application.',
                        ),
                      ),
                      const WantGlass(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'Liquid glass · opaque when transparency is reduced.',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _section(
                  'contact',
                  'Contact card',
                  WantContactCard(
                    name: 'Want Studio',
                    subtitle: 'Product design',
                    actions: [
                      WantContactAction(
                        title: 'Website',
                        detail: 'want.design',
                        onPressed: () => _message('Website selected'),
                      ),
                    ],
                  ),
                ),
                _section(
                  'comments',
                  'Comment carousel',
                  WantCommentFeed(
                    labels: const WantCommentFeedLabels(
                      title: 'Comments',
                      empty: 'No comments',
                      previous: 'Previous comments',
                      next: 'Next comments',
                      readMore: 'Read more',
                      collapse: 'Collapse',
                    ),
                    comments: [
                      for (var index = 0; index < 4; index++)
                        WantComment(
                          id: '$index',
                          author: 'Reviewer ${index + 1}',
                          own: index == 0,
                          dateLabel: 'Today',
                          text: index == 1
                              ? List.filled(
                                  8,
                                  'Readable copy follows the same Want typography.',
                                ).join('\n')
                              : 'The preview is ready to explore.',
                          actions: const [
                            WantCommentAction(id: 'reply', label: 'Reply'),
                          ],
                        ),
                    ],
                    onAction: (id, action) => _message('$action selected'),
                  ),
                ),
                _section(
                  'loaders',
                  'Custom loaders',
                  _buttons([
                    for (final variant in WantLoaderVariant.values)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 12,
                        children: [
                          WantLoader(
                            label: 'Loading ${variant.name}',
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
                  'Shimmer placeholders',
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 24,
                    children: [
                      for (final variant in WantShimmerVariant.values)
                        WantShimmer(
                          label: 'Loading ${variant.name}',
                          variant: variant,
                          paused: _paused,
                        ),
                    ],
                  ),
                ),
                _section(
                  'animated-text',
                  'Animated text',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: [
                      for (final effect in WantTextEffect.values)
                        WantAnimatedText(
                          [
                            'Your next idea.',
                            'Made with Want.',
                            'Ready to explore.',
                          ][_text % 3],
                          effect: effect,
                        ),
                      WantButton(
                        onPressed: () => setState(() => _text++),
                        child: const Text('Change text'),
                      ),
                    ],
                  ),
                ),
                _section(
                  'glow',
                  'Reusable glow and confetti',
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 40,
                    children: [
                      WantGlow(
                        paused: _paused,
                        child: const WantCard(
                          child: Text(
                            'A visible halo with two expanding waves.',
                          ),
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
                              child: const Text('Explore Want'),
                            ),
                          ),
                        ),
                      ),
                      WantButton(
                        variant: WantButtonVariant.secondary,
                        onPressed: _background.triggerWave,
                        child: const Text('Trigger background wave'),
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
    ),
  );
}
