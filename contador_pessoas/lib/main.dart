import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: "Contador de Pessoa", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _people = 0;
  String _infoText = "Pode Entrar";

  void _changeInfoText() {
    setState(() {
      _infoText = _people < 0 ? "Mundo Invertido" : "Pode Entrar";
    });
  }

  void _increment() {
    setState(() {
      _people++;
    });
  }

  void _decrement() {
    setState(() {
      _people--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.asset(
        "images/restaurant.jpg",
        fit: BoxFit.cover,
        height: 1000.0,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Pessoas: $_people ",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                    onPressed: () {
                      _increment();
                      _changeInfoText();
                    },
                    child: Text(
                      "+1",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: FlatButton(
                    onPressed: () {
                      _decrement();
                      _changeInfoText();
                    },
                    child: Text(
                      "-1",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    )),
              ),
            ],
          ),
          Text(
            "$_infoText",
            style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          )
        ],
      )
    ]);
  }
}
