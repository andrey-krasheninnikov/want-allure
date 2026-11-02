import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

// macOS runners differ by at most 6/255 in 35 antialiased edge pixels.
bool allowsRasterDifference(Uint8List actual, Uint8List expected) {
  if (actual.length != expected.length || actual.length % 4 != 0) return false;
  var changed = 0;
  for (var pixel = 0; pixel < actual.length; pixel += 4) {
    var differs = false;
    for (var channel = 0; channel < 4; channel++) {
      final delta = (actual[pixel + channel] - expected[pixel + channel]).abs();
      if (delta > 6) return false;
      differs |= delta != 0;
    }
    if (differs) changed++;
    if (changed > actual.length / 4 * .0002) return false;
  }
  return true;
}

class WantGoldenComparator extends LocalFileComparator {
  WantGoldenComparator(super.testFile);

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    var passed = result.passed;
    if (!passed && result.diffPercent <= .0002 && result.diffs != null) {
      final actual = await result.diffs!['testImage']!.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      final expected = await result.diffs!['masterImage']!.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      passed = allowsRasterDifference(
        actual!.buffer.asUint8List(),
        expected!.buffer.asUint8List(),
      );
    }
    if (passed) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}
