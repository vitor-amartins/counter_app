import 'package:flutter/material.dart';
import 'storage.class.dart';
import 'counters.class.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Contador",
        theme: new ThemeData.dark(),
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

var wallpapers = ['wallpaper', 'w1', 'w2','w3','w4','w5','w6', 'w7', 'w8', 'w9', 'w10', 'w11', 'w12', 'w13', 'w14'];
var pathWallpaper = "assets/wallpaper.jpg";

class _HomeWidget extends State<MyHomePage> {

  List<Contador> counters = [];

  @override
  initState() {
    super.initState();
    widget.storage.readCounters().then((String str) {
      if(str != '') json.decode(str).forEach((map) => counters.add(new Contador.fromJson(map)));
      setState(() {});
    });
    widget.storage.readConfig().then((String str) {
      if (str != '' && wallpapers.contains(str)) pathWallpaper = "assets/$str.jpg";
    });
  }

  Future<File> _saveWallpaper(file) async {
    return widget.storage.writeConfig(file);
  }

  Future<File> _incrementCounter(rowNumber) async {
    setState(() {
      counters[rowNumber].inc();
    });
    return widget.storage.writeCounters(json.encode(counters));
  }

  Future<File> _decrementCounter(rowNumber) async {
    setState(() {
      counters[rowNumber].dec();
    });
    return widget.storage.writeCounters(json.encode(counters));
  }

  _callChangeWP() async {
    var newPath = await Navigator.push(context, new MaterialPageRoute(builder: (context) => new WallpaperWidget()));
    _saveWallpaper(newPath);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Contador"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () {
              _callChangeWP();
            },
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        mini: true,
        child: new Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.black,
        onPressed: () {
          _nameCounter(counters.length, false);
        },
      ),
      body: new Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage(pathWallpaper),
            fit: BoxFit.cover,
          )
        ),
        child: new ListView.builder(
          itemCount: counters.length,
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
    return <Widget>[
      new GestureDetector(
        onTap: () {
          _nameCounter(rowNumber, true);
        },
        child: new Text(counters[rowNumber].title, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.black)),
      ),
      new Container(height: 8.0,),
      new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new IconButton(
            icon: new Icon(Icons.remove),
            color: Colors.red,
            onPressed: () {
              _decrementCounter(rowNumber);
            },
          ),
          new Text("${counters[rowNumber].value}", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.black)),
          new IconButton(
            icon: new Icon(Icons.add),
            color: Colors.green,
            onPressed: () {
              _incrementCounter(rowNumber);
            },
          ),
        ],
      ),
      new IconButton(
        color: Colors.red,
        icon: new Icon(Icons.delete_outline),
        onPressed: () {
          _confirmExclusion(rowNumber);
        },
      ),
      new Container(height: 8.0,)
    ];
  }

  Future<Null> _nameCounter(index, rename) async {
    String newCounterTitle;
    return showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          contentPadding: const EdgeInsets.all(16.0),
          title: new Text(rename ? "Renomear contador" : "Adicionar contador"),
          children: <Widget>[
            new TextField(
              autofocus: true,
              onChanged: (String str) {
                newCounterTitle = str;
              },
              onSubmitted: (str) {
                if(str != null && str != '') {
                  if (rename) counters[index].setTitle = str;
                  else counters.add(Contador(str, 0));
                  setState(() {
                    widget.storage.writeCounters(json.encode(counters));
                  });
                  newCounterTitle = null;
                  Navigator.pop(context);
                }
              },
              decoration: new InputDecoration(
                hintText: rename ? "Digite o novo nome do contador" : "Digite o nome do contador"  ,
              ),
            ),
            new Divider(),
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                if(newCounterTitle != null && newCounterTitle != '') {
                  if (rename) counters[index].setTitle = newCounterTitle;
                  else counters.add(Contador(newCounterTitle, 0));
                  setState(() {
                    widget.storage.writeCounters(json.encode(counters));
                  });
                  newCounterTitle = null;
                  Navigator.pop(context);
                }
              },
            )
          ],
        );
      }
    );
  }

  Future<Null> _confirmExclusion(index) async {
    return showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Tem certeza que deseja excluir ${counters[index].title}?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CANCELAR", style: new TextStyle(color: Colors.white)),
              color: Colors.grey,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("EXCLUIR", style: new TextStyle(color: Colors.white)),
              color: Colors.red,
              onPressed: () {
                counters.removeAt(index);
                setState(() {
                  widget.storage.writeCounters(json.encode(counters));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
}

class WallpaperWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Alterar plano de fundo"),
        centerTitle: true,
      ),
      body: new ListView.builder(
        itemCount: (wallpapers.length%3 == 0) ? wallpapers.length~/3 :  wallpapers.length~/3+1,
        itemBuilder: (context, rowNumber) {
          return new Container(
            padding: new EdgeInsets.all(8.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new GestureDetector(
                      child: new Image.asset("assets/${wallpapers[rowNumber*3]}.jpg", fit: BoxFit.cover, height: 200.0,),
                      onTap: () {
                        pathWallpaper = "assets/${wallpapers[rowNumber*3]}.jpg";
                        Navigator.pop(context, wallpapers[rowNumber*3]);
                      },
                    ),
                  ],
                ),
                new Column(
                  children: <Widget>[
                    new GestureDetector(
                      child: new Image.asset("assets/${wallpapers[rowNumber*3+1]}.jpg", fit: BoxFit.cover, height: 200.0,),
                      onTap: () {
                        pathWallpaper = "assets/${wallpapers[rowNumber*3+1]}.jpg";
                        Navigator.pop(context, wallpapers[rowNumber*3+1]);
                      },
                    ),
                  ],
                ),
                new Column(
                  children: <Widget>[
                    new GestureDetector(
                      child: new Image.asset("assets/${wallpapers[rowNumber*3+2]}.jpg", fit: BoxFit.cover, height: 200.0,),
                      onTap: () {
                        pathWallpaper = "assets/${wallpapers[rowNumber*3+2]}.jpg";
                        Navigator.pop(context, wallpapers[rowNumber*3+2]);
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        },
      )
    );
  }
}