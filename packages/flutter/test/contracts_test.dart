import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:want_desyst/want_desyst.dart';

const labels = WantFileUploadLabels(
  choose: 'Choose',
  drop: 'Drop',
  readFailed: 'Read failed',
  remove: remove,
  invalidType: invalidType,
  tooLarge: tooLarge,
  tooMany: tooMany,
);
String remove(String name) => 'Remove $name';
String invalidType(String name) => 'Invalid $name';
String tooLarge(String name, int bytes) => 'Too large $name $bytes';
String tooMany(int count) => 'Too many $count';

void main() {
  test(
    'themes preserve the five accents and independent readable text roles',
    () {
      const expected = {
        'primary': Color(0xFF5962F0),
        'success': Color(0xFF7DF04A),
        'info': Color(0xFF28D7F5),
        'warning': Color(0xFFFFD43B),
        'error': Color(0xFFFF526D),
      };
      final light = WantThemeData.light(), dark = WantThemeData.dark();
      for (final entry in expected.entries) {
        expect(light.color(entry.key), entry.value);
        expect(dark.color(entry.key), entry.value);
      }
      for (final theme in [light, dark]) {
        for (final role in ['success', 'info', 'warning', 'error']) {
          final surface = theme.color(role),
              ink = theme.color('$role-foreground');
          expect(
            (surface.computeLuminance() + .05) / (ink.computeLuminance() + .05),
            greaterThanOrEqualTo(4.5),
          );
          final values = [
            theme.color('$role-text').computeLuminance(),
            theme.color('background').computeLuminance(),
          ]..sort();
          expect(
            (values[1] + .05) / (values[0] + .05),
            greaterThanOrEqualTo(4.5),
          );
        }
      }
      expect(light.forui.colors.primary, expected['primary']);
      expect(light.forui.typography.body.sm.fontSize, greaterThanOrEqualTo(16));
      expect(light.color('error-text'), isNot(light.color('error')));
      expect(() => light.color('unknown'), throwsArgumentError);
    },
  );

  test('typography exposes all 17 token styles and shared geometry', () {
    expect(WantTypographyVariant.values, hasLength(17));
    expect(WantTokens.typography, hasLength(17));
    expect(WantTokens.geometry['touchTargetPx'], 44);
    for (final name in ['body', 'small', 'caption', 'label']) {
      expect(
        WantTokens.typography[name]!.min,
        greaterThanOrEqualTo(name == 'body' ? 16 : 14),
      );
    }
  });

  test(
    'product themes can replace a semantic value without changing the base',
    () {
      final custom = WantThemeData.light(
        overrides: {'primary': const Color(0xFF3248AA)},
      );
      expect(custom.forui.colors.primary, const Color(0xFF3248AA));
      expect(WantTokens.light['primary'], const Color(0xFF5962F0));
      expect(
        () => custom.colors['primary'] = const Color(0x00000000),
        throwsUnsupportedError,
      );
    },
  );

  test('URL controls accept only complete HTTP(S) URLs', () {
    for (final value in [
      'https://want.design/path?q=1',
      ' http://localhost:4321 ',
      'https://例え.jp',
    ]) {
      expect(isHttpUrl(value), isTrue, reason: value);
    }
    for (final value in [
      '',
      '/relative',
      'javascript:alert(1)',
      'file:///private/tmp/a',
      'data:text/plain,a',
      'https://',
      'mailto:hello@example.com',
    ]) {
      expect(isHttpUrl(value), isFalse, reason: value);
    }
  });

  test(
    'calendar range preserves years 0001–0099 and rejects adjacent years',
    () {
      for (final date in [
        DateTime.utc(1),
        DateTime.utc(99, 12, 31),
        DateTime(2024, 2, 29),
        DateTime.utc(9999, 12, 31),
      ]) {
        expect(isWantDateInRange(date), isTrue);
      }
      expect(isWantDateInRange(DateTime.utc(0)), isFalse);
      expect(isWantDateInRange(DateTime.utc(10000)), isFalse);
    },
  );

  test(
    'file validation checks the entire batch before accepting any file',
    () async {
      final png = XFile.fromData(
        Uint8List(8),
        name: 'PREVIEW.PNG',
        path: 'PREVIEW.PNG',
        mimeType: 'image/png',
      );
      final pdf = XFile.fromData(
        Uint8List(2),
        name: 'note.pdf',
        path: 'note.pdf',
        mimeType: 'application/pdf',
      );
      expect(
        await validateWantFiles(
          [png],
          existing: [],
          labels: labels,
          extensions: ['png'],
          maxSize: 8,
        ),
        isNull,
      );
      expect(
        await validateWantFiles(
          [png, pdf],
          existing: [],
          labels: labels,
          extensions: ['png'],
        ),
        'Invalid note.pdf',
      );
      expect(
        await validateWantFiles(
          [png],
          existing: [],
          labels: labels,
          maxSize: 7,
        ),
        'Too large PREVIEW.PNG 7',
      );
      expect(
        await validateWantFiles(
          [png],
          existing: [png],
          labels: labels,
          maxFiles: 1,
        ),
        'Too many 1',
      );
      expect(
        await validateWantFiles(
          [png],
          existing: [pdf],
          labels: labels,
          multiple: false,
        ),
        isNull,
      );
      expect(
        await validateWantFiles(
          [png, pdf],
          existing: [],
          labels: labels,
          multiple: false,
        ),
        'Too many 1',
      );
      expect(
        await validateWantFiles(
          [png],
          existing: [],
          labels: labels,
          mimeTypes: ['image/*'],
        ),
        isNull,
      );
      expect(
        await validateWantFiles(
          [png],
          existing: [],
          labels: labels,
          extensions: ['jpg'],
          mimeTypes: ['image/png'],
        ),
        isNull,
      );
      expect(await validateWantFiles([], existing: [], labels: labels), isNull);
    },
  );

  test('file policy rejects invalid limits and unreadable metadata', () async {
    final file = XFile.fromData(Uint8List(2), name: 'a.png', path: 'a.png');
    await expectLater(
      validateWantFiles([file], existing: [], labels: labels, maxSize: -1),
      throwsArgumentError,
    );
    await expectLater(
      validateWantFiles([file], existing: [], labels: labels, maxFiles: 0),
      throwsArgumentError,
    );
    expect(
      await validateWantFiles(
        [XFile('/a-path-that-does-not-exist')],
        existing: [],
        labels: labels,
        maxSize: 1,
      ),
      'Read failed',
    );
  });

  test('background controls toggle and ignore manual waves while paused', () {
    final controller = WantBackgroundController();
    var notifications = 0;
    controller.addListener(() => notifications++);
    controller.pause();
    controller.pause();
    controller.triggerWave();
    expect(controller.paused, isTrue);
    expect(notifications, 1);
    controller.resume();
    controller.triggerWave();
    expect(controller.paused, isFalse);
    expect(notifications, 3);
    controller.dispose();
  });
}
