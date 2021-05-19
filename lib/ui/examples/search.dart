import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wemapgl/wemapgl.dart';

import 'ePage.dart';

class SearchPage extends EPage {
  SearchPage() : super(const Icon(Icons.search), 'Search page');

  @override
  Widget build(BuildContext context) {
    return const SearchAPI();
  }
}

class SearchAPI extends StatefulWidget {
  const SearchAPI();

  @override
  State createState() => SearchAPIState();
}

class SearchAPIState extends State<SearchAPI> {
  WeMapSearchAPI searchAPI = WeMapSearchAPI();
  Timer? t;

  List<WeMapPlace> result = [];
  LatLng latLng = LatLng(20.037, 105.7876);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Search example",
        home: Scaffold(
            appBar: AppBar(
              title: Text("Search example"),
            ),
            body: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter key word to search',
                  ),
                  onChanged: (text) async {
                    if (t != null) t!.cancel();
                    t = Timer(Duration(seconds: 1), () async {
                      List<WeMapPlace> places = await searchAPI.getSearchResult(text, latLng, WeMapGeocoder.Pelias);
                      setState(() {
                        result = places;
                      });
                    });
                  },
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: result.length,
                        itemBuilder: (BuildContext ctxt, int idx) {
                          return ListTile(title: Text(result[idx].placeName ?? ""));
                        }))
              ],
            )));
  }
}
