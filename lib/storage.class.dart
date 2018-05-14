import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class Storage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFileCounter async {
    final path = await _localPath;
    return new File('$path/counters.txt');
  }

  Future<File> writeCounters(String cont) async {
    final file = await _localFileCounter;
    return file.writeAsString("$cont");
  }

  Future<String> readCounters() async {
    try {
      final file = await _localFileCounter;
      String content = await file.readAsString();
      return content;
    } catch (e) {
      return '';
    }
  }

  Future<File> get _localFileConfig async {
    final path = await _localPath;
    return new File('$path/config.txt');
  }

  Future<File> writeConfig(String configs) async {
    final file = await _localFileConfig;
    return file.writeAsString(configs);
  }

  Future<String> readConfig() async {
    try {
      final file = await _localFileConfig;
      String content = await file.readAsString();
      return content;
    } catch (e) {
      return '';
    }
  }
}
