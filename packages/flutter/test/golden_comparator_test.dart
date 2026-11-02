import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'golden_comparator.dart';

void main() {
  test('goldens allow only sparse small raster differences', () {
    final expected = Uint8List(5000 * 4);
    final actual = Uint8List.fromList(expected);
    expect(allowsRasterDifference(actual, expected), isTrue);
    actual[0] = 6;
    expect(allowsRasterDifference(actual, expected), isTrue);
    actual[0] = 7;
    expect(allowsRasterDifference(actual, expected), isFalse);
    actual[0] = 6;
    actual[4] = 1;
    expect(allowsRasterDifference(actual, expected), isFalse);
    expect(allowsRasterDifference(actual, Uint8List(4)), isFalse);
  });
}
