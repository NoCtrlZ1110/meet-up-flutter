import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MeetUp extends StatefulWidget {
  const MeetUp() : super();

  @override
  _MeetUpState createState() => _MeetUpState();
}

class _MeetUpState extends State<MeetUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("Meet Up will goes here!")],
          ),
        ));
  }
}
