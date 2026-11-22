import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_allure/want_allure.dart';

import 'helpers.dart';

void main() {
  testWidgets('overlay sidebar restores the trigger focus on Escape', (
    tester,
  ) async {
    var expanded = false;
    await tester.pumpWidget(
      harness(
        StatefulBuilder(
          builder: (context, setState) => WantSidebar(
            label: 'Groups',
            toggleLabel: 'Toggle menu',
            closeLabel: 'Close menu',
            items: const [
              (
                id: 'all',
                label: 'All',
                icon: WantIcon(WantIcons.list),
                count: 1,
              ),
            ],
            selected: 'all',
            onSelected: (_) {},
            expanded: expanded,
            onExpandedChanged: (value) => setState(() => expanded = value),
            child: const SizedBox(height: 180, child: Text('Content')),
          ),
        ),
      ),
    );
    final trigger = find.byWidgetPredicate(
      (widget) => widget is WantIconButton && widget.label == 'Toggle menu',
    );
    tester.widget<WantIconButton>(trigger).onPressed!();
    await tester.pumpAndSettle();
    expect(expanded, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(expanded, isFalse);
    expect(tester.widget<WantIconButton>(trigger).focusNode?.hasFocus, isTrue);
  });

  testWidgets(
    'split handle moves only its adjacent panels in 16 logical pixels',
    (tester) async {
      List<double> sizes = [.3, .3, .4];
      final panes = <WantPane>[
        for (final id in ['groups', 'items', 'view'])
          (
            id: id,
            minimum: 100,
            child: SizedBox(key: ValueKey(id), height: 100),
            resizeLabel: 'Resize $id',
          ),
      ];
      await tester.pumpWidget(
        harness(
          Center(
            child: SizedBox(
              width: 600,
              child: StatefulBuilder(
                builder: (context, setState) => WantSplitPane(
                  panes: panes,
                  fractions: sizes,
                  compact: const Text('Compact'),
                  onChanged: (value) => setState(() => sizes = value),
                ),
              ),
            ),
          ),
        ),
      );
      final initial = tester
          .getSize(find.byKey(const ValueKey('groups')))
          .width;
      final third = tester.getSize(find.byKey(const ValueKey('view'))).width;
      final handle = find.bySemanticsLabel('Resize groups');
      final gesture = await tester.startGesture(tester.getCenter(handle));
      await gesture.moveBy(const Offset(24, 0));
      await gesture.up();
      await tester.pump();
      final moved = tester
          .getSize(find.byKey(const ValueKey('groups')).last)
          .width;
      expect(moved, greaterThanOrEqualTo(initial));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(
        tester.getSize(find.byKey(const ValueKey('groups')).last).width,
        closeTo(moved + 16, .1),
      );
      expect(
        tester.getSize(find.byKey(const ValueKey('view'))).width,
        closeTo(third, .1),
      );
    },
  );

  testWidgets(
    'copy feedback waits for completion and clears after three seconds',
    (tester) async {
      final write = Completer<void>();
      await tester.pumpWidget(
        harness(
          WantCopyAction(
            label: 'Copy sample',
            copiedLabel: 'Copied',
            errorLabel: 'Copy failed',
            onCopy: () => write.future,
          ),
        ),
      );
      tester.widget<WantIconButton>(find.byType(WantIconButton)).onPressed!();
      await tester.pumpAndSettle();
      final feedback = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Copied' &&
            widget.properties.liveRegion == true,
      );
      expect(feedback, findsNothing);
      write.complete();
      await tester.pumpAndSettle();
      expect(feedback, findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      expect(feedback, findsNothing);
    },
  );

  testWidgets('one control changes the visibility of both password fields', (
    tester,
  ) async {
    var hidden = true;
    await tester.pumpWidget(
      harness(
        StatefulBuilder(
          builder: (context, setState) => Column(
            children: [
              WantPasswordInput(
                showPasswordLabel: 'Reveal both',
                hidePasswordLabel: 'Hide both',
                obscured: hidden,
                onObscuredChanged: (value) => setState(() => hidden = value),
              ),
              WantPasswordInput(
                showPasswordLabel: 'Reveal',
                hidePasswordLabel: 'Hide',
                obscured: hidden,
                showVisibilityToggle: false,
              ),
            ],
          ),
        ),
      ),
    );
    expect(
      tester
          .widgetList<EditableText>(find.byType(EditableText))
          .every((field) => field.obscureText),
      isTrue,
    );
    await tester.tap(find.bySemanticsLabel('Reveal both'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(
      tester
          .widgetList<EditableText>(find.byType(EditableText))
          .every((field) => !field.obscureText),
      isTrue,
    );
  });
}
