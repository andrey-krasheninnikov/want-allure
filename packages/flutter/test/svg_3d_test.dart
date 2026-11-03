import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditredi/ditredi.dart';
import 'package:want_allure/want_allure.dart';

import 'helpers.dart';

const ring =
    '<svg viewBox="0 0 10 10"><path fill="#5962F0" fill-rule="evenodd" d="M0 0H10V10H0Z M3 3H7V7H3Z"/></svg>';
void main() {
  testWidgets('SVG extrusion keeps thickness and the hole in both faces', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(
        SizedBox(
          width: 240,
          height: 240,
          child: WantSvg3D.string(ring, semanticsLabel: 'Ring', paused: true),
        ),
      ),
    );
    await tester.pump();
    final faces = tester
        .widget<DiTreDi>(find.byType(DiTreDi))
        .figures
        .whereType<Face3D>();
    final front = faces.where(
      (face) => [
        face.triangle.point0,
        face.triangle.point1,
        face.triangle.point2,
      ].every((point) => (point.z - .12).abs() < .0001),
    );
    var area = 0.0;
    for (final face in front) {
      final a = face.triangle.point0,
          b = face.triangle.point1,
          c = face.triangle.point2;
      area += ((b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)).abs() / 2;
    }
    expect(area, closeTo(3.36, .001));
    await tester.pumpWidget(
      harness(
        SizedBox(
          width: 240,
          height: 240,
          child: WantSvg3D.string(
            ring.replaceFirst('evenodd', 'nonzero'),
            semanticsLabel: 'Solid nested contours',
            paused: true,
          ),
        ),
      ),
    );
    await tester.pump();
    var solidArea = 0.0;
    for (final face
        in tester
            .widget<DiTreDi>(find.byType(DiTreDi))
            .figures
            .whereType<Face3D>()) {
      final a = face.triangle.point0,
          b = face.triangle.point1,
          c = face.triangle.point2;
      if ([a, b, c].every((point) => (point.z - .12).abs() < .0001)) {
        solidArea +=
            ((b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)).abs() / 2;
      }
    }
    expect(solidArea, closeTo(4, .001));

    expect(
      faces.any((face) => face.triangle.point0.z != face.triangle.point1.z),
      isTrue,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
  testWidgets(
    'latest SVG builder wins and failures use the supplied fallback',
    (tester) async {
      final pending = Completer<String>();
      await tester.pumpWidget(
        harness(
          SizedBox(
            width: 200,
            height: 200,
            child: WantSvg3D.builder(
              svgBuilder: (_) => pending.future,
              semanticsLabel: 'Pending',
              placeholderBuilder: (_) => const Text('Loading mesh'),
            ),
          ),
        ),
      );
      expect(find.text('Loading mesh'), findsOneWidget);
      await tester.pumpWidget(
        harness(
          SizedBox(
            width: 200,
            height: 200,
            child: WantSvg3D.string(
              ring,
              semanticsLabel: 'New mesh',
              paused: true,
            ),
          ),
        ),
      );
      await tester.pump();
      pending.complete('<svg/>');
      await tester.pump();
      expect(find.byType(DiTreDi), findsOneWidget);
      await tester.pumpWidget(
        harness(
          SizedBox(
            width: 200,
            height: 200,
            child: WantSvg3D.string(
              'invalid',
              semanticsLabel: 'Invalid',
              errorBuilder: (_, error) => const Text('Static fallback'),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Static fallback'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('toast status icon and message share their vertical center', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(
        WantToast(
          title: const Text('Saved'),
          variant: WantSnackbarVariant.success,
          variantLabel: 'Success',
          closeLabel: 'Dismiss',
          onClose: () {},
        ),
      ),
    );
    await tester.pump();
    final icon = find.byWidgetPredicate(
      (widget) => widget is WantIcon && widget.icon == WantIcons.success,
    );
    expect(
      tester.getCenter(icon).dy,
      closeTo(tester.getCenter(find.text('Saved')).dy, .1),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}
