import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class Storage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFileA async {
    final path = await _localPath;
    return new File('$path/almoco.txt');
  }

  Future<File> get _localFileJ async {
    final path = await _localPath;
    return new File('$path/janta.txt');
  }

  Future<File> writeAlmoco(int number) async {
    final file = await _localFileA;
    return file.writeAsString("$number");
  }

  Future<File> writeJanta(int number) async {
    final file = await _localFileJ;
    return file.writeAsString("$number");
  }

  Future<int> readAlmoco() async {
    try {
      final file = await _localFileA;
      String content = await file.readAsString();
      return int.parse(content);
    } catch (e) {
      return 0;
    }
  }

  Future<int> readJanta() async {
    try {
      final file = await _localFileJ;
      String content = await file.readAsString();
      return int.parse(content);
    } catch (e) {
      return 0;
    }
  }
}