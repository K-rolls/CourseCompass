import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Works for mobile and desktop
class SaveFileMobileController {
  static Future<void> saveAndLaunchFile(String text, String fileName) async {
    //Get external storage directory
    Directory directory = await getApplicationSupportDirectory();

    //Get directory path
    String path = directory.path;

    //Create an empty file to write PDF data
    File file = File('$path/$fileName');

    //Write PDF data
    await file.writeAsString(text, flush: true);

    //Open the PDF document in mobile
    OpenFile.open('$path/$fileName');
  }
}
