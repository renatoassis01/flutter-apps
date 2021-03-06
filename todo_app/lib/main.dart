import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _todoList = [];
  final TextEditingController _todoController = TextEditingController();
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();
    _readData().then((data) => {_todoList = json.decode(data)});
  }

  void _addTodo() {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo["title"] = _todoController.text;
      newTodo["done"] = false;
      _todoList.add(newTodo);
      //_todoList.add({"title": _todoController.text, "done": false});
    });
  }

  void _removeItem(int index) {
    _lastRemovedPos = index;
    _lastRemoved = Map.from(_todoList[index]);
    setState(() {
      _todoList.removeAt(_lastRemovedPos);
      _saveData();
    });
  }

  void _restoredItem(int index, Map<String, dynamic> item) {
    setState(() {
      _todoList.insert(index, item);
      _saveData();
    });
  }

  void _clearAddTodoController() {
    _todoController.text = "";
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _todoList.sort((a, b) {
        if (a["done"] && !b["done"]) return 1;
        if (!a["done"] && !b["done"])
          return -1;
        else
          return 0;
      });
      _saveData();
    });
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Dismissible(
      key: Key(index.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        _removeItem(index);
        final snack = SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Tarefa ${_lastRemoved["title"]} removida!"),
          action: SnackBarAction(
            label: "desfazer",
            onPressed: () {
              _restoredItem(_lastRemovedPos, _lastRemoved);
            },
          ),
        );
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(snack);
      },
      child: CheckboxListTile(
        title: Text(_todoList[index]["title"]),
        value: _todoList[index]["done"],
        secondary: CircleAvatar(
            child: Icon(_todoList[index]["done"] ? Icons.check : Icons.error)),
        onChanged: (bool value) {
          setState(() {
            _todoList[index]["done"] = value;
            _saveData();
          });
        },
      ),
      background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment(-0.9, 0.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(this._todoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Tarefas"),
          centerTitle: true,
          actions: [],
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                          labelText: "Nova Tarefa",
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                  RaisedButton(
                      onPressed: () {
                        _addTodo();
                        _clearAddTodoController();
                        _saveData();
                      },
                      color: Colors.blueAccent,
                      child: Text("Add"),
                      textColor: Colors.white)
                ],
              ),
            ),
            Expanded(
                child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 5.0),
                itemBuilder: _itemBuilder,
                itemCount: _todoList.length,
              ),
            )),
          ],
        ));
  }
}
