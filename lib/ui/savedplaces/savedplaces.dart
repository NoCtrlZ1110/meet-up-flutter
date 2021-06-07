import 'dart:convert';

import 'package:boilerplate/models/location/NearbyLocation.dart';
import 'package:boilerplate/ui/meetup/meetup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wemapgl/wemapgl.dart';

class SavedPlaces extends StatefulWidget {
  const SavedPlaces() : super();

  @override
  _SavedPlacesState createState() => _SavedPlacesState();
}

class _SavedPlacesState extends State<SavedPlaces> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late List<Items> places;

  Future<void> getPlaces() async {
    final SharedPreferences prefs = await _prefs;
    final List<String> _places = prefs.getStringList("saved_places")!;
    List<Items> items =
        _places.map((e) => Items.fromJson(jsonDecode(e))).toList();
    setState(() {
      places = items;
    });
  }

  Future<void> deletePlaces(Items item) async {
    final SharedPreferences prefs = await _prefs;
    final List<Items> _places = [];
    final List<String> __places = [];

    for (int i = 0; i < places.length; i++) {
      if (places[i].id != item.id) {
        _places.add(places[i]);
        __places.add(jsonEncode(places[i]));
      }
    }

    setState(() {
      places = _places;
    });
    prefs.setStringList("saved_places", __places);

    Fluttertoast.showToast(
      msg: "Deleted!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
    print('saved');
  }

  void showTheWay(Items item, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
              body: WeMapDirection(
                originIcon: "assets/symbols/origin.png",
                destinationIcon: "assets/symbols/destination.png",
                destinationPlace: new WeMapPlace(
                    location: new LatLng(
                        item.position.elementAt(0), item.position.elementAt(1)),
                    placeName: item.title,
                    street: item.vicinity,
                    description: item.vicinity),
              ),
            )));
  }

  void shareLocation(Items item) {
    Share.share("We will meet here: ${item.title} , ${item.vicinity} ",
        subject: "Let's meet up!");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Favorite Places!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF48BF92),
      ),
      body: (places != null && places.length > 0)
          ? ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                return Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xFF48BF92),
                        borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Image.network(places[index].icon),
                          title: Text(places[index].title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(places[index].vicinity,
                              style: TextStyle(
                                color: Colors.white70,
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                showTheWay(places[index], context);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Get here ",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Icon(Icons.directions, color: Colors.blue)
                                ],
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.white),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                shareLocation(places[index]);
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Share ",
                                    style: TextStyle(color: Color(0xFF48BF92)),
                                  ),
                                  Icon(
                                    Icons.share,
                                    color: Color(0xFF48BF92),
                                  )
                                ],
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.white),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                deletePlaces(places[index]);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Color(0xffe7343f),
                                  )
                                ],
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ));
              })
          : Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No places save!",
                      style: TextStyle(fontSize: 25, color: Color(0xFF48BF92)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => MeetUp()));
                      },
                      child: Container(
                        width: 132,
                        child: Row(
                          children: [
                            Text(
                              "Let's ",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Image.asset(
                              "assets/images/app_name.png",
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0))),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
