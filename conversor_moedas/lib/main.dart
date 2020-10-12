import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const API_URL = "https://api.hgbrasil.com/finance?format=json&key=ebb70abe";

void main() async {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                  return Container(
                    color: Colors.green,
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
