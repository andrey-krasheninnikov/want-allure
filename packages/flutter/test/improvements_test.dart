import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart' show SelectionHandler;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart' show FTheme, FDialog;
import 'package:want_allure/want_allure.dart';

import 'helpers.dart';

void main() {
  testWidgets('compact dialog keeps its accessible name', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      harness(
        Builder(
          builder: (context) => WantButton(
            onPressed: () => showWantDialog<void>(
              context: context,
              builder: (_) => const WantDialog(
                title: 'Recovery QR',
                showTitle: false,
                constraints: BoxConstraints(minWidth: 280, maxWidth: 320),
                child: Text('QR content'),
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Recovery QR'), findsNothing);
    expect(find.bySemanticsLabel('Recovery QR'), findsWidgets);
    expect(
      tester.widget<FDialog>(find.byType(FDialog)).constraints.maxWidth,
      320,
    );
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets(
    'background pause control can be hidden without disabling accessibility',
    (tester) async {
      final controller = WantBackgroundController();
      for (final showControl in [true, false]) {
        await tester.pumpWidget(
          harness(
            SizedBox(
              width: 320,
              height: 320,
              child: WantBackgroundMotion(
                controller: controller,
                showPauseControl: showControl,
                pauseLabel: 'Pause sphere',
                resumeLabel: 'Resume sphere',
                child: const Text('Content'),
              ),
            ),
            reduced: false,
          ),
        );
        await tester.pump();
        expect(
          find.text('Pause sphere'),
          showControl ? findsOneWidget : findsNothing,
        );
        expect(find.text('Content'), findsOneWidget);
      }
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
  testWidgets(
    'all sheets have a themed clipped surface, return values and restore focus',
    (tester) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final side in WantSheetSide.values) {
        final node = FocusNode();
        int? result;
        await tester.pumpWidget(
          harness(
            Builder(
              builder: (context) => WantButton(
                focusNode: node,
                onPressed: () async {
                  result = await showWantSheet<int>(
                    context: context,
                    side: side,
                    builder: (context) => WantSheet(
                      title: 'Panel ${side.name}',
                      actions: WantButton(
                        onPressed: () => Navigator.pop(context, 7),
                        child: const Text('Done'),
                      ),
                      child: const Text('Readable sheet content'),
                    ),
                  );
                },
                child: const Text('Open sheet'),
              ),
            ),
            textScale: 1.5,
          ),
        );
        node.requestFocus();
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(find.text('Readable sheet content'), findsOneWidget);
        expect(
          tester
              .widgetList<ColoredBox>(find.byType(ColoredBox))
              .any((box) => box.color == WantThemeData.dark().color('popover')),
          isTrue,
        );
        expect(
          tester
              .widgetList<ClipRRect>(find.byType(ClipRRect))
              .any((clip) => clip.borderRadius != BorderRadius.zero),
          isTrue,
        );
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();
        expect(result, 7);
        expect(node.hasFocus, isTrue);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        node.dispose();
      }
    },
  );
  testWidgets('overlays preserve a nested Want and ForUI theme', (
    tester,
  ) async {
    final nested = WantThemeData.light();
    Color? sheetColor;
    Color? toastColor;
    WantToastHandle? handle;
    await tester.pumpWidget(
      harness(
        WantTheme(
          data: nested,
          reduceMotion: true,
          child: Builder(
            builder: (context) => Column(
              children: [
                WantButton(
                  onPressed: () => showWantSheet<void>(
                    context: context,
                    builder: (context) {
                      sheetColor = FTheme.of(context).colors.background;
                      return WantSheet(
                        title: 'Nested sheet',
                        child: WantButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close nested sheet'),
                        ),
                      );
                    },
                  ),
                  child: const Text('Open nested sheet'),
                ),
                WantButton(
                  onPressed: () => handle = showWantToast(
                    context: context,
                    duration: null,
                    closeLabel: 'Close nested toast',
                    title: Builder(
                      builder: (context) {
                        toastColor = FTheme.of(context).colors.background;
                        return const Text('Nested toast');
                      },
                    ),
                  ),
                  child: const Text('Open nested toast'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open nested sheet'));
    await tester.pumpAndSettle();
    expect(sheetColor, nested.forui.colors.background);
    await tester.tap(find.text('Close nested sheet'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open nested toast'));
    await tester.pumpAndSettle();
    expect(toastColor, nested.forui.colors.background);
    handle!.dismiss();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
  testWidgets('actions keep click cursors and labels join adjacent selection', (
    tester,
  ) async {
    var presses = 0;
    var toggles = 0;
    var compositionPresses = 0;
    await tester.pumpWidget(
      harness(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select from here'),
            WantButton(
              onPressed: () => presses++,
              child: const Text('Action label'),
            ),
            WantSwitch(
              value: false,
              onChanged: (_) => toggles++,
              label: const Text('Switch label'),
            ),
            WantBrandLockup(
              name: 'Brand label',
              subtitle: 'Brand detail',
              logo: const SizedBox.square(dimension: 16),
              onPressed: () => compositionPresses++,
            ),
            WantMediaCard(
              image: const SizedBox(),
              imageLabel: 'Preview',
              title: 'Media label',
              caption: 'Media detail',
              aspectRatio: 8,
              onPressed: () => compositionPresses++,
            ),
            const Text('Select to here'),
          ],
        ),
        web: true,
      ),
    );
    final mouse = await tester.createGesture(kind: ui.PointerDeviceKind.mouse);
    await mouse.addPointer();
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.text('Action label')));
    await tester.pumpAndSettle();
    expect(
      tester.binding.mouseTracker.debugDeviceActiveCursor(1),
      SystemMouseCursors.click,
    );
    await mouse.down(tester.getCenter(find.text('Action label')));
    await mouse.up();
    await tester.pumpAndSettle();
    expect(presses, 1);
    await mouse.moveTo(tester.getCenter(find.text('Switch label')));
    await tester.pumpAndSettle();
    expect(
      tester.binding.mouseTracker.debugDeviceActiveCursor(1),
      SystemMouseCursors.click,
    );
    await mouse.down(tester.getCenter(find.text('Switch label')));
    await mouse.up();
    await tester.pumpAndSettle();
    expect(toggles, 1);
    final start =
        tester.getTopLeft(find.text('Select from here')) + const Offset(1, 8);
    final end =
        tester.getBottomRight(find.text('Select to here')) - const Offset(1, 8);
    await mouse.moveTo(start);
    await mouse.down(start);
    await mouse.moveTo(end);
    await mouse.up();
    await tester.pumpAndSettle();
    final selection = SelectionContainer.maybeOf(
      tester.element(find.text('Select from here')),
    ) as SelectionHandler;
    final selected = selection.getSelectedContent()!.plainText;
    expect(selected, contains('Action label'));
    expect(selected, contains('Switch label'));
    expect(selected, contains('Brand label'));
    expect(selected, contains('Brand detail'));
    expect(selected, contains('Media label'));
    expect(selected, contains('Media detail'));
    expect(compositionPresses, 0);
    expect(presses, 1);
    expect(toggles, 1);
    expect(
      WantWebScope.openFind(tester.element(find.text('Select from here'))),
      isFalse,
    );
    expect(find.text('Find text'), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('continuous feedback does not repaint static page content', (
    tester,
  ) async {
    var paints = 0;
    await tester.pumpWidget(
      harness(
        Column(
          children: [
            CustomPaint(
              painter: _PaintCounter(() => paints++),
              child: const Text('Static content'),
            ),
            const WantProgress(label: 'Loading'),
            const WantLoader(label: 'Loading detail'),
          ],
        ),
        reduced: false,
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    final initial = paints;
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(paints, initial);
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'offscreen effects stop tickers and resume when scrolled into view',
    (tester) async {
      final scroll = ScrollController();
      addTearDown(scroll.dispose);
      await tester.pumpWidget(
        harness(
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              controller: scroll,
              child: const Column(
                children: [
                  SizedBox(height: 1000),
                  WantLoader(label: 'Offscreen loader'),
                  WantProgress(label: 'Offscreen progress'),
                  SizedBox(height: 200),
                ],
              ),
            ),
          ),
          reduced: false,
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      expect(tester.binding.transientCallbackCount, 0);
      scroll.jumpTo(980);
      await tester.pump();
      await tester.pump();
      expect(tester.binding.transientCallbackCount, greaterThan(0));
      scroll.jumpTo(0);
      await tester.pump();
      await tester.pump();
      expect(tester.binding.transientCallbackCount, 0);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('navigation glyphs mirror exactly once in RTL', (tester) async {
    for (final direction in TextDirection.values) {
      await tester.pumpWidget(
        harness(
          Column(
            children: [
              WantBreadcrumb(
                semanticsLabel: 'Breadcrumbs',
                items: [
                  WantBreadcrumbItem(
                    label: const Text('Home'),
                    onPressed: () {},
                  ),
                  const WantBreadcrumbItem(label: Text('Current')),
                ],
              ),
              WantPagination(
                page: 2,
                pageSize: 10,
                totalItems: 30,
                onChanged: (_, _) {},
                labels: WantPaginationLabels(
                  navigation: 'Pages',
                  previous: 'Previous page',
                  next: 'Next page',
                  pageSize: 'Rows',
                  page: (page) => 'Page $page',
                  results: (_, _, _) => 'Results',
                ),
              ),
            ],
          ),
          direction: direction,
        ),
      );
      await tester.pumpAndSettle();
      final previous = find.byIcon(WantIcons.chevronLeft);
      expect(previous, findsOneWidget);
      expect(find.byIcon(WantIcons.chevronRight), findsNWidgets(2));
      final mirrors = tester
          .widgetList<Transform>(
            find.descendant(of: previous, matching: find.byType(Transform)),
          )
          .where((transform) => transform.transform.entry(0, 0) == -1);
      expect(mirrors.length, direction == TextDirection.rtl ? 1 : 0);
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets('persistent notifications dismiss by outward and upward swipes', (
    tester,
  ) async {
    for (final gesture in [
      (TextDirection.ltr, const Offset(500, 0)),
      (TextDirection.rtl, const Offset(-500, 0)),
      (TextDirection.ltr, const Offset(0, -200)),
    ]) {
      WantToastHandle? handle;
      await tester.pumpWidget(
        harness(
          Builder(
            builder: (context) => WantButton(
              onPressed: () => handle = showWantSnackbar(
                context: context,
                variant: WantSnackbarVariant.error,
                variantLabel: 'Error',
                title: const Text('Swipe notification'),
                closeLabel: 'Dismiss status',
              ),
              child: const Text('Notify swipe'),
            ),
          ),
          direction: gesture.$1,
        ),
      );
      await tester.tap(find.text('Notify swipe'));
      await tester.pumpAndSettle();
      expect(handle!.showing, isTrue);
      await tester.drag(find.text('Swipe notification'), gesture.$2);
      await tester.pumpAndSettle();
      expect(handle!.showing, isFalse);
      expect(find.text('Swipe notification'), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets('toast handle can dismiss before its first frame', (
    tester,
  ) async {
    WantToastHandle? handle;
    await tester.pumpWidget(
      harness(
        Builder(
          builder: (context) => WantButton(
            onPressed: () {
              handle = showWantToast(
                context: context,
                title: const Text('Transient'),
                closeLabel: 'Close',
              );
              handle!.dismiss();
              handle!.dismiss();
            },
            child: const Text('Notify'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Notify'));
    await tester.pumpAndSettle();
    expect(handle!.showing, isFalse);
    expect(find.text('Transient'), findsNothing);
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
  testWidgets('toaster teardown invalidates visible and pending handles', (
    tester,
  ) async {
    for (final rendered in [false, true]) {
      WantToastHandle? handle;
      await tester.pumpWidget(
        harness(
          Builder(
            builder: (context) => WantButton(
              onPressed: () => handle = showWantToast(
                context: context,
                title: const Text('Owned toast'),
                closeLabel: 'Close',
                duration: null,
              ),
              child: const Text('Notify'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Notify'));
      if (rendered) await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      expect(handle!.showing, isFalse);
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets(
    'find discovers plain rich and Want text, navigates and restores focus',
    (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        harness(
          Column(
            children: [
              WantButton(
                focusNode: node,
                onPressed: () {},
                child: const Text('Focusable control'),
              ),
              const Text('Needle one'),
              const Text.rich(TextSpan(text: 'needle two')),
              const WantTypography('needle three'),
            ],
          ),
          web: true,
          find: true,
        ),
      );
      node.requestFocus();
      await tester.pump();
      final modifier = defaultTargetPlatform == TargetPlatform.macOS
          ? LogicalKeyboardKey.metaLeft
          : LogicalKeyboardKey.controlLeft;
      await tester.sendKeyDownEvent(modifier);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
      await tester.sendKeyUpEvent(modifier);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText), 'needle');
      await tester.pumpAndSettle();
      expect(find.text('Match 1 of 3'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Match 2 of 3'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), 'absent');
      await tester.pumpAndSettle();
      expect(find.text('No matches'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(EditableText), findsNothing);
      expect(node.hasFocus, isTrue);
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant({
      TargetPlatform.macOS,
      TargetPlatform.windows,
    }),
  );
  testWidgets(
    'attachment cards handle duplicate long names and controlled removal',
    (tester) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final name = '${'long_filename_' * 8}.txt';
      var files = [
        XFile.fromData(Uint8List(2), name: name, path: name),
        XFile.fromData(Uint8List(3), name: name, path: name),
      ];
      await tester.pumpWidget(
        harness(
          StatefulBuilder(
            builder: (context, setState) => WantFileUpload(
              files: files,
              onChanged: (value) => setState(() => files = value),
              label: const Text('Files'),
              labels: WantFileUploadLabels(
                choose: 'Choose file',
                drop: 'Drop file',
                readFailed: 'Could not read',
                remove: (name) => 'Remove $name',
                invalidType: (name) => 'Invalid $name',
                tooLarge: (name, size) => 'Too large $name',
                tooMany: (count) => 'Too many $count',
              ),
            ),
          ),
          direction: TextDirection.rtl,
          textScale: 1.5,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(name), findsNWidgets(2));
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.bySemanticsLabel('Remove $name').first);
      await tester.tap(find.bySemanticsLabel('Remove $name').first);
      await tester.pumpAndSettle();
      expect(files, hasLength(1));
      expect(find.text(name), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('packaged shaders compile and shader instances dispose', (
    tester,
  ) async {
    for (final name in ['shimmer', 'sphere']) {
      final program = await tester.runAsync(
        () => ui.FragmentProgram.fromAsset('shaders/$name.frag'),
      );
      expect(program, isNotNull);
      final shader = program!.fragmentShader();
      for (var i = 0; i < 12; i++) {
        shader.setFloat(i, .5);
      }
      shader.dispose();
    }
  });
}

class _PaintCounter extends CustomPainter {
  final VoidCallback onPaint;
  _PaintCounter(this.onPaint);
  @override
  void paint(Canvas canvas, Size size) => onPaint();
  @override
  bool shouldRepaint(_PaintCounter oldDelegate) => false;
}
