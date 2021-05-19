import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wemapgl/wemapgl.dart';

import 'ePage.dart';

class PlaceFillPage extends EPage {
  PlaceFillPage() : super(const Icon(Icons.label), 'Place fill');

  @override
  Widget build(BuildContext context) {
    return const PlaceFillBody();
  }
}

class PlaceFillBody extends StatefulWidget {
  const PlaceFillBody();

  @override
  State<StatefulWidget> createState() => PlaceFillBodyState();
}

class PlaceFillBodyState extends State<PlaceFillBody> {
  static final LatLng center = const LatLng(21.86711, 106.1947171);
  final String _fillPatternImage = "assets/fill/cat_silhouette_pattern.png";

  late WeMapController controller;
  int _fillCount = 0;
  Fill? _selectedFill;

  void _onMapCreated(WeMapController controller) {
    this.controller = controller;
    controller.onFillTapped.add(_onFillTapped);
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", _fillPatternImage);
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }

  @override
  void dispose() {
    controller.onFillTapped.remove(_onFillTapped);
    super.dispose();
  }

  void _onFillTapped(Fill fill) {
    setState(() {
      _selectedFill = fill;
    });
  }

  void _updateSelectedFill(FillOptions changes) {
    controller.updateFill(_selectedFill!, changes);
  }

  void _add() {
    controller.addFill(
      FillOptions(geometry: [
        [
          LatLng(20.81711, 105.1447171),
          LatLng(20.81711, 106.2447171),
          LatLng(21.91711, 106.2447171),
          LatLng(21.91711, 105.1447171),
        ],
        [
          LatLng(20.86711, 106.1947171),
          LatLng(21.86711, 105.1947171),
          LatLng(20.86711, 105.1947171),
          LatLng(21.86711, 106.1947171),
        ]
      ], fillColor: "#FF0000", fillOutlineColor: "#FF0000"),
    );
    setState(() {
      _fillCount += 1;
    });
  }

  void _remove() {
    controller.removeFill(_selectedFill!);
    setState(() {
      _selectedFill = null;
      _fillCount -= 1;
    });
  }

  void _changePosition() {
    //TODO: Implement change position.
  }

  void _changeDraggable() {
    bool draggable = _selectedFill?.options.draggable ?? false;

    _updateSelectedFill(FillOptions(draggable: !draggable));
  }

  Future<void> _changeFillOpacity() async {
    double current = _selectedFill?.options.fillOpacity ?? 1.0;

    _updateSelectedFill(FillOptions(fillOpacity: current < 0.1 ? 1.0 : current * 0.75));
  }

  Future<void> _changeFillColor() async {
    String current = _selectedFill?.options.fillColor ?? "#FF0000";

    _updateSelectedFill(FillOptions(fillColor: current));
  }

  Future<void> _changeFillOutlineColor() async {
    String current = _selectedFill?.options.fillOutlineColor ?? "#FF0000";

    _updateSelectedFill(FillOptions(fillOutlineColor: current));
  }

  Future<void> _changeFillPattern() async {
    String current = _selectedFill?.options.fillPattern ?? "assetImage";
    _updateSelectedFill(FillOptions(fillPattern: current));
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
                zoom: 7.0,
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
                          child: const Text('add'),
                          onPressed: (_fillCount == 12) ? null : _add,
                        ),
                        TextButton(
                          child: const Text('remove'),
                          onPressed: (_selectedFill == null) ? null : _remove,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        TextButton(
                          child: const Text('change fill-opacity'),
                          onPressed: (_selectedFill == null) ? null : _changeFillOpacity,
                        ),
                        TextButton(
                          child: const Text('change fill-color'),
                          onPressed: (_selectedFill == null) ? null : _changeFillColor,
                        ),
                        TextButton(
                          child: const Text('change fill-outline-color'),
                          onPressed: (_selectedFill == null) ? null : _changeFillOutlineColor,
                        ),
                        TextButton(
                          child: const Text('change fill-pattern'),
                          onPressed: (_selectedFill == null) ? null : _changeFillPattern,
                        ),
                        TextButton(
                          child: const Text('change position'),
                          onPressed: (_selectedFill == null) ? null : _changePosition,
                        ),
                        TextButton(
                          child: const Text('toggle draggable'),
                          onPressed: (_selectedFill == null) ? null : _changeDraggable,
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
