import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wemapgl/wemapgl.dart';

import 'ePage.dart';

class PlaceGeoJSONPage extends EPage {
  PlaceGeoJSONPage() : super(const Icon(Icons.add_location_alt), 'Place GeoJSON');

  @override
  Widget build(BuildContext context) {
    return const PlaceGeoJSONBody();
  }
}

class PlaceGeoJSONBody extends StatefulWidget {
  const PlaceGeoJSONBody();

  @override
  State<StatefulWidget> createState() => PlaceGeoJSONBodyState();
}

class PlaceGeoJSONBodyState extends State<PlaceGeoJSONBody> {
  static final LatLng center = const LatLng(21.86711, 106.1947171);
  final String _multiPointString = "assets/geojson/ne_10m_ports.geojson";
  final String _multiPolygonURL = "https://wemap-project.github.io/WeMap-Web-SDK-Release/demo/data/data.geojson";

  late WeMapController controller;

  void _onMapCreated(WeMapController controller) {
    this.controller = controller;
  }

  void _onStyleLoaded() {}

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addPoint() async {
    controller.addGeoJSON(GeoJSONOptions(geoJson: _multiPointString, type: GeoJSONOptions.POINT, circleColor: "#FF0000"));
  }

  void _addPolyline() {
    controller.addGeoJSON(GeoJSONOptions(
      geoJson: _multiPolygonURL,
      type: GeoJSONOptions.POLYLINE,
      lineColor: "#ff0000",
      lineWidth: 2,
      lineOpacity: 1,
    ));
  }

  void _addPolygon() {
    controller.addGeoJSON(GeoJSONOptions(geoJson: _multiPolygonURL, type: GeoJSONOptions.POLYGOL, fillColor: "#FF0000", fillOutlineColor: "#FF0000"));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: WeMap(
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoaded,
              initialCameraPosition: const CameraPosition(
                target: LatLng(21.852, 105.211),
                zoom: 3,
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        TextButton(
                          child: const Text('add Point'),
                          onPressed: _addPoint,
                        ),
                        TextButton(
                          child: const Text('add Polyline'),
                          onPressed: _addPolyline,
                        ),
                        TextButton(
                          child: const Text('add Polygon'),
                          onPressed: _addPolygon,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
