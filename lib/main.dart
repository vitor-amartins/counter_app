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

class _HomeWidget extends State<MyHomePage> {

  List<Contador> counters = [];

  @override
  initState() {
    super.initState();
    widget.storage.readCounters().then((String str) {
      if(str != '') json.decode(str).forEach((map) => counters.add(new Contador.fromJson(map)));
      setState(() {});
    });
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

  String newCounterTitle;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Contador"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: () {
              nameCounterDialog(counters.length, false);
            },
          ),
          new IconButton(
            icon: new Icon(Icons.remove),
            onPressed: () {
              if(counters.length > 0){
                counters.removeLast();
                setState(() {
                  widget.storage.writeCounters(json.encode(counters));
                });
              }
            },
          )
        ],
      ),
      body: new Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/wallpaper.jpg"),
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

  nameCounterDialog(index, rename) {
    showDialog(context: context,
      child: new SimpleDialog(
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
      )
    );
  }

  setRowContent(rowNumber) {
    return <Widget>[
      new GestureDetector(
        onTap: () {
          nameCounterDialog(rowNumber, true);
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
    ];
  }
}
