import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:async';
import 'package:wemapgl/wemapgl.dart';

class MeetUp extends StatefulWidget {
  const MeetUp() : super();

  @override
  _MeetUpState createState() => _MeetUpState();
}

class _MeetUpState extends State<MeetUp> {
  WeMapSearchAPI searchAPI = WeMapSearchAPI();
  Timer? t;

  List<WeMapPlace> result = [];
  LatLng latLng = LatLng(20.037, 105.7876);

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
                FormBuilderTextField(
                  name: "your_location",
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required(context)]),
                  style: TextStyle(color: Colors.cyan),
                  onChanged: (text) async {
                    if (t != null) t!.cancel();
                    t = Timer(Duration(seconds: 1), () async {
                      List<WeMapPlace> places = await searchAPI.getSearchResult(
                          text!, latLng, WeMapGeocoder.Pelias);
                      setState(() {
                        result = places;
                      });
                    });
                  },
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
                          color: Colors.cyan, fontWeight: FontWeight.w500)),
                ),
                SizedBox(
                  height: 30,
                ),
                FormBuilderTextField(
                  name: "friend_location",
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required(context)]),
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
                          color: Colors.cyan, fontWeight: FontWeight.w500)),
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Let's meet up",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            style: TextButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0))),
          )
        ],
      ),
    ));
  }
}
