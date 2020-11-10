import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gif_search/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

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
    int limit = 19;
    String paginator = "limit=$limit&offset=$_offset";
    http.Response response;
    if (_search == null)
      response = await http.get("$BASE_URL/$trending&$API_KEY&rating=G");
    else
      print("$BASE_URL/$search$_search&$lang&$API_KEY&rating=G&$paginator");
    response = await http
        .get("$BASE_URL/$search$_search&$lang&$API_KEY&rating=G&$paginator");
    return json.decode(response.body);
  }

  int _getCount(List data) {
    if (_search == null)
      return data.length;
    else
      return data.length + 1;
  }

  @override
  void initState() {
    super.initState();
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
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
                onSubmitted: (text) {
                  setState(() {
                    _search = text;
                    _offset = 0;
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: "Pesquise Aqui!")),
          ),
          Expanded(
              child: FutureBuilder(
                  future: this._getGifs(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 200.0,
                          height: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 5.0),
                        );
                      default:
                        if (snapshot.hasError)
                          return Container();
                        else
                          return _createGifTable(context, snapshot);
                    }
                  }))
        ],
      ),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (BuildContext context, int index) {
          if (_search == null || index < snapshot.data["data"].length)
            return GestureDetector(
              child: Image.network(
                  snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GifPage(snapshot.data["data"][index])));
              },
            );
          else
            Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
                onLongPress: () {
                  Share.share(snapshot.data["images"]["fixed_height"]["url"]);
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add, color: Colors.white, size: 70.0),
                      Text(
                        "Carregando mais...",
                        style: TextStyle(color: Colors.white, fontSize: 22.0),
                      )
                    ]),
              ),
            );
        });
  }
}
