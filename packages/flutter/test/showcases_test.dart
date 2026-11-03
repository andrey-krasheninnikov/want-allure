import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_allure/want_allure.dart';

import 'helpers.dart';

void main() {
  testWidgets('sliders change values with keyboard in both directions', (
    tester,
  ) async {
    for (final direction in TextDirection.values) {
      double value = 40;
      await tester.pumpWidget(
        harness(
          StatefulBuilder(
            builder: (context, setState) => WantSlider(
              value: value,
              min: 20,
              max: 80,
              step: 5,
              label: const Text('Intensity'),
              onChanged: (next) => setState(() => value = next),
            ),
          ),
          direction: direction,
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(
        direction == TextDirection.ltr
            ? LogicalKeyboardKey.arrowRight
            : LogicalKeyboardKey.arrowLeft,
      );
      await tester.pump();
      expect(value, 45);
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(value, 80);
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });
  testWidgets('card hover preserves layout and disposes its motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(const WantCard(child: Text('Selectable card')), reduced: false),
    );
    await tester.pump();
    final before = tester.getRect(find.byType(WantCard));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(before.center);
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.getRect(find.byType(WantCard)), before);
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });
  testWidgets('table keeps sorting and empty content', (tester) async {
    var sorted = false;
    await tester.pumpWidget(
      harness(
        WantTable<int>(
          rows: const [1],
          caption: 'Records',
          emptyLabel: 'No records',
          columns: [
            WantTableColumn(
              label: 'Count',
              sortLabel: 'Sort by count',
              alignment: AlignmentDirectional.centerEnd,
              ascending: true,
              onSort: () => sorted = true,
              cellBuilder: (row) => Text('$row'),
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Count'));
    expect(sorted, isTrue);
    await tester.pumpWidget(
      harness(
        WantTable<int>(
          rows: const [],
          caption: 'Records',
          emptyLabel: 'No records',
          columns: [
            WantTableColumn(label: 'Count', cellBuilder: (row) => Text('$row')),
          ],
        ),
      ),
    );
    expect(find.text('No records'), findsOneWidget);
    await tester.pumpWidget(
      harness(
        const SizedBox(
          width: 300,
          height: 200,
          child: WantLightningBackground(paused: true),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
  testWidgets('table page transitions stagger rows and keep header alignment', (
    tester,
  ) async {
    Widget table(int page) => harness(
      WantTable<int>(
        caption: 'Records',
        emptyLabel: 'Empty',
        transitionKey: page,
        rowKey: (row) => row,
        rows: [page * 10 + 1, page * 10 + 2],
        columns: [
          WantTableColumn(
            label: 'Record',
            onSort: () {},
            cellBuilder: (row) => Text('Row $row'),
          ),
        ],
      ),
      reduced: false,
    );
    await tester.pumpWidget(table(0));
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      tester.getTopLeft(find.text('Record')).dx,
      closeTo(tester.getTopLeft(find.text('Row 1')).dx, .1),
    );
    await tester.pumpWidget(table(1));
    await tester.pump();
    expect(find.text('Row 1'), findsNothing);
    expect(find.text('Row 11'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}
