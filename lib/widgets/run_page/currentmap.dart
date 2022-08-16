import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentMap extends StatefulWidget {
  const CurrentMap({Key? key}) : super(key: key);

  @override
  State<CurrentMap> createState() => _CurrentMapState();
}

class _CurrentMapState extends State<CurrentMap> {
  late GoogleMapController _controller;
  late Position _currentPosition;

  void _onMapCreated(GoogleMapController controllerParam) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _controller = controllerParam;
      _currentPosition = position;
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target:
                  LatLng(_currentPosition.latitude, _currentPosition.longitude),
              zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.503618, 127.044836),
          zoom: 20.0,
        ),
        mapType: MapType.normal,
        myLocationEnabled: true,
      ),
    );
  }
}
