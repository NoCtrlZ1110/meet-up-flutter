import 'dart:convert';
import 'dart:math';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/models/location/NearbyLocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wemapgl/wemapgl.dart';

class MeetMid extends StatefulWidget {
  final WeMapPlace yourLocation, friendLocation;

  const MeetMid({required this.yourLocation, required this.friendLocation})
      : super();

  @override
  _MeetMidState createState() => _MeetMidState(
      WeMapPlace(
          location: LatLng(
              (yourLocation.location!.latitude +
                      friendLocation.location!.latitude) /
                  2,
              (yourLocation.location!.longitude +
                      friendLocation.location!.longitude) /
                  2)),
      yourLocation,
      friendLocation);
}

class _MeetMidState extends State<MeetMid> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final WeMapPlace yourLocation, friendLocation;
  final WeMapPlace midLocation;
  WeMapController? mapController;
  bool myLatLngEnabled = true;
  late List<Items> nearbylocations;
  WeMapDirections directionAPI = WeMapDirections();

  int _tripDistance = 0;
  int _tripTime = 0;

  _MeetMidState(this.midLocation, this.yourLocation, this.friendLocation);

  Future<void> _onMapCreated(WeMapController controller) async {
    mapController = controller;
    addMarker(
        midLocation.location, mapController, "assets/symbols/destination.png");
    addMarker(
        yourLocation.location, mapController, "assets/symbols/origin.png");
    addMarker(
        friendLocation.location, mapController, "assets/symbols/origin.png");

    showDirection();
  }

  Future<void> addMarker(
      LatLng? latLng, WeMapController? mapController, String? iconImage) async {
    print("adding marker");
    await mapController?.addSymbol(SymbolOptions(
      geometry: latLng, // location is 0.0 on purpose for this example
      iconImage: iconImage,
      iconAnchor: "bottom",
    ));
  }

  void showDirection() async {
    List<LatLng> points = [];

    points.add(yourLocation.location!); //origin Point
    points.add(midLocation.location!); //way Point
    points.add(friendLocation.location!); //destination Point

    final json = await directionAPI.getResponseMultiRoute(
        0, points); //0 = car, 1 = bike, 2 = foot
    List<LatLng> _route = directionAPI.getRoute(json);
    List<LatLng> _waypoint = directionAPI.getWayPoints(json);

    setState(() {
      _tripDistance = directionAPI.getDistance(json);
      _tripTime = directionAPI.getTime(json);
    });

    await mapController!.addLine(
      LineOptions(
        geometry: _route,
        lineColor: "#0071bc",
        lineWidth: 5.0,
        lineOpacity: 1,
      ),
    );
    await mapController!.addCircle(CircleOptions(
        geometry: _waypoint[0],
        circleRadius: 8.0,
        circleColor: '#d3d3d3',
        circleStrokeWidth: 1.5,
        circleStrokeColor: '#0071bc'));
    for (int i = 1; i < _waypoint.length; i++) {
      await mapController!.addCircle(CircleOptions(
          geometry: _waypoint[i],
          circleRadius: 8.0,
          circleColor: '#ffffff',
          circleStrokeWidth: 1.5,
          circleStrokeColor: '#0071bc'));
    }
  }

  Future<NearbyLocation> fetchNearbyPlaces(LatLng position) async {
    final response =
        await http.get(Uri.parse(Endpoints.getNearbyPlaces(position)));

    if (response.statusCode == 200) {
      // print(jsonDecode(response.body)["results"]);
      return NearbyLocation.fromJson(jsonDecode(response.body)["results"]);
    } else {
      throw Exception('Failed to load nearby places');
    }
  }

  Widget buildDragIcon() => Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      width: 80,
      height: 4);

  void shareLocation(Items item) {
    Share.share("We will meet here: ${item.title} , ${item.vicinity} ",
        subject: "Let's meet up!");
  }

  Future<void> savePlace(Items item) async {
    final SharedPreferences prefs = await _prefs;
    final List<String>? places = prefs.getStringList("saved_places");
    if (places != null) {
      bool check = true;
      for (int i = 0; i < places.length; i++) {
        if (Items.fromJson(jsonDecode(places[i])).id == item.id) {
          check = false;
        }
      }
      if (check) {
        places.add(jsonEncode(item));
        prefs.setStringList("saved_places", places);
      }
    } else {
      prefs.setStringList("saved_places", [jsonEncode(item)]);
    }
    Fluttertoast.showToast(
      msg: "Added to your favorite places",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Color(0xFF48BF92),
    );
    print('saved');
  }

  void showTheWay(Items item, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
              body: WeMapDirection(
                originIcon: "assets/symbols/origin.png",
                destinationIcon: "assets/symbols/destination.png",
                originPlace: yourLocation,
                // destinationPlace: friendLocation,
                destinationPlace: new WeMapPlace(
                    location: new LatLng(
                        item.position.elementAt(0), item.position.elementAt(1)),
                    placeName: item.title,
                    street: item.vicinity,
                    description: item.vicinity),
              ),
            )));
  }

  @override
  void initState() {
    super.initState();
    nearbylocations = [];
    fetchNearbyPlaces(LatLng(
            (yourLocation.location!.latitude +
                    friendLocation.location!.latitude) /
                2,
            (yourLocation.location!.longitude +
                    friendLocation.location!.longitude) /
                2))
        .then((value) {
      setState(() {
        nearbylocations = value.items;
      });
      print(nearbylocations.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        parallaxEnabled: true,
        minHeight: 230,
        maxHeight: 550,
        panel: Column(
          children: [
            buildDragIcon(),
            SlidingUpTittle(),
            YourLocationInfo(yourLocation: yourLocation),
            FriendLocationInfo(friendLocation: friendLocation),
            Container(
              child: Image.asset(
                "assets/images/meet_at.png",
                width: 300,
              ),
            ),
            Container(
              height: 230,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: nearbylocations.length,
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
                          leading: Image.network(nearbylocations[index].icon),
                          title: Text(
                            nearbylocations[index].title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Container(
                            height: 70,
                            child: Text(nearbylocations[index].vicinity,
                                style: TextStyle(
                                  color: Colors.white70,
                                )),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                savePlace(nearbylocations[index]);
                              },
                              child: Icon(
                                Icons.favorite,
                                color: Colors.pink,
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.white),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showTheWay(nearbylocations[index], context);
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
                                shareLocation(nearbylocations[index]);
                              },
                              child: Icon(
                                Icons.share,
                                color: Color(0xFF48BF92),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: WeMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition:
                      CameraPosition(target: midLocation.location, zoom: 13.2),
                  myLocationEnabled: myLatLngEnabled,
                  compassEnabled: true,
                  compassViewMargins: Point(24, 550),
                  onMapClick: (point, latlng, place) async {},
                )),
          ],
        ),
      ),
    );
  }
}

class SlidingUpTittle extends StatelessWidget {
  const SlidingUpTittle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        "assets/images/app_name.png",
        width: 100,
      ),
    );
  }
}

class YourLocationInfo extends StatelessWidget {
  const YourLocationInfo({
    Key? key,
    required this.yourLocation,
  }) : super(key: key);

  final WeMapPlace yourLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: FormBuilderTextField(
        enabled: false,
        name: "your_location",
        validator: FormBuilderValidators.compose(
            [FormBuilderValidators.required(context)]),
        style: TextStyle(color: Colors.cyan),
        onChanged: (text) async {},
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.location_on,
              color: Colors.cyan,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.cyan,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.cyan,
                width: 2.0,
              ),
            ),
            labelText: yourLocation.placeName,
            hintText: "your location here",
            alignLabelWithHint: false,
            labelStyle:
                TextStyle(color: Colors.cyan, fontWeight: FontWeight.w500),
            hintStyle:
                TextStyle(color: Colors.cyan, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class FriendLocationInfo extends StatelessWidget {
  const FriendLocationInfo({
    Key? key,
    required this.friendLocation,
  }) : super(key: key);

  final WeMapPlace friendLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: FormBuilderTextField(
        enabled: false,
        name: "your_location",
        validator: FormBuilderValidators.compose(
            [FormBuilderValidators.required(context)]),
        style: TextStyle(color: Colors.cyan),
        onChanged: (text) async {},
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: Colors.cyan,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.cyan,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Colors.cyan,
                width: 2.0,
              ),
            ),
            labelText: friendLocation.placeName,
            hintText: "friend location here",
            alignLabelWithHint: false,
            labelStyle:
                TextStyle(color: Colors.cyan, fontWeight: FontWeight.w500),
            hintStyle:
                TextStyle(color: Colors.cyan, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
