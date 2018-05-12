import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class Storage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return new File('$path/counters.txt');
  }

  Future<File> writeCounters(String number) async {
    final file = await _localFile;
    return file.writeAsString("$number");
  }

  Future<String> readCounters() async {
    try {
      final file = await _localFile;
      String content = await file.readAsString();
      return content;
    } catch (e) {
      return '';
    }
  }
}
