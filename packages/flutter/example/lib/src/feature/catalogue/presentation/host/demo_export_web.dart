import 'dart:js_interop';

import 'package:web/web.dart' as web;

@JS('window.showSaveFilePicker')
external JSFunction? get _filePicker;

@JS('window.showSaveFilePicker')
external JSPromise<_SaveHandle> _pick(_SaveOptions options);

extension type _SaveOptions._(JSObject _) implements JSObject {
  external factory _SaveOptions({String suggestedName});
}

extension type _SaveHandle._(JSObject _) implements JSObject {
  external JSPromise<_SaveWriter> createWritable();
}

extension type _SaveWriter._(JSObject _) implements JSObject {
  external JSPromise<JSAny?> write(web.Blob value);
  external JSPromise<JSAny?> close();
}

Future<bool?> saveDemoExport(String sample) async {
  final blob = web.Blob(
    [sample.toJS].toJS,
    web.BlobPropertyBag(type: 'application/json'),
  );
  if (_filePicker != null && web.window.top == web.window) {
    try {
      final handle = await _pick(
        _SaveOptions(suggestedName: 'allure-example.json'),
      ).toDart;
      final stream = await handle.createWritable().toDart;
      await stream.write(blob).toDart;
      await stream.close().toDart;
      return true;
    } catch (error) {
      final exception = error as JSAny;
      if (exception.isA<web.DOMException>() &&
          (exception as web.DOMException).name == 'AbortError') {
        return null;
      }
      rethrow;
    }
  }
  final url = web.URL.createObjectURL(blob);
  web.HTMLAnchorElement()
    ..href = url
    ..download = 'allure-example.json'
    ..click();
  Future<void>.delayed(
    const Duration(seconds: 1),
    () => web.URL.revokeObjectURL(url),
  );
  return false;
}
