import 'package:boilerplate/ui/examples/full_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wemapgl/wemapgl.dart';

class MeetMid extends StatefulWidget {
  final WeMapPlace yourLocation, friendLocation;

  const MeetMid({required this.yourLocation, required this.friendLocation})
      : super();

  @override
  _MeetMidState createState() => _MeetMidState();
}

class _MeetMidState extends State<MeetMid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Column(
              children: [
                Text("You: ${widget.yourLocation.placeName}"),
                Text("Latlong: ${widget.yourLocation.location}"),
                Text("Friend: ${widget.friendLocation.placeName}"),
                Text("Latlong: ${widget.friendLocation.location}"),
                Text("Mid Point"),
                Text("Lat: ${(widget.yourLocation.location!.latitude + widget.friendLocation.location!.latitude )/2}"),
                Text("Long: ${(widget.yourLocation.location!.longitude + widget.friendLocation.location!.longitude )/2}"),

              ],
            ),
          ),
          Container(
            height: 500,

            child: FullMapPage(),)

        ],
      ),
    );
  }
}
