import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:mime/mime.dart';

class FileReadLimitExceeded implements Exception {
  final String name;
  final int limit;
  const FileReadLimitExceeded(this.name, this.limit);
}

Future<XFile> readDroppedFile(
  Stream<Uint8List> stream,
  String name, {
  int? maxSize,
  required bool Function() isActive,
}) async {
  final bytes = BytesBuilder(copy: false);
  await for (final chunk in stream) {
    if (!isActive()) throw StateError('Drop owner was disposed');
    if (maxSize != null && bytes.length + chunk.length > maxSize) {
      throw FileReadLimitExceeded(name, maxSize);
    }
    bytes.add(chunk);
  }
  return XFile.fromData(
    bytes.takeBytes(),
    name: name,
    path: name,
    mimeType: lookupMimeType(name),
  );
}
