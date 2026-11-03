import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart' show FDialog;
import 'package:want_allure/want_allure.dart';

import 'helpers.dart';

void main() {
  testWidgets(
    'enabling reduced motion during a fade restores the static sphere',
    (tester) async {
      final controller = WantBackgroundController();
      addTearDown(controller.dispose);
      Widget scene(bool reduced) => harness(
        SizedBox(
          height: 300,
          child: WantBackgroundMotion(
            controller: controller,
            alternateWithLightning: true,
            pauseLabel: 'Pause',
            resumeLabel: 'Resume',
            child: const SizedBox.shrink(),
          ),
        ),
        reduced: reduced,
      );
      await tester.pumpWidget(scene(false));
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(seconds: 30));
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 600));
      expect(
        tester
            .widget<Opacity>(
              find.byKey(const ValueKey('want-background-lightning')),
            )
            .opacity,
        greaterThan(0),
      );
      await tester.pumpWidget(scene(true));
      await tester.pump();
      expect(
        tester
            .widget<Opacity>(
              find.byKey(const ValueKey('want-background-lightning')),
            )
            .opacity,
        0,
      );
      expect(
        tester
            .widget<Opacity>(
              find.byKey(const ValueKey('want-background-sphere')),
            )
            .opacity,
        1,
      );
      expect(tester.binding.transientCallbackCount, 0);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets('background alternates every 30 seconds and pauses its phase', (
    tester,
  ) async {
    final controller = WantBackgroundController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      harness(
        SizedBox(
          height: 300,
          child: WantBackgroundMotion(
            controller: controller,
            alternateWithLightning: true,
            showPauseControl: false,
            pauseLabel: 'Pause',
            resumeLabel: 'Resume',
            child: const Text('Foreground'),
          ),
        ),
        reduced: false,
      ),
    );
    double lightning() => tester
        .widget<Opacity>(
          find.byKey(const ValueKey('want-background-lightning')),
        )
        .opacity;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));
    expect(lightning(), 0);
    expect(find.text('Pause'), findsNothing);
    await tester.pump(const Duration(seconds: 30));
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 600));
    expect(lightning(), closeTo(.5, .02));
    controller.pause();
    await tester.pump();
    final paused = lightning();
    await tester.pump(const Duration(seconds: 40));
    expect(lightning(), paused);
    controller.resume();
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 600));
    expect(lightning(), 1);
    await tester.pump(const Duration(milliseconds: 28800));
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 1200));
    expect(lightning(), 0);
    expect(find.text('Foreground'), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    await tester.pump(const Duration(seconds: 40));
    expect(lightning(), 0);
    expect(tester.binding.transientCallbackCount, 0);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 40));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'reduced motion retains a static sphere and compact dialogs keep their name',
    (tester) async {
      final controller = WantBackgroundController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        harness(
          SizedBox(
            height: 300,
            child: WantBackgroundMotion(
              controller: controller,
              alternateWithLightning: true,
              pauseLabel: 'Pause',
              resumeLabel: 'Resume',
              child: const SizedBox.shrink(),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 60));
      expect(
        tester
            .widget<Opacity>(
              find.byKey(const ValueKey('want-background-lightning')),
            )
            .opacity,
        0,
      );
      expect(tester.binding.transientCallbackCount, 0);
      await tester.pumpWidget(
        harness(
          const WantDialog(
            title: 'Recovery code',
            showTitle: false,
            constraints: BoxConstraints(minWidth: 280, maxWidth: 320),
            child: Text('Code'),
          ),
        ),
      );
      expect(find.text('Recovery code'), findsNothing);
      expect(find.text('Code'), findsOneWidget);
      expect(
        tester.widget<FDialog>(find.byType(FDialog)).constraints,
        const BoxConstraints(minWidth: 280, maxWidth: 320),
      );
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
