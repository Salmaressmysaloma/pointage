import 'dart:js' as js;
import 'dart:async';

typedef ScanCallback = void Function(String result);

class Html5QrcodeScanner {
  static void start(ScanCallback onScan) {
    // Define a JS callback function that Dart passes to JS
    final jsCallback = js.allowInterop((String result) {
      onScan(result);
    });

    // Call JS function startHtml5Qrcode مع callback
    js.context.callMethod('startHtml5Qrcode', [jsCallback]);
  }
}
