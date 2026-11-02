import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_desyst/want_desyst.dart';

import 'helpers.dart';

void main() {
  setUpAll(loadWantFonts);

  testWidgets(
    'reduced motion keeps Glow visible without scheduled animation frames',
    (tester) async {
      await tester.pumpWidget(
        harness(
          const Column(
            children: [
              WantGlow(child: SizedBox(width: 180, height: 80)),
              WantLoader(label: 'Loading'),
              WantShimmer(
                label: 'Placeholder',
                variant: WantShimmerVariant.text,
              ),
            ],
          ),
          opaque: true,
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      expect(find.byType(WantGlow), findsOneWidget);
      final shadows = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .where(
            (box) =>
                box.decoration is BoxDecoration &&
                (box.decoration as BoxDecoration).boxShadow?.isNotEmpty == true,
          );
      expect(shadows, isNotEmpty);
      expect(tester.binding.transientCallbackCount, 0);
    },
  );

  testWidgets('paused loops dispose timers and stop scheduling frames', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(const WantLoader(label: 'Loading', paused: true), reduced: false),
    );
    await tester.pump(const Duration(seconds: 2));
    expect(tester.binding.transientCallbackCount, 0);
    final controller = WantBackgroundController(paused: true);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      harness(
        SizedBox(
          height: 300,
          child: WantBackgroundMotion(
            controller: controller,
            pauseLabel: 'Pause',
            resumeLabel: 'Resume',
            child: const SizedBox.expand(),
          ),
        ),
        reduced: false,
      ),
    );
    await tester.pump();
    expect(find.text('Resume'), findsOneWidget);
    controller.triggerWave();
    await tester.pump();
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 30));
    expect(tester.takeException(), isNull);
  });

  testWidgets('system motion changes and inactive apps stop loops', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(const WantLoader(label: 'Loading'), reduced: null),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.binding.transientCallbackCount, greaterThan(0));
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    await tester.pump(const Duration(seconds: 1));
    expect(tester.binding.transientCallbackCount, 0);
    tester.platformDispatcher.clearAccessibilityFeaturesTestValue();
    await tester.pump(const Duration(milliseconds: 300));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.binding.transientCallbackCount, 0);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('rapid text replacement keeps only the current value', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      harness(const WantAnimatedText('First'), reduced: false),
    );
    await tester.pump(const Duration(milliseconds: 30));
    await tester.pumpWidget(
      harness(const WantAnimatedText('Second'), reduced: false),
    );
    await tester.pumpWidget(
      harness(const WantAnimatedText('Current'), reduced: false),
    );
    expect(find.text('First'), findsNothing);
    expect(find.text('Second'), findsNothing);
    expect(find.text('Current'), findsOneWidget);
    expect(find.bySemanticsLabel('Current'), findsOneWidget);
    expect(find.bySemanticsLabel('First'), findsNothing);
    semantics.dispose();
    await tester.pumpAndSettle();
  });

  testWidgets(
    'all visual variants render in both themes without layout exceptions',
    (tester) async {
      for (final brightness in Brightness.values) {
        await tester.pumpWidget(
          harness(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final variant in WantLoaderVariant.values)
                  WantLoader(label: variant.name, variant: variant),
                for (final variant in WantShimmerVariant.values)
                  WantShimmer(label: variant.name, variant: variant),
                for (final variant in WantTypographyVariant.values)
                  WantTypography('Aa 123', variant: variant),
                for (final variant in WantSnackbarVariant.values)
                  WantSnackbar(
                    variant: variant,
                    variantLabel: variant.name,
                    title: const Text('Status'),
                    closeLabel: 'Close',
                    onClose: () {},
                  ),
              ],
            ),
            brightness: brightness,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    },
  );

  for (final brightness in Brightness.values) {
    for (final width in [320.0, 1280.0]) {
      testWidgets('Want reference board ${brightness.name} ${width.toInt()}', (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          harness(
            RepaintBoundary(
              key: const ValueKey('board'),
              child: Builder(
                builder: (context) => ColoredBox(
                  color: WantTheme.of(context).color('background'),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        const WantTypography(
                          'Want Desyst',
                          variant: WantTypographyVariant.h2,
                        ),
                        const WantTypography(
                          'Shared foundations. Native controls.',
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final variant in WantButtonVariant.values)
                              WantButton(
                                variant: variant,
                                onPressed: () {},
                                child: Text(variant.name),
                              ),
                          ],
                        ),
                        const WantInput(
                          label: Text('Name'),
                          initialValue: 'Violet Horizon',
                        ),
                        const WantCard(
                          title: Text('Preview'),
                          child: Text('Content stays readable in both themes.'),
                        ),
                        const WantAlert(
                          title: Text('Preview available'),
                          description: Text('Choose an action.'),
                        ),
                        WantSnackbar(
                          variant: WantSnackbarVariant.success,
                          variantLabel: 'Success',
                          title: const Text('Changes saved'),
                          closeLabel: 'Close',
                          onClose: () {},
                        ),
                        const WantProgress(label: 'Progress', value: 64),
                        const WantLoader(
                          label: 'Loading',
                          variant: WantLoaderVariant.bars,
                          paused: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            brightness: brightness,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byKey(const ValueKey('board')),
          matchesGoldenFile('goldens/${brightness.name}-${width.toInt()}.png'),
        );
      }, tags: ['golden']);
    }
  }
}
