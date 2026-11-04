import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_allure/want_allure.dart';

import 'helpers.dart';

void main() {
  for (final brightness in Brightness.values) {
    for (final variant in [
      WantButtonVariant.primary,
      WantButtonVariant.destructive,
    ]) {
      testWidgets(
        '${brightness.name} ${variant.name} stays readable while hovered and pressed',
        (tester) async {
          await tester.pumpWidget(
            harness(
              WantButton(
                variant: variant,
                onPressed: () {},
                child: const Text('Action'),
              ),
              brightness: brightness,
            ),
          );
          void checkContrast() {
            final surface = tester.widget<AnimatedContainer>(
              find.descendant(
                of: find.byType(WantButton),
                matching: find.byType(AnimatedContainer),
              ),
            );
            final background = (surface.decoration! as BoxDecoration).color!;
            final foreground = DefaultTextStyle.of(
              tester.element(find.text('Action')),
            ).style.color!;
            final luminance = [
              background.computeLuminance(),
              foreground.computeLuminance(),
            ]..sort();
            expect(
              (luminance.last + .05) / (luminance.first + .05),
              greaterThanOrEqualTo(4.5),
            );
          }

          checkContrast();
          final mouse = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          await mouse.addPointer(location: Offset.zero);
          await mouse.moveTo(tester.getCenter(find.byType(WantButton)));
          await tester.pump(const Duration(milliseconds: 200));
          checkContrast();
          await mouse.down(tester.getCenter(find.byType(WantButton)));
          await tester.pump(const Duration(milliseconds: 200));
          checkContrast();
          await mouse.up();
          await tester.pump(const Duration(milliseconds: 200));
          await mouse.removePointer();
          await tester.pumpWidget(const SizedBox.shrink());
        },
      );
    }
  }
}
