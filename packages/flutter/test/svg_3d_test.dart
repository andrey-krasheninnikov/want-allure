import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
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
  testWidgets('toast status plate and wrapped message align at the top', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(
        WantToast(
          title: const SizedBox(
            width: 100,
            child: Text('Saved with a longer message'),
          ),
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
      tester
          .getTopLeft(
            find.ancestor(of: icon, matching: find.byType(Container)).first,
          )
          .dy,
      closeTo(
        tester.getTopLeft(find.text('Saved with a longer message')).dy,
        .1,
      ),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
  testWidgets('unsupported rounded geometry and alpha keep the original SVG', (
    tester,
  ) async {
    for (final property in ['rx="3"', 'opacity=".5"', 'fill-opacity=".5"']) {
      await tester.pumpWidget(
        harness(
          SizedBox(
            width: 200,
            height: 200,
            child: WantSvg3D.string(
              '<svg viewBox="0 0 10 10"><rect width="10" height="10" $property/></svg>',
              semanticsLabel: 'Fallback',
              errorBuilder: (_, error) => const Text('Original SVG'),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Original SVG'), findsOneWidget);
      expect(find.byType(DiTreDi), findsNothing);
    }
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
  testWidgets(
    'brand feather preserves every pixel segment at its viewBox scale',
    (tester) async {
      final source = await rootBundle.loadString(
        'packages/want_allure/assets/brand/allure/logos/dark/transparent.svg',
      );
      final rectangles = RegExp(
        r'M([0-9]+) ([0-9]+)\s*H([0-9]+)\s*V([0-9]+)\s*H',
      ).allMatches(source);
      final box = RegExp(r'viewBox="0 0 ([0-9]+) ([0-9]+)"')
          .firstMatch(source)!;
      final width = double.parse(box[1]!), height = double.parse(box[2]!);
      final scale = 2 / (width > height ? width : height);
      var expected = 0.0;
      for (final rect in rectangles) {
        expected +=
            (double.parse(rect[3]!) - double.parse(rect[1]!)) *
            (double.parse(rect[4]!) - double.parse(rect[2]!)) *
            scale *
            scale;
      }
      expect(rectangles.length, 39);
      expect(expected, closeTo(.82421875, .0001));
      await tester.pumpWidget(
        harness(
          SizedBox(
            width: 300,
            height: 300,
            child: WantSvg3D.string(
              source,
              semanticsLabel: 'Brand',
              paused: true,
            ),
          ),
        ),
      );
      await tester.pump();
      var actual = 0.0;
      for (final face
          in tester
              .widget<DiTreDi>(find.byType(DiTreDi))
              .figures
              .whereType<Face3D>()) {
        final a = face.triangle.point0,
            b = face.triangle.point1,
            c = face.triangle.point2;
        if ([a, b, c].every((point) => (point.z - .12).abs() < .0001)) {
          actual +=
              ((b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)).abs() / 2;
        }
      }
      expect(actual, closeTo(expected, .001));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    },
  );
}
