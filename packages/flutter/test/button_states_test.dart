import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_allure/want_allure.dart';

import 'helpers.dart';

void main() {
  testWidgets(
    'legacy themes retain link overrides and resolve added material roles',
    (tester) async {
      final modern = WantThemeData.light();
      const customLink = Color(0xFF276B53);
      final legacy = Map<String, Color>.from(modern.colors)
        ..removeWhere(
          (key, _) => [
            'surface-highlight',
            'surface-shadow',
            'primary-text',
            'primary-soft',
          ].contains(key),
        )
        ..['link'] = customLink;
      final data = WantThemeData(colors: legacy, forui: modern.forui);
      await tester.pumpWidget(
        harness(
          WantTheme(
            data: data,
            child: Column(
              children: [
                WantButton(onPressed: () {}, child: const Text('Action')),
                WantButton(
                  variant: WantButtonVariant.link,
                  onPressed: () {},
                  child: const Text('Custom link'),
                ),
                WantToast(
                  title: const Text('Saved'),
                  closeLabel: 'Dismiss',
                  onClose: () {},
                ),
              ],
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        DefaultTextStyle.of(tester.element(find.text('Custom link')))
            .style
            .color,
        customLink,
      );
      expect(data.color('primary-text'), customLink);
      expect(() => data.color('unknown'), throwsArgumentError);
    },
  );
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
