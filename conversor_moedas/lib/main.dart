import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const API_URL = "https://api.hgbrasil.com/finance?format=json&key=ebb70abe";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(
            inherit: false,
            color: Colors.amber,
          ),
        )),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  final brlController = TextEditingController();
  final dolarController = TextEditingController();
  final eurController = TextEditingController();

  void _brlChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double brl = double.parse(text);
    dolarController.text = (brl / dolar).toStringAsFixed(2);
    eurController.text = (brl / euro).toStringAsFixed(2);
  }

  void _eurChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double eur = double.parse(text);
    brlController.text = (eur * this.euro).toStringAsFixed(2);
    dolarController.text = (eur * this.euro / dolar).toStringAsFixed(2);
  }

  void _dolarChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double usd = double.parse(text);
    brlController.text = (usd * this.dolar).toStringAsFixed(2);
    eurController.text = (usd * this.dolar / euro).toStringAsFixed(2);
  }

  void _clearAll() {
    brlController.text = "";
    dolarController.text = "";
    eurController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text("Carregando....",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0)));
              default:
                if (snapshot.hasError)
                  return Center(
                      child: Text("Error ao carregar dados....",
                          style:
                              TextStyle(color: Colors.amber, fontSize: 25.0)));
                else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 150.0, color: Colors.amber),
                        buildTextField(
                            "BRL", "R\$ ", brlController, _brlChange),
                        Divider(),
                        buildTextField("EUR", "€ ", eurController, _eurChange),
                        Divider(),
                        buildTextField(
                            "USD", "USD\$ ", dolarController, _dolarChange),
                      ],
                    ),
                  );
                }
            }
          },
        ));
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(API_URL);
  return jsonDecode(response.body);
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function fn) {
  return TextField(
    controller: controller,
    onChanged: fn,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber, fontSize: 20.0),
        border: OutlineInputBorder(),
        prefixText: prefix),
  );
}
