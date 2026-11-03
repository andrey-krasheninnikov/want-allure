import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_allure/want_allure.dart';

import 'helpers.dart';

void main() {
  testWidgets('dismissed stacked toasts release their pointer region', (
    tester,
  ) async {
    for (final reduced in [false, true]) {
      for (final automatic in [false, true]) {
        var taps = 0;
        final focus = FocusNode();
        late BuildContext context;
        final handles = <WantToastHandle>[];
        await tester.pumpWidget(
          harness(
            Builder(
              builder: (value) {
                context = value;
                return Focus(
                  focusNode: focus,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => taps++,
                    child: const SizedBox(width: double.infinity, height: 560),
                  ),
                );
              },
            ),
            reduced: reduced,
          ),
        );
        for (var i = 0; i < 3; i++) {
          handles.add(
            showWantToast(
              context: context,
              title: Text('Status $i'),
              closeLabel: 'Close status $i',
              duration: automatic ? const Duration(seconds: 2) : null,
            ),
          );
          await tester.pumpAndSettle();
        }
        focus.requestFocus();
        await tester.pump();
        final point = tester.getCenter(find.byType(WantToast).first);
        expect(handles.every((handle) => handle.showing), isTrue);
        if (automatic) {
          for (
            var frame = 0;
            frame < 100 && find.byType(WantToast).evaluate().isNotEmpty;
            frame++
          ) {
            await tester.pump(const Duration(milliseconds: 100));
          }
        } else {
          for (final handle in handles) {
            handle.dismiss();
          }
        }
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(WantToast), findsNothing);
        await tester.tapAt(point);
        await tester.pump();
        expect(taps, 1);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 100));
        focus.dispose();
      }
    }
  });
}
