import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final WeMapPlace yourLocation, friendLocation;
  final WeMapPlace midLocation;
  WeMapController? mapController;
  bool myLatLngEnabled = true;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Column(
              children: [
                Text("You: ${yourLocation.placeName}"),
                Text("Latlong: ${yourLocation.location}"),
                Text("Friend: ${friendLocation.placeName}"),
                Text("Latlong: ${friendLocation.location}"),
                Text(
                    "Mid Point: LatLng(${(yourLocation.location!.latitude + friendLocation.location!.latitude) / 2}, ${(yourLocation.location!.longitude + friendLocation.location!.longitude) / 2})"),
              ],
            ),
          ),
          Container(
              height: 500,
              child: WeMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: midLocation.location, zoom: 14.0),
                myLocationEnabled: myLatLngEnabled,
                compassEnabled: true,
                compassViewMargins: Point(24, 550),
                onMapClick: (point, latlng, place) async {},
              )),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.cyan),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Save location",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.cyan),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Share",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.cyan),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
