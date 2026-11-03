import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_allure/want_allure.dart';

import 'helpers.dart';

void main() {
  testWidgets(
    'button supports keyboard activation, disabling and 44 px targets',
    (tester) async {
      var count = 0;
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpWidget(
        harness(
          WantButton(
            focusNode: node,
            onPressed: () => count++,
            child: const Text('Continue'),
          ),
        ),
      );
      node.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(count, 1);
      final size = tester.getSize(find.byType(WantButton));
      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
      await tester.pumpWidget(
        harness(const WantButton(onPressed: null, child: Text('Continue'))),
      );
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));
      expect(count, 1);
    },
  );

  testWidgets('heading overrides and table headers retain semantic roles', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      harness(
        Column(
          children: [
            const WantTypography(
              'Visual display',
              variant: WantTypographyVariant.display,
              headingLevel: 3,
            ),
            const WantTypography('Ordinary copy'),
            const WantTypography(
              'Unheaded display',
              variant: WantTypographyVariant.display,
              headingLevel: 0,
            ),
            WantTable<int>(
              rows: const [1],
              columns: [
                WantTableColumn(
                  label: 'Column title',
                  cellBuilder: (row) => Text('$row'),
                ),
              ],
              caption: 'Local data',
              emptyLabel: 'No data',
            ),
          ],
        ),
      ),
    );
    expect(
      tester
          .getSemantics(find.text('Visual display'))
          .getSemanticsData()
          .headingLevel,
      3,
    );
    expect(
      tester
          .getSemantics(find.text('Ordinary copy'))
          .getSemanticsData()
          .headingLevel,
      0,
    );
    expect(
      tester
          .getSemantics(find.text('Unheaded display'))
          .getSemanticsData()
          .headingLevel,
      0,
    );
    expect(
      tester
          .getSemantics(find.text('Column title'))
          .getSemanticsData()
          .role
          .name,
      'columnHeader',
    );
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('radio arrows skip disabled options and follow RTL', (
    tester,
  ) async {
    var value = 'one';
    await tester.pumpWidget(
      harness(
        StatefulBuilder(
          builder: (context, setState) => WantRadioGroup<String>(
            value: value,
            semanticsLabel: 'Format',
            options: const [
              WantOption(value: 'one', label: 'One'),
              WantOption(value: 'disabled', label: 'Disabled', disabled: true),
              WantOption(value: 'two', label: 'Two'),
            ],
            onChanged: (next) => setState(() => value = next),
          ),
        ),
        direction: TextDirection.rtl,
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(value, 'two');
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(value, 'one');
  });

  testWidgets('input preserves controller selection and exposes errors', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'Before');
    addTearDown(controller.dispose);
    var value = '';
    await tester.pumpWidget(
      harness(
        WantInput(
          controller: controller,
          label: const Text('Name'),
          error: const Text('Required'),
          onChanged: (next) => value = next,
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'After');
    expect(value, 'After');
    expect(controller.text, 'After');
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('textarea accepts multiline input and grows beyond its minimum', (
    tester,
  ) async {
    var value = '';
    await tester.pumpWidget(
      harness(WantTextarea(onChanged: (next) => value = next)),
    );
    expect(tester.takeException(), isNull);
    final before = tester.getSize(find.byType(WantTextarea));
    await tester.enterText(
      find.byType(EditableText),
      'One\nTwo\nThree\nFour\nFive\nSix',
    );
    await tester.pump();
    expect(value, 'One\nTwo\nThree\nFour\nFive\nSix');
    expect(
      tester.getSize(find.byType(WantTextarea)).height,
      greaterThan(before.height),
    );
  });

  testWidgets(
    'select preserves disabled choices and returns the selected value',
    (tester) async {
      String? value = 'one';
      await tester.pumpWidget(
        harness(
          StatefulBuilder(
            builder: (context, setState) => WantSelect<String>(
              value: value,
              label: const Text('Format'),
              options: const [
                WantOption(value: 'one', label: 'One'),
                WantOption(value: 'locked', label: 'Locked', disabled: true),
                WantOption(value: 'two', label: 'Two'),
              ],
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      );
      await tester.tap(find.text('One'));
      await tester.pumpAndSettle();
      expect(find.text('Locked'), findsOneWidget);
      await tester.tap(find.text('Locked'));
      await tester.pump();
      expect(value, 'one');
      await tester.tap(find.text('Two'));
      await tester.pumpAndSettle();
      expect(value, 'two');
    },
  );

  testWidgets('combobox filters and reports an empty search', (tester) async {
    await tester.pumpWidget(
      harness(
        WantCombobox<String>(
          value: null,
          label: const Text('Collection'),
          emptyLabel: 'No matches',
          searchHint: 'Search',
          options: const [
            WantOption(value: 'one', label: 'Violet'),
            WantOption(value: 'two', label: 'Woven'),
          ],
          onChanged: (_) {},
        ),
      ),
    );
    await tester.tap(find.byType(EditableText).first);
    await tester.pumpAndSettle();
    final field = find.byType(EditableText).last;
    await tester.enterText(field, 'unmatched');
    await tester.pumpAndSettle();
    expect(find.text('No matches'), findsOneWidget);
  });

  testWidgets(
    'pagination clamps invalid state and resets the page for a new size',
    (tester) async {
      (int, int)? selected;
      final labels = WantPaginationLabels(
        navigation: 'Pages',
        previous: 'Previous',
        next: 'Next',
        pageSize: 'Rows',
        page: (n) => 'Page $n',
        results: (from, to, total) => '$from:$to:$total',
      );
      await tester.pumpWidget(
        harness(
          WantPagination(
            page: 99,
            pageSize: 10,
            totalItems: 21,
            labels: labels,
            onChanged: (page, size) => selected = (page, size),
          ),
        ),
      );
      expect(find.text('21:21:21'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Previous').first);
      await tester.pump();
      expect(selected, (2, 10));
      await tester.tap(find.text('10').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('25').last);
      await tester.pumpAndSettle();
      expect(selected, (1, 25));
      await tester.pumpWidget(
        harness(
          WantPagination(
            page: -1,
            pageSize: 0,
            totalItems: -4,
            labels: labels,
            onChanged: (_, size) {},
          ),
        ),
      );
      expect(find.text('0:0:0'), findsOneWidget);
    },
  );

  testWidgets('dialog retains the Want theme and restores focus on dismissal', (
    tester,
  ) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpWidget(
      harness(
        Builder(
          builder: (context) => WantButton(
            focusNode: node,
            onPressed: () => showWantDialog(
              context: context,
              builder: (context) => WantDialog(
                title: 'Settings',
                child: WantButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );
    node.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsNothing);
    expect(node.hasFocus, isTrue);
  });

  testWidgets('date fields accept the supported calendar boundaries', (
    tester,
  ) async {
    for (final date in [
      DateTime(1, 1, 1),
      DateTime(99, 12, 31),
      DateTime(9999, 12, 31),
    ]) {
      await tester.pumpWidget(
        harness(
          WantDateField(
            key: ValueKey(date),
            value: date,
            label: const Text('Date'),
            today: DateTime(2026, 11, 2),
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('toast closes and errors persist by default', (tester) async {
    await tester.pumpWidget(
      harness(
        Builder(
          builder: (context) => WantButton(
            onPressed: () => showWantSnackbar(
              context: context,
              variant: WantSnackbarVariant.info,
              variantLabel: 'Info',
              title: const Text('Ready'),
              closeLabel: 'Close status',
              duration: const Duration(seconds: 1),
            ),
            child: const Text('Show'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final close = find.bySemanticsLabel('Close status').first;
    await tester.tap(close);
    await tester.pumpAndSettle();
    expect(find.text('Ready'), findsNothing);
    await tester.pumpWidget(
      harness(
        Builder(
          builder: (context) => WantButton(
            onPressed: () => showWantSnackbar(
              context: context,
              variant: WantSnackbarVariant.error,
              variantLabel: 'Error',
              title: const Text('Could not load'),
              closeLabel: 'Dismiss error',
            ),
            child: const Text('Show error'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Show error'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 30));
    expect(find.text('Could not load'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Dismiss error').first);
    await tester.pumpAndSettle();
  });

  testWidgets(
    'mixed checkbox selects a value and timed feedback pauses on focus',
    (tester) async {
      bool? selected;
      await tester.pumpWidget(
        harness(
          WantCheckbox(
            value: false,
            indeterminate: true,
            label: const Text('Mixed selection'),
            onChanged: (value) => selected = value,
          ),
        ),
      );
      await tester.tap(find.text('Mixed selection'));
      await tester.pumpAndSettle();
      expect(selected, isTrue);
      await tester.pumpWidget(
        harness(
          Builder(
            builder: (context) => WantButton(
              onPressed: () => showWantToast(
                context: context,
                title: const Text('Timed status'),
                closeLabel: 'Close timed status',
                duration: const Duration(seconds: 1),
              ),
              child: const Text('Show timed status'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Show timed status'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      Focus.of(tester.element(find.byIcon(WantIcons.x).last)).requestFocus();
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Timed status'), findsOneWidget);
      Focus.of(tester.element(find.text('Show timed status'))).requestFocus();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1200));
      await tester.pumpAndSettle();
      expect(find.text('Timed status'), findsNothing);
    },
  );

  testWidgets('long labels and text scaling remain usable at 320 px in RTL', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      harness(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WantNavigationMenu(
              semanticsLabel: 'Navigation',
              items: [
                WantNavigationItem(
                  label: const Text('Long navigation label'),
                  onPressed: () {},
                ),
              ],
            ),
            const WantBreadcrumb(
              semanticsLabel: 'Path',
              items: [
                WantBreadcrumbItem(label: Text('Home')),
                WantBreadcrumbItem(label: Text('Current section')),
              ],
            ),
            const WantWindow(
              title: 'Long page title in a narrow layout',
              child: Text('Content'),
            ),
            const WantCard(
              title: Text('Long card title'),
              description: Text('Description'),
              child: Text('Readable body'),
            ),
            WantSnackbar(
              variant: WantSnackbarVariant.warning,
              variantLabel: 'Warning',
              title: const Text('Long notification title'),
              description: const Text(
                'Some useful detail for the next available action.',
              ),
              closeLabel: 'Close',
              onClose: () {},
            ),
          ],
        ),
        textScale: 2,
        direction: TextDirection.rtl,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
