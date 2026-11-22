import 'dart:convert';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';

Future<bool?> saveDemoExport(String sample) async {
  final target = await getSaveLocation(suggestedName: 'allure-example.json');
  if (target == null) return null;
  await XFile.fromData(
    Uint8List.fromList(utf8.encode(sample)),
    mimeType: 'application/json',
  ).saveTo(target.path);
  return true;
}
