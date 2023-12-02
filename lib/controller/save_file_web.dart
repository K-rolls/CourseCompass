import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

// To use:
// SaveFileWeb.saveAndLaunchFile(trimmedText, 'output.txt');
class SaveFileWeb {
  static Future<void> saveAndLaunchFile(
    String text,
    String fileName,
  ) async {
    List<int> bytes = utf8.encode(text);
    AnchorElement(
      href:
          'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}',
    )
      ..setAttribute('download', fileName)
      ..click();
  }
}
