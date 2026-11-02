import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:want_allure/src/widgets/file_stream.dart';

void main() {
  test(
    'dropped streams retain the filename and data on native targets',
    () async {
      final file = await readDroppedFile(
        Stream.fromIterable([
          Uint8List.fromList([1, 2]),
          Uint8List.fromList([3]),
        ]),
        'preview.png',
        isActive: () => true,
      );
      expect(file.name, 'preview.png');
      expect(file.mimeType, 'image/png');
      expect(await file.readAsBytes(), [1, 2, 3]);
    },
  );
  test('size limits stop reading before the next oversized chunk', () async {
    var read = 0;
    Stream<Uint8List> chunks() async* {
      for (var index = 0; index < 5; index++) {
        read++;
        yield Uint8List(4);
      }
    }

    await expectLater(
      readDroppedFile(chunks(), 'a.png', maxSize: 5, isActive: () => true),
      throwsA(isA<FileReadLimitExceeded>()),
    );
    expect(read, 2);
  });
  test(
    'disposed owners cancel streams without accepting partial content',
    () async {
      var active = true;
      Stream<Uint8List> chunks() async* {
        yield Uint8List(1);
        active = false;
        yield Uint8List(1);
      }

      await expectLater(
        readDroppedFile(chunks(), 'a.png', isActive: () => active),
        throwsStateError,
      );
    },
  );
}
