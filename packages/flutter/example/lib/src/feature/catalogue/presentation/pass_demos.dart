import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:want_allure/want_allure.dart';

import 'package:want_allure_example/src/feature/catalogue/presentation/_barrel.dart';

const _sample = '{"sample":true}';
const _qr = [
  "1111111011100001101111111",
  "1000001000000110101000001",
  "1011101010100011101011101",
  "1011101001100010001011101",
  "1011101000101111001011101",
  "1000001010000001001000001",
  "1111111010101010101111111",
  "0000000001001011100000000",
  "1010001100111110100100101",
  "0101100110101110011000011",
  "1010101011111001010100001",
  "0100010000101100101001001",
  "1111101111011100001101011",
  "0111100110101001111000001",
  "1110001010101111001010111",
  "0010010111111010100101011",
  "1110111101000111111111010",
  "0000000011100110100011111",
  "1111111010010000101010101",
  "1000001000000101100011011",
  "1011101001111101111110000",
  "1011101000001001010010000",
  "1011101010001110100011111",
  "1000001001111011100001000",
  "1111111011100110110001001",
];
const _logo = 'assets/brand/allure/logos/dark/transparent.svg';
const _lock =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="#5962F0" d="M4 11H20V22H4Z M11 15V19H13V15Z"/></svg>';
const _shackle =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path fill="#5962F0" d="M7 12V7C7 0 17 0 17 7V12H14V7C14 4 10 4 10 7V12Z"/></svg>';

Widget _stack(List<Widget> children) => Column(
  mainAxisSize: MainAxisSize.min,
  spacing: 12,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: children,
);
Widget _actions(List<Widget> children) => Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: children,
);
Widget _sampleCopy(
  BuildContext context,
  String label,
  String value, {
  Widget? child,
}) => WantCopyAction(
  label: label,
  copiedLabel: CatalogueLocalizations.of(context).passCopied,
  errorLabel: CatalogueLocalizations.of(context).passCopyFailed,
  onCopy: () => Clipboard.setData(ClipboardData(text: value)),
  child: child,
);
Widget _logoPicture() =>
    SvgPicture.asset(_logo, package: 'want_allure', fit: BoxFit.contain);

class WorkspaceDemo extends StatefulWidget {
  const WorkspaceDemo({super.key});
  @override
  State<WorkspaceDemo> createState() => _WorkspaceDemoState();
}

class _WorkspaceDemoState extends State<WorkspaceDemo> {
  final _query = TextEditingController();
  final _storage = SharedPreferencesAsync();
  final _key = 'want-workspace-preview';
  Map<String, double> _sizes = {'groups': .24, 'items': .33, 'preview': .43};
  String _group = 'all';
  int _selected = 0;
  bool _expanded = false, _preview = false, _pinned = false, _resized = false;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    try {
      final saved = await _storage.getString('$_key-by-id');
      final restored = <String, double>{};
      if (saved == null) {
        final legacy = await _storage.getStringList(_key);
        if (legacy == null || legacy.length != _sizes.length) return;
        for (final pair in _sizes.keys.indexed) {
          final value = double.tryParse(legacy[pair.$1]);
          if (value == null || !value.isFinite || value <= 0) return;
          restored[pair.$2] = value;
        }
      } else {
        final data = jsonDecode(saved);
        if (data is! Map) return;
        for (final id in _sizes.keys) {
          final value = data[id];
          if (value is! num || !value.isFinite || value <= 0) return;
          restored[id] = value.toDouble();
        }
      }
      if (mounted && !_resized) setState(() => _sizes = restored);
    } catch (_) {}
  }

  Future<void> _resize(Map<String, double> sizes) async {
    setState(() {
      _resized = true;
      _sizes = sizes;
    });
    try {
      await _storage.setString('$_key-by-id', jsonEncode(sizes));
    } catch (_) {}
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = CatalogueLocalizations.of(context);
    void choose(String id) => setState(() {
      _group = id;
      _preview = false;
    });
    final items = [
      l.passDesignNotes,
      l.passReadingList,
      l.passReleaseChecklist,
    ];
    final groups = <WantSidebarItem>[
      (
        id: 'all',
        label: l.passAllItems,
        icon: const WantIcon(WantIcons.list),
        count: 3,
      ),
      (
        id: 'work',
        label: l.passWork,
        icon: const WantIcon(WantIcons.file),
        count: 2,
      ),
      (
        id: 'pinned',
        label: l.passPinned,
        icon: const WantIcon(WantIcons.circleCheck),
        count: 1,
      ),
    ];
    Widget panel(String label, List<Widget> children) => DecoratedBox(
      decoration: BoxDecoration(
        color: WantTheme.of(context).color('secondary'),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: _stack([Text(label), ...children]),
      ),
    );
    final groupsPane = panel(l.passGroups, [
      for (final item in groups)
        WantListRow(
          leading: item.icon,
          trailing: Text(item.count.toString()),
          selected: item.id == _group,
          onSelected: () => choose(item.id),
          child: Text(item.label),
        ),
    ]);
    final list = panel(l.passItems, [
      for (var i = 0; i < items.length; i++)
        if ((_group == 'all' ||
                (_group == 'work' && i != 1) ||
                (_group == 'pinned' && i == 0)) &&
            (!_pinned || i == 0) &&
            items[i].toLowerCase().contains(_query.text.toLowerCase()))
          WantListRow(
            leading: const WantIcon(WantIcons.file),
            selected: _selected == i,
            onSelected: () => setState(() {
              _selected = i;
              _preview = true;
            }),
            child: Text(items[i]),
          ),
    ]);
    final detail = panel(l.passPreview, [
      _sampleCopy(
        context,
        l.passCopyItemName,
        items[_selected],
        child: Text(items[_selected]),
      ),
    ]);
    return WantSidebar(
      label: l.passGroups,
      toggleLabel: l.passToggleMenu,
      closeLabel: l.passCloseMenu,
      items: groups,
      selected: _group,
      onSelected: choose,
      expanded: _expanded,
      onExpandedChanged: (value) => setState(() => _expanded = value),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 8),
        child: _stack([
          WantSearchToolbar(
            controller: _query,
            label: l.passSearchItems,
            onChanged: (_) => setState(() => _preview = false),
            actions: [
              WantButton(
                variant: WantButtonVariant.secondary,
                onPressed: () => setState(() => _pinned = !_pinned),
                child: Text(l.passFilter),
              ),
              WantButton(
                onPressed: () => setState(() => _preview = true),
                child: Text(l.passPreview),
              ),
            ],
            filters: _pinned
                ? [
                    (
                      id: 'pinned',
                      label: l.passPinned,
                      removeLabel: l.passRemovePinnedFilter,
                      onRemove: () => setState(() => _pinned = false),
                    ),
                  ]
                : const [],
          ),
          WantSplitPane.keyed(
            fractions: _sizes,
            onChanged: _resize,
            panes: [
              (
                id: 'groups',
                minimum: 176,
                child: groupsPane,
                resizeLabel: l.passResizeGroups,
              ),
              (
                id: 'items',
                minimum: 240,
                child: list,
                resizeLabel: l.passResizeItems,
              ),
              (
                id: 'preview',
                minimum: 320,
                child: detail,
                resizeLabel: l.passResizePreview,
              ),
            ],
            compact: _preview
                ? _stack([
                    WantButton(
                      variant: WantButtonVariant.ghost,
                      onPressed: () => setState(() => _preview = false),
                      child: Text(l.passBack),
                    ),
                    detail,
                  ])
                : list,
          ),
        ]),
      ),
    );
  }
}

class SensitiveFieldDemo extends StatefulWidget {
  const SensitiveFieldDemo({super.key});
  @override
  State<SensitiveFieldDemo> createState() => _SensitiveFieldDemoState();
}

class _SensitiveFieldDemoState extends State<SensitiveFieldDemo> {
  String _value = '';
  bool _invalid = false, _accepted = false;
  @override
  Widget build(BuildContext context) {
    final l = CatalogueLocalizations.of(context);
    return _stack([
      WantPasswordInput(
        label: Text(l.passExamplePassword),
        invalid: _invalid,
        onChanged: (value) => setState(() {
          _value = value;
          _invalid = false;
          _accepted = false;
        }),
        showPasswordLabel: l.passShowPassword,
        hidePasswordLabel: l.passHidePassword,
        actions: [
          WantPopover(
            child: const WantIcon(WantIcons.question),
            triggerBuilder: (context, toggle, child) => WantIconButton(
              label: l.passShowHint,
              onPressed: toggle,
              child: child,
            ),
            contentBuilder: (context, close) => _sampleCopy(
              context,
              l.passCopyHint,
              'sample-123',
              child: const Text('sample-123'),
            ),
          ),
        ],
      ),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: WantStateGlow(
          active: _value.length >= 8,
          child: WantButton(
            onPressed: () => setState(() {
              _accepted = _value == 'sample-123';
              _invalid = !_accepted;
            }),
            child: Text(l.passVerify),
          ),
        ),
      ),
      if (_accepted)
        Semantics(liveRegion: true, child: Text(l.passExampleAccepted)),
    ]);
  }
}

class SetupDemo extends StatefulWidget {
  const SetupDemo({super.key});
  @override
  State<SetupDemo> createState() => _SetupDemoState();
}

class _SetupDemoState extends State<SetupDemo> {
  final _name = TextEditingController(),
      _secret = TextEditingController(),
      _repeat = TextEditingController();
  String _icon = '0', _color = '0';
  Uint8List? _image;
  int _step = 1;
  bool _hidden = true, _saving = false;
  List<String?> _choices = [null, null, null];
  WantToastHandle? _notice;

  @override
  void dispose() {
    _notice?.dismiss();
    _name.dispose();
    _secret.dispose();
    _repeat.dispose();
    super.dispose();
  }

  Future<void> _upload() async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'Image',
          extensions: ['png', 'jpg', 'jpeg', 'webp'],
          mimeTypes: ['image/png', 'image/jpeg', 'image/webp'],
        ),
      ],
    );
    if (file == null || await file.length() > 5000000) return;
    final data = await file.readAsBytes();
    if (mounted) {
      setState(() {
        _image = data;
        _icon = 'upload';
      });
    }
  }

  WantToastHandle _toast(
    String title,
    WantSnackbarVariant variant, {
    bool persistent = false,
  }) => showWantSnackbar(
    context: context,
    variant: variant,
    variantLabel: CatalogueLocalizations.of(context).passExport,
    closeLabel: CatalogueLocalizations.of(context).passClose,
    title: Text(title),
    operationKey: this,
    duration: persistent ? null : const Duration(seconds: 5),
  );

  Future<void> _save() async {
    if (_saving) return;
    _saving = true;
    _notice?.dismiss();
    _notice = _toast(
      CatalogueLocalizations.of(context).passSavingFile,
      WantSnackbarVariant.info,
      persistent: true,
    );
    try {
      final result = await saveDemoExport(_sample);
      if (!mounted) return;
      _notice?.dismiss();
      _notice = switch (result) {
        true => _toast(
          CatalogueLocalizations.of(context).passFileSaved,
          WantSnackbarVariant.success,
        ),
        false => _toast(
          CatalogueLocalizations.of(context).passDownloadStarted,
          WantSnackbarVariant.info,
        ),
        null => null,
      };
    } catch (_) {
      if (!mounted) return;
      _notice?.dismiss();
      _notice = _toast(
        CatalogueLocalizations.of(context).passSaveFailed,
        WantSnackbarVariant.error,
      );
    } finally {
      _saving = false;
    }
  }

  Future<void> _showQr() => showWantDialog<void>(
    context: context,
    builder: (dialog) => WantDialog(
      title: CatalogueLocalizations.of(dialog).passSampleQR,
      constraints: const BoxConstraints(maxWidth: 320),
      child: _stack([
        Center(
          child: Semantics(
            label: 'QR',
            image: true,
            child: const SizedBox.square(
              dimension: 192,
              child: CustomPaint(painter: _QrPainter()),
            ),
          ),
        ),
        WantButton(
          onPressed: () => Navigator.of(dialog).pop(),
          child: Text(CatalogueLocalizations.of(dialog).passISavedIt),
        ),
      ]),
    ),
  );

  Future<void> _reset() async {
    final approved = await showWantDialog<bool>(
      context: context,
      dismissible: false,
      builder: (_) => const _DemoResetDialog(),
    );
    if (approved != true || !mounted) return;
    setState(() {
      _name.clear();
      _secret.clear();
      _repeat.clear();
      _step = 1;
      _hidden = true;
      _choices = [null, null, null];
      _image = null;
      _icon = '0';
      _color = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = WantTheme.of(context);
    final l = CatalogueLocalizations.of(context);
    final rules = [
      (l.passAtLeastEightCharacters, _secret.text.length >= 8),
      (l.passIncludesANumber, RegExp(r'\d').hasMatch(_secret.text)),
      (
        l.passValuesMatch,
        _secret.text.isNotEmpty && _secret.text == _repeat.text,
      ),
    ];
    final symbols = [
      WantIcons.file,
      WantIcons.link,
      WantIcons.search,
      WantIcons.image,
      WantIcons.circleCheck,
      WantIcons.info,
    ];
    final iconLabels = [
      l.passFile,
      l.passLink,
      l.passSearch,
      l.passImage,
      l.passCheck,
      l.passInfo,
    ];
    final roles = [
      'primary',
      'success',
      'info',
      'warning',
      'error',
      'foreground',
      'muted-foreground',
    ];
    final tones = [
      l.passPrimary,
      l.passGreen,
      l.passBlue,
      l.passAmber,
      l.passRose,
      l.passInk,
      l.passMuted,
    ];
    final exportButtons = [
      _sampleCopy(
        context,
        l.passCopyJSON,
        _sample,
        child: Text(l.passCopyJSON),
      ),
      WantButton(
        variant: WantButtonVariant.secondary,
        onPressed: _save,
        child: Text(l.passDownloadJSON),
      ),
      WantButton(
        variant: WantButtonVariant.secondary,
        onPressed: _showQr,
        child: Text(l.passShowQR),
      ),
    ];
    return _stack([
      WantStepIndicator(
        current: _step,
        total: 3,
        countLabel: '$_step / 3',
        title: Text(
          [l.passNameAndIcon, l.passRequirements, l.passChooseAndExport][_step -
              1],
        ),
      ),
      WantScreenTransition(
        step: _step,
        child: switch (_step) {
          1 => Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              WantIconColorPicker(
                label: l.passChooseIconAndColor,
                iconLabel: l.passIcons,
                colorLabel: l.passColors,
                icon: _icon,
                color: _color,
                icons: [
                  for (var i = 0; i < symbols.length; i++)
                    (
                      id: '$i',
                      label: iconLabels[i],
                      glyph: WantIcon(symbols[i]),
                    ),
                  if (_image != null)
                    (
                      id: 'upload',
                      label: l.passUploadedImage,
                      glyph: Image.memory(
                        _image!,
                        width: 22,
                        height: 22,
                        errorBuilder: (_, _, _) =>
                            const WantIcon(WantIcons.image),
                      ),
                    ),
                ],
                colors: [
                  for (var i = 0; i < roles.length; i++)
                    (id: '$i', label: tones[i], color: theme.color(roles[i])),
                ],
                upload: WantButton(
                  variant: WantButtonVariant.secondary,
                  onPressed: _upload,
                  child: Text(l.passUploadImage),
                ),
                onChanged: (value) => setState(() {
                  _icon = value.$1;
                  _color = value.$2;
                }),
              ),
              Expanded(
                child: WantInput(controller: _name, label: Text(l.passName)),
              ),
            ],
          ),
          2 => _stack([
            WantPasswordInput(
              label: Text(l.passPassword),
              controller: _secret,
              obscured: _hidden,
              onObscuredChanged: (v) => setState(() => _hidden = v),
              showPasswordLabel: l.passShowBothPasswords,
              hidePasswordLabel: l.passHideBothPasswords,
              onChanged: (_) => setState(() {}),
            ),
            WantPasswordInput(
              label: Text(l.passRepeatPassword),
              controller: _repeat,
              obscured: _hidden,
              showVisibilityToggle: false,
              showPasswordLabel: l.passShowPassword,
              hidePasswordLabel: l.passHidePassword,
              onChanged: (_) => setState(() {}),
            ),
            for (final rule in rules)
              Semantics(
                checked: rule.$2,
                child: Row(
                  spacing: 6,
                  children: [
                    if (rule.$2)
                      WantIcon(
                        WantIcons.circleCheck,
                        color: theme.color('success-text'),
                      ),
                    Flexible(
                      child: WantTypography(
                        rule.$1,
                        colorRole: rule.$2 ? 'success-text' : null,
                      ),
                    ),
                  ],
                ),
              ),
          ]),
          _ => _stack([
            for (var i = 0; i < _choices.length; i++)
              WantRadioGroup<String>(
                value: _choices[i],
                wrap: true,
                options: [
                  for (final option in ['A', 'B', 'C'])
                    WantOption(value: option, label: option),
                ],
                semanticsLabel: "${l.passChoice} ${i + 1}",
                onChanged: (value) => setState(() => _choices[i] = value),
              ),
            LayoutBuilder(
              builder: (context, bounds) =>
                  bounds.maxWidth >= 620 &&
                      MediaQuery.textScalerOf(context).scale(16) <= 24
                  ? Row(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final button in exportButtons)
                          Expanded(child: button),
                      ],
                    )
                  : _stack(exportButtons),
            ),
          ]),
        },
      ),
      _actions([
        WantButton(
          variant: WantButtonVariant.secondary,
          onPressed: _step == 1 ? null : () => setState(() => _step--),
          child: Text(l.passBack),
        ),
        if (_step < 3)
          WantButton(
            onPressed: _step == 2 && rules.any((r) => !r.$2)
                ? null
                : () => setState(() => _step++),
            child: Text(l.passNext),
          ),
        WantButton(
          variant: WantButtonVariant.ghost,
          onPressed: _reset,
          child: Text(l.passResetExample),
        ),
      ]),
    ]);
  }
}

class _DemoResetDialog extends StatefulWidget {
  const _DemoResetDialog();
  @override
  State<_DemoResetDialog> createState() => _DemoResetDialogState();
}

class _DemoResetDialogState extends State<_DemoResetDialog> {
  String _confirm = '';
  bool _busy = false, _error = false;
  @override
  Widget build(BuildContext context) {
    final l = CatalogueLocalizations.of(context);
    return PopScope(
      canPop: !_busy,
      child: WantDialog(
        title: l.passDeleteLocalSampleData,
        child: _stack([
          Text(l.passThisClearsTheNameAndChoicesEnteredInThisExample),
          WantTextarea(
            label: Text(l.passEnterDELETEToConfirm),
            enabled: !_busy,
            minLines: 2,
            onChanged: (value) => setState(() {
              _confirm = value;
              _error = false;
            }),
          ),
          if (_error)
            Semantics(
              liveRegion: true,
              child: WantTypography(
                l.passEnterDELETEExactly,
                colorRole: 'error-text',
              ),
            ),
          _actions([
            WantButton(
              variant: WantButtonVariant.secondary,
              onPressed: _busy ? null : () => Navigator.of(context).pop(),
              child: Text(l.passCancel),
            ),
            WantButton(
              variant: WantButtonVariant.destructive,
              onPressed: _busy || _confirm.trim().isEmpty
                  ? null
                  : () async {
                      if (_confirm.trim() != 'DELETE') {
                        setState(() => _error = true);
                        return;
                      }
                      setState(() => _busy = true);
                      await Future<void>.delayed(
                        const Duration(milliseconds: 180),
                      );
                      if (context.mounted) Navigator.of(context).pop(true);
                    },
              child: Text(l.passDeleteLocalData),
            ),
          ]),
        ]),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  const _QrPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffffffff)
      ..isAntiAlias = false;
    canvas.drawRect(Offset.zero & size, paint);
    final unit = size.shortestSide / 33;
    for (var y = 0; y < _qr.length; y++) {
      for (var x = 0; x < _qr[y].length; x++) {
        if (_qr[y][x] != '1') continue;
        paint.color = (x < 7 && y < 7) || (x > 17 && y < 7) || (x < 7 && y > 17)
            ? const Color(0xff5962f0)
            : const Color(0xff15161a);
        canvas.drawRect(
          Rect.fromLTWH((x + 4) * unit, (y + 4) * unit, unit, unit),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_QrPainter oldDelegate) => false;
}

class PassMotionDemo extends StatefulWidget {
  const PassMotionDemo({super.key});
  @override
  State<PassMotionDemo> createState() => _PassMotionDemoState();
}

class _PassMotionDemoState extends State<PassMotionDemo> {
  final _controller = WantBackgroundController();
  bool _paused = false, _open = false;
  int _pulse = 0;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = CatalogueLocalizations.of(context);
    return _stack([
      _actions([
        SizedBox.square(
          dimension: 48,
          child: WantSvg3D.asset(
            _logo,
            package: 'want_allure',
            contentPadding: const EdgeInsets.all(4),
            semanticsLabel: l.passActivateFeather,
            autoRotate: false,
            glow: false,
            paused: _paused,
            placeholderBuilder: (_) => _logoPicture(),
            onPressed: () => setState(() => _pulse++),
          ),
        ),
        SizedBox.square(
          dimension: 48,
          child: WantSvg3D.string(
            _lock,
            movingPart: _shackle,
            contentPadding: const EdgeInsets.all(4),
            active: _open,
            semanticsLabel: l.passToggleLock,
            autoRotate: false,
            glow: false,
            paused: _paused,
            placeholderBuilder: (_) => const WantIcon(WantIcons.lock),
            onPressed: () => setState(() => _open = !_open),
          ),
        ),
        WantButton(
          variant: WantButtonVariant.secondary,
          onPressed: () => setState(() {
            _paused = !_paused;
            _controller.toggle();
          }),
          child: Text(_paused ? l.passResume : l.passPause),
        ),
      ]),
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 144,
          child: WantBackgroundMotion(
            controller: _controller,
            alternateWithLightning: true,
            showPauseControl: false,
            pauseLabel: l.passPause,
            resumeLabel: l.passResume,
            child: Center(child: Text(l.passSphereAndLightning)),
          ),
        ),
      ),
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 144,
          child: WantThreadsBackground(
            paused: _paused,
            child: Center(child: Text(l.passLightThreads)),
          ),
        ),
      ),
      _actions([
        SizedBox.square(
          dimension: 72,
          child: WantLogoWave(
            pulse: _pulse,
            paused: _paused,
            child: _logoPicture(),
          ),
        ),
        WantButton(
          onPressed: () => setState(() => _pulse++),
          child: Text(l.passPreviewTheIntro),
        ),
        if (_pulse > 0)
          WantScreenTransition(
            step: _pulse,
            child: Semantics(
              liveRegion: true,
              child: WantTypography(l.passReady, colorRole: 'success-text'),
            ),
          ),
      ]),
    ]);
  }
}
