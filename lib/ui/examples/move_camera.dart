import 'package:flutter/material.dart';
import 'package:wemapgl/wemapgl.dart';

import 'ePage.dart';

class MoveCameraPage extends EPage{
  MoveCameraPage() : super(const Icon(Icons.map), 'Camera control');

  @override
  Widget build(BuildContext context) {
    return const MoveCamera();
  }
}

class MoveCamera extends StatefulWidget {
  const MoveCamera();

  @override
  State createState() => MoveCameraState();
}

class MoveCameraState extends State<MoveCamera> {
  late WeMapController mapController;

  void _onMapCreated(WeMapController controller) {
    mapController = controller;
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
              initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(
                      CameraUpdate.newCameraPosition(
                        const CameraPosition(
                          bearing: 270.0,
                          target: LatLng(20.5160895, 105.1294527),
                          tilt: 30.0,
                          zoom: 17.0,
                        ),
                      ),
                    );
                  },
                  child: const Text('newCameraPosition'),
                ),
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(CameraUpdate.newLatLng(const LatLng(20.1725505, 105.1850512)));
                  },
                  child: const Text('newLatLng'),
                ),
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(
                      CameraUpdate.newLatLngBounds(
                        LatLngBounds(
                          southwest: const LatLng(20.483935, 105.248673),
                          northeast: const LatLng(20.982446, 105.823821),
                        ),
                      ),
                    );
                  },
                  child: const Text('newLatLngBounds'),
                ),
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(CameraUpdate.newLatLngZoom(const LatLng(20.4231613, 105.087159), 11.0));
                  },
                  child: const Text('newLatLngZoom'),
                ),
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(CameraUpdate.scrollBy(150.0, -225.0));
                  },
                  child: const Text('scrollBy'),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(CameraUpdate.zoomBy(-0.5, const Offset(30.0, 20.0)));
                  },
                  child: const Text('zoomBy with focus'),
                ),
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(CameraUpdate.zoomBy(-0.5));
                  },
                  child: const Text('zoomBy'),
                ),
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(CameraUpdate.zoomIn());
                  },
                  child: const Text('zoomIn'),
                ),
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(CameraUpdate.zoomOut());
                  },
                  child: const Text('zoomOut'),
                ),
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(CameraUpdate.zoomTo(16.0));
                  },
                  child: const Text('zoomTo'),
                ),
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(CameraUpdate.bearingTo(45.0));
                  },
                  child: const Text('bearingTo'),
                ),
                TextButton(
                  onPressed: () {
                    mapController.moveCamera(CameraUpdate.tiltTo(30.0) );
                  },
                  child: const Text('tiltTo'),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
