import 'package:boilerplate/ui/meetup/meetmid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:async';
import 'package:wemapgl/wemapgl.dart';

class MeetUp extends StatefulWidget {
  const MeetUp() : super();

  @override
  _MeetUpState createState() => _MeetUpState();
}

class _MeetUpState extends State<MeetUp> {
  WeMapSearchAPI searchAPI = WeMapSearchAPI();
  Timer? t, t2;
  bool b = false , b2 = false;
  WeMapPlace yourLocation = new WeMapPlace();
  WeMapPlace friendLocation = new WeMapPlace();
  List<WeMapPlace> result = [];
  List<WeMapPlace> result2 = [];

  LatLng latLng = LatLng(21.0382375, 105.7805189);
  final TextEditingController _yourLocationController = TextEditingController();
  final TextEditingController _friendLocationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Image(
              height: 200,
              image: AssetImage("assets/icons/ic_launcher.png"),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      autofocus: true,
                      style: TextStyle(color: Colors.cyan),
                      controller: _yourLocationController,
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
                          labelText: "Your location",
                          hintText: "Enter your location here",
                          alignLabelWithHint: false,
                          labelStyle: TextStyle(
                              color: Colors.cyan, fontWeight: FontWeight.w500),
                          hintStyle: TextStyle(
                              color: Colors.cyan,
                              fontWeight: FontWeight.w500))),
                  suggestionsCallback: (text) async {
                    if (t != null) t!.cancel();
                    t = Timer(Duration(milliseconds: 500), () async {
                      List<WeMapPlace> places = await searchAPI.getSearchResult(
                          text, latLng, WeMapGeocoder.Pelias);
                      setState(() {
                        result = places;
                      });
                    });
                    return result;
                  },
                  itemBuilder: (context, WeMapPlace suggestion) {
                    return ListTile(
                      minLeadingWidth: 30,
                      leading: Icon(Icons.location_on),
                      title: Text('${suggestion.placeName}'),
                      subtitle: Text('${suggestion.description}'),
                    );
                  },
                  onSuggestionSelected: (WeMapPlace suggestion) {
                    setState(() {
                      yourLocation = suggestion;
                      b = true;
                    });
                    _yourLocationController.text = suggestion.placeName!;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      autofocus: true,
                      controller: _friendLocationController,
                      style: TextStyle(color: Colors.cyan),
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
                          labelText: "Friend's location",
                          hintText: "Where is your friend living?",
                          alignLabelWithHint: false,
                          labelStyle: TextStyle(
                              color: Colors.cyan, fontWeight: FontWeight.w500),
                          hintStyle: TextStyle(
                              color: Colors.cyan,
                              fontWeight: FontWeight.w500))),
                  suggestionsCallback: (text) async {
                    if (t2 != null) t2!.cancel();
                    t2 = Timer(Duration(milliseconds: 500), () async {
                      List<WeMapPlace> places = await searchAPI.getSearchResult(
                          text, latLng, WeMapGeocoder.Pelias);
                      setState(() {
                        result2 = places;
                      });
                    });
                    return result2;
                  },
                  itemBuilder: (context, WeMapPlace suggestion) {
                    return ListTile(
                      minLeadingWidth: 30,
                      leading: Icon(Icons.location_on_outlined),
                      title: Text('${suggestion.placeName}'),
                      subtitle: Text('${suggestion.description}'),
                    );
                  },
                  onSuggestionSelected: (WeMapPlace suggestion) {
                    setState(() {
                      friendLocation = suggestion;
                      b2 = true;
                    });
                    _friendLocationController.text = suggestion.placeName!;
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () {
              if ( b&&b2 ) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MeetMid(
                        yourLocation: yourLocation,
                        friendLocation: friendLocation)));
              }
            },
            child: Text(
              "Let's meet up",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            style: TextButton.styleFrom(
                backgroundColor: b&&b2 ? Colors.cyan : Colors.grey,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0))),
          )
        ],
      ),
    ));
  }
}
