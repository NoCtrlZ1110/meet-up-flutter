part of wemapgl;

class WeMapPlaceCard extends StatefulWidget {
  final WeMapPlace? place;

  /// The callback function that is called when close this place card
  final void Function() onPlaceCardClose;

  /// Place card's padding
  final EdgeInsetsGeometry padding;

  /// Place card's BorderRadius
  final BorderRadiusGeometry borderRadius;

  /// List buttons after the direction button
  final List<Widget> buttons;

  /// On/Off the clear button, default is on (true)
  final bool showClearButton;

  /// destination Icon for Direction
  final String? destinationIcon;

  WeMapPlaceCard({
    required this.place,
    required this.onPlaceCardClose,
    this.buttons = const [],
    this.showClearButton = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.padding = const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
    this.destinationIcon,
  });

  @override
  State<StatefulWidget> createState() => _WeMapPlaceCardState();
}

class _WeMapPlaceCardState extends State<WeMapPlaceCard> {
  // String _linkMessage;
  late WeMapNavigation _directions;
  Location _des = Location(name: "hihi2", latitude: 21.033811834334458, longitude: 105.7840838429172);
  Location _ori = Location(name: "hihi", latitude: 21.033811834334458, longitude: 105.7840838429172);
  bool _arrived = false;
  late double _distanceRemaining, _durationRemaining;
  WeMapPlace? _place;

  @override
  void initState() {
    _place = widget.place;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _directions = WeMapNavigation(onRouteProgress: (arrived) async {
      _distanceRemaining = await _directions.distanceRemaining;
      _durationRemaining = await _directions.durationRemaining;

      setState(() {
        _arrived = arrived;
      });
      if (arrived) {
        await Future.delayed(Duration(seconds: 3));
        await _directions.finishNavigation();
      }
    });

    return _place == null
        ? Container()
        : Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: widget.padding,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeMapPlaceDesc(
                          destinationIcon: widget.destinationIcon,
                          place: _place,
                          buttons: widget.buttons,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 16.0, left: 16.0),
                      height: 140,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: widget.borderRadius),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            upperFirstLetter(_place!.placeName!),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(padding: EdgeInsets.only(top: 6)),
                          Text(
                            upperFirstLetter(_place!.street! + ", " + _place!.cityState!),
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(padding: EdgeInsets.only(top: 6)),
                          Container(
                            padding: EdgeInsets.zero,
                            height: 60,
                            child: ListView(
                              padding: EdgeInsets.only(bottom: 16, right: 16, top: 8),
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                    OutlineButtonCustom(
                                      icon: Icons.directions,
                                      buttonName: directionBtn,
                                      onPressed: () {
                                        WeMapPlace origin;
                                        WeMapPlace destination;
                                        print(_place?.location);
                                        weRequestLocation();

                                        final location = GPSService.Location();
                                        location.getLocation().then((locationData) {
                                          _ori = Location(
                                            name: "hihi",
                                            latitude: locationData.latitude!,
                                            longitude: locationData.longitude!,
                                          );
                                          _des = Location(
                                            name: _place?.placeName,
                                            latitude: _place?.location?.latitude,
                                            longitude: _place?.location?.longitude,
                                          );
                                          origin = WeMapPlace(
                                            location: LatLng(_ori.latitude!, _ori.longitude!),
                                            description: wemap_yourLocation,
                                          );
                                          destination = WeMapPlace(
                                            location: LatLng(_des.latitude!, _des.longitude!),
                                            description: _place?.placeName,
                                          );
                                          print(destination.description);
                                          originPlaceStream.increment(origin);
                                          destinationPlaceStream.increment(destination);
                                          fromHomeStream.increment(true);
                                          isDrivingStream.increment(true);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => WeMapDirection(
                                                destinationIcon: widget.destinationIcon,
                                                originPlace: origin,
                                                destinationPlace: destination,
                                              ),
                                            ),
                                          );
                                        });

                                        /// write your action for Direction button here
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8),
                                    ),
                                    OutlineButtonCustom(
                                      icon: Icons.navigation,
                                      buttonName: start,
                                      onPressed: () {
                                        weRequestLocation();
                                        final location = GPSService.Location();
                                        location.getLocation().then((locationData) {
                                          _ori = Location(
                                            name: "hihi",
                                            latitude: locationData.latitude,
                                            longitude: locationData.longitude,
                                          );
                                          _des = Location(
                                            name: _place?.placeName,
                                            latitude: _place?.location?.latitude,
                                            longitude: _place?.location?.longitude,
                                          );
                                          _directions.startNavigation(
                                            destination: _des,
                                            origin: _ori,
                                            mode: WeMapNavigationMode.drivingWithTraffic,
                                            simulateRoute: false,
                                          );
                                        });
                                      },
                                    )
                                  ] +
                                  widget.buttons,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              widget.showClearButton
                  ? Positioned(
                      bottom: 128,
                      right: 32.0,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white,
                        elevation: 0.6,
                        child: Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            _place = null;
                            widget.onPlaceCardClose();
                          });
                        },
                      ),
                    )
                  : Container(),
            ],
          );
  }

  ///Deep Links
// void initDynamicLinks() async {
//   final PendingDynamicLinkData data =
//       await FirebaseDynamicLinks.instance.getInitialLink();
//   final Uri deepLink = data?.link;

//   if (deepLink != null) {
//     Navigator.pushNamed(context, deepLink.path);
//   }

//   FirebaseDynamicLinks.instance.onLink(
//       onSuccess: (PendingDynamicLinkData dynamicLink) async {
//     final Uri deepLink = dynamicLink?.link;

//     if (deepLink != null) {
//       Navigator.pushNamed(context, deepLink.path);
//     }
//   }, onError: (OnLinkErrorException e) async {
//     print('onLinkError');
//     print(e.message);
//   });
// }

// Future<void> _createDynamicLink(bool short) async {
//   Uri url = Uri.parse(
//       'https://wemap.page.link/?link=https://wemap.vn/place/' +
//           _place?.placeName.toString() +
//           ',' +
//           _place?.street.toString() +
//           ',' +
//           _place?.cityState.toString() +
//           '/' +
//           _place?.location.latitude.toString() +
//           ',' +
//           _place?.location.longitude.toString() +
//           '&amv=0&apn=com.fimo.wemap_flutter&imv=0&ipn=vn.wemap.app');
//   String string1 = Uri.decodeFull(url.toString());
//   Uri url2 = Uri.parse(string1);
//   setState(() {
//     _linkMessage = url2.toString();
//     Share.share(_linkMessage);
//   });
// }
}

String upperFirstLetter(String str) {
  String fl = str[0].toUpperCase();
  String tail = str.substring(1);
  return fl + tail;
}

class OutlineButtonCustom extends OutlinedButton {
  final VoidCallback onPressed;
  final IconData? icon;
  final String? buttonName;
  final EdgeInsetsGeometry? padding;
  static final shape2 = StadiumBorder();
  static final borderSide2 = BorderSide(color: primaryColor);

  OutlineButtonCustom({
    required this.onPressed,
    this.icon,
    this.buttonName,
    this.padding,
  }) : super(
          onPressed: onPressed,
          child: Row(
            children: <Widget>[
              Icon(icon, color: primaryColor),
              SizedBox(width: 8),
              Text("$buttonName", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500))
            ],
          ),
          style: OutlinedButton.styleFrom(
            shape: shape2,
            side: borderSide2,
            backgroundColor: Colors.black,
            padding: padding,
          ),
        );
}
