import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const API_KEY = "api_key=jNTSi44tQzCqOSdYLLVR00nGaTKPQKvA";
const BASE_URL = "https://api.giphy.com/v1/gifs";
const trending = "trending?";
const search = "search?q=";
const lang = "lang=en";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    int limit = 20;
    String paginator = "limit=$limit&offset=$_offset";
    http.Response response;
    if (_search == null)
      response = await http.get("$BASE_URL/$trending&$API_KEY&rating=G");
    else
      response = await http
          .get("$BASE_URL/$search$_search&$lang&$API_KEY&rating=G&$paginator");
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    this._getGifs().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: "Pesquise Aqui!")),
          ),
        ],
      ),
    );
  }
}
