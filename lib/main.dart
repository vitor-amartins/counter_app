import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Contador",
        home: new MyHomePage(title: "Contador", storage: new Storage())
    );
  }
}

class MyHomePage extends StatefulWidget {

  final Storage storage;

  MyHomePage({Key key, this.title, this.storage}) : super(key: key);

  final String title;

  @override
  _HomeWidget createState() => new _HomeWidget();
}

class _HomeWidget extends State<MyHomePage> {

  var almoco;
  var janta;

  @override
  initState() {
    super.initState();
    widget.storage.readAlmoco().then((int value) {
      setState(() {
        almoco = value;
      });
    });
    widget.storage.readJanta().then((int value) {
      setState(() {
        janta = value;
      });
    });
  }

  Future<File> _incrementAlmoco() async {
    setState(() {
      almoco++;
    });
    return widget.storage.writeAlmoco(almoco);
  }

  Future<File> _incrementJanta() async {
    setState(() {
      janta++;
    });
    return widget.storage.writeJanta(janta);
  }

  Future<File> _decrementAlmoco() async {
    setState(() {
      almoco--;
    });
    return widget.storage.writeAlmoco(almoco);
  }

  Future<File> _decrementJanta() async {
    setState(() {
      janta--;
    });
    return widget.storage.writeJanta(janta);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Contador"),
        centerTitle: true,
        backgroundColor: new Color.fromRGBO(80, 80, 80, 1.0),
      ),
      body: new Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/wallpaper.jpg"),
            fit: BoxFit.cover,
          )
        ),
        child: new ListView.builder(
          itemCount: 2,
          itemBuilder: (context, rowNumber) {
            return new Container(
              padding: new EdgeInsets.all(15.0),
              child: new Container(
                decoration: new BoxDecoration(
                  color: new Color.fromRGBO(255, 255, 255, 0.8),
                  borderRadius: new BorderRadius.circular(15.0)
                ),
                child: new Column(
                  children: setRowContent(rowNumber)
                )
              )
            );
          },
        ),
      )
    );
  }

  setRowContent(rowNumber) {
    if(rowNumber == 0) {
      var pluralAlmoco = (almoco == 1) ? "ALMOÇO" : "ALMOÇOS";
      return <Widget>[
        new Text("SALDO NO RU", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
        new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new IconButton(
              icon: new Icon(Icons.remove),
              color: Colors.red,
              onPressed: _decrementAlmoco,
            ),
            new Text("$almoco", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
            new IconButton(
              icon: new Icon(Icons.add),
              color: Colors.green,
              onPressed: _incrementAlmoco,
            ),
          ],
        ),
        new Text(pluralAlmoco, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0))
      ];
    } else if(rowNumber == 1) {
      var pluralJanta = (janta == 1) ? "JANTA" : "JANTAS";
      return <Widget>[
        new Text("SALDO NO RU", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
        new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new IconButton(
              icon: new Icon(Icons.remove),
              color: Colors.red,
              onPressed: _decrementJanta,
            ),
            new Text("$janta", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
            new IconButton(
              icon: new Icon(Icons.add),
              color: Colors.green,
              onPressed: _incrementJanta,
            ),
          ],
        ),
        new Text(pluralJanta, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0))
      ];
    } else {
      return <Widget>[
      ];
    }
  }
}

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