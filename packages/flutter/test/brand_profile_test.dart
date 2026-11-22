import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_allure/want_allure.dart';

import 'helpers.dart';

void main() {
  test('portable profiles match the same fixtures as foundation', () {
    final document = jsonDecode(
      File('../../tests/fixtures/brand-profile-v1.json').readAsStringSync(),
    ) as Map;
    for (final sample in document['valid'] as List) {
      final profile = WantBrandProfileV1.fromJson(sample['profile'] as Map);
      expect(jsonDecode(jsonEncode(profile)), sample['profile']);
      for (final mode in Brightness.values) {
        final theme = WantThemeData.fromProfile(profile, brightness: mode);
        for (final entry in (sample[mode.name] as Map).entries) {
          final role = (entry.key as String).substring(2);
          final color = role == 'brand-color'
              ? theme.brandColor
              : theme.color(role);
          expect(
            color.toARGB32(),
            0xff000000 |
                int.parse((entry.value as String).substring(1), radix: 16),
            reason: '${mode.name} $role',
          );
        }
      }
    }
    for (final sample in document['invalid'] as List) {
      expect(
        () => WantBrandProfileV1.fromJson(sample['profile'] as Map),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'path',
            contains(sample['path']),
          ),
        ),
      );
    }
  });

  testWidgets('nested profile supplies resource aliases to the dialog', (
    tester,
  ) async {
    final theme = WantThemeData.fromProfile(
      WantBrandProfileV1.fromJson({
        'schemaVersion': 1,
        'motion': 'off',
        'radii': {'panel': 6},
        'fonts': {'body': 'local'},
        'logos': {'dark': 'glyph'},
      }),
      brightness: Brightness.dark,
      resources: WantBrandResources(
        fonts: const {'local': 'Product'},
        logos: {'glyph': (_) => const Text('Mark')},
      ),
    );
    late WantThemeData captured;
    await tester.pumpWidget(
      harness(
        WantTheme(
          data: theme,
          child: Builder(
            builder: (context) => WantButton(
              onPressed: () => showWantDialog<void>(
                context: context,
                builder: (context) {
                  captured = WantTheme.of(context);
                  return WantDialog(
                    title: 'Profile',
                    child: WantBrandLogo.fromTheme(
                      label: 'Logo',
                      fallback: const Text('Fallback'),
                    ),
                  );
                },
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(captured.panelRadius, 6);
    expect(captured.forui.typography.body.sm.fontFamily, 'Product');
    expect(find.text('Mark'), findsOneWidget);
  });

  testWidgets('busy action keeps the footprint and rejects repeated presses', (
    tester,
  ) async {
    int presses = 0;
    Widget app(bool busy) => harness(
      WantButton(
        onPressed: () => presses++,
        busy: busy,
        busyLabel: 'Working',
        child: const Text('Save changes'),
      ),
    );
    await tester.pumpWidget(app(false));
    final size = tester.getSize(find.byType(WantButton));
    await tester.pumpWidget(app(true));
    expect(tester.getSize(find.byType(WantButton)), size);
    await tester.tap(find.byType(WantButton));
    expect(presses, 0);
    expect(find.byType(WantLoader), findsOneWidget);
    await tester.pumpWidget(app(false));
    await tester.tap(find.text('Save changes'));
    expect(presses, 1);
    await tester.pumpAndSettle();
  });

  testWidgets('replacing a pending operation leaves one message', (
    tester,
  ) async {
    late WantToastHandle first, second;
    await tester.pumpWidget(
      harness(
        Builder(
          builder: (context) => WantButton(
            onPressed: () {
              first = showWantToast(
                context: context,
                operationKey: 'export',
                title: const Text('Saving'),
                closeLabel: 'Close',
              );
              second = showWantToast(
                context: context,
                operationKey: 'export',
                title: const Text('Saved'),
                closeLabel: 'Close',
              );
            },
            child: const Text('Export'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Export'));
    await tester.pumpAndSettle();
    expect(first.showing, isFalse);
    expect(second.showing, isTrue);
    expect(find.text('Saving'), findsNothing);
    expect(find.text('Saved'), findsOneWidget);
    second.dismiss();
    await tester.pumpAndSettle();
  });

  testWidgets('bounded calendar disables today outside the requested days', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(
        WantDateField(
          label: const Text('Date'),
          value: null,
          onChanged: (_) => fail('Today is outside the range'),
          today: DateTime(2024, 12, 31),
          todayLabel: 'Today',
          minDate: DateTime(2025, 1, 2),
          maxDate: DateTime(2025, 1, 8),
          firstDayOfWeek: DateTime.sunday,
        ),
      ),
    );
    expect(
      tester.widget<WantButton>(find.byType(WantButton)).onPressed,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('external search keeps its query when delayed options change', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    late StateSetter refresh;
    var loading = false;
    var failure = false;
    var accepted = '';
    var notified = '';
    final options = <WantOption<String>>[];
    await tester.pumpWidget(
      harness(
        StatefulBuilder(
          builder: (context, setState) {
            refresh = setState;
            return WantCombobox<String>(
              value: null,
              label: const Text('Directory'),
              searchHint: 'Search',
              emptyLabel: 'Empty',
              queryController: controller,
              onQueryChanged: (value) => notified = value,
              filterLocally: false,
              options: options,
              loading: loading,
              loadingIndicator: const Text('Waiting'),
              error: failure ? const Text('Offline') : null,
              retryAction: WantButton(
                onPressed: () => refresh(() => failure = false),
                child: const Text('Retry'),
              ),
              onChanged: (value) => accepted = value ?? '',
            );
          },
        ),
      ),
    );
    await tester.tap(find.byType(EditableText).first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).last, 'xyz');
    expect(notified, 'xyz');
    refresh(() => loading = true);
    await tester.pumpAndSettle();
    expect(find.text('Waiting'), findsOneWidget);
    refresh(() {
      loading = false;
      failure = true;
    });
    await tester.pumpAndSettle();
    expect(find.text('Offline'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    refresh(() => options.add(const WantOption(value: 'one', label: 'One')));
    await tester.pumpAndSettle();
    expect(controller.text, 'xyz');
    await tester.tap(find.text('One'));
    await tester.pumpAndSettle();
    expect(accepted, 'one');
  });
}
