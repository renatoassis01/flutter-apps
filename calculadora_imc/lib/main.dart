import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: App()));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {})
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(
            Icons.person_outline,
            size: 120.0,
            color: Colors.green,
          ),
          TextField(
            style: TextStyle(color: Colors.green, fontSize: 25.0),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Peso(kg)",
                labelStyle: TextStyle(color: Colors.green)),
          ),
          TextField(
            style: TextStyle(color: Colors.green, fontSize: 25.0),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Altura(cm)",
                labelStyle: TextStyle(color: Colors.green)),
          )
        ],
      ),
    );
  }
}
