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
          hintStyle: TextStyle(color: Colors.amber),
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
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "BRL",
                              labelStyle: TextStyle(
                                  color: Colors.amber, fontSize: 20.0),
                              border: OutlineInputBorder(),
                              prefixText: "R\$"),
                        ),
                        Divider(),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "EUR",
                              labelStyle: TextStyle(
                                  color: Colors.amber, fontSize: 20.0),
                              border: OutlineInputBorder(),
                              prefixText: "€"),
                        ),
                        Divider(),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "USD",
                              labelStyle: TextStyle(
                                  color: Colors.amber, fontSize: 20.0),
                              border: OutlineInputBorder(),
                              prefixText: "US\$"),
                        )
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
