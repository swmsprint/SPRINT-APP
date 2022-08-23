import 'package:sprint/models/positiondata.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sprint/utils/heatmap.dart';

class RunResultMap extends StatefulWidget {
  final List<PositionData> positionDataList;
  const RunResultMap({super.key, required this.positionDataList});
  @override
  State<RunResultMap> createState() => _RunResultMapState();
}

class _RunResultMapState extends State<RunResultMap> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        //that needs a list<Polyline>
        polylines: _polyline,
        markers: _markers,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.positionDataList[0].latitude,
              widget.positionDataList[0].longitude),
          zoom: 20.0,
        ),
        mapType: MapType.normal,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    int s = widget.positionDataList.length;
    setState(() {
      _controller = controllerParam;
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(widget.positionDataList[0].timestamp),
        //_lastMapPosition is any coordinate which should be your default
        //position when map opens up
        position: LatLng(widget.positionDataList[0].latitude,
            widget.positionDataList[0].longitude),
        infoWindow: const InfoWindow(
          title: 'Start Position',
        ),
      ));

      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(widget.positionDataList[s - 1].timestamp),
        //_lastMapPosition is any coordinate which should be your default
        //position when map opens up
        position: LatLng(widget.positionDataList[s - 1].latitude,
            widget.positionDataList[s - 1].longitude),
        infoWindow: const InfoWindow(
          title: 'End Position',
        ),
      ));

      double minLat = widget.positionDataList[0].latitude;
      double minLong = widget.positionDataList[0].longitude;
      double maxLat = widget.positionDataList[0].latitude;
      double maxLong = widget.positionDataList[0].longitude;
      for (int i = 0; i < s; i++) {
        if (widget.positionDataList[i].latitude < minLat) {
          minLat = widget.positionDataList[i].latitude;
        }
        if (widget.positionDataList[i].longitude < minLong) {
          minLong = widget.positionDataList[i].longitude;
        }
        if (widget.positionDataList[i].latitude > maxLat) {
          maxLat = widget.positionDataList[i].latitude;
        }
        if (widget.positionDataList[i].longitude > maxLong) {
          maxLong = widget.positionDataList[i].longitude;
        }
        if (i != s - 1) {
          DateTime t1 = DateTime.parse(widget.positionDataList[i].timestamp);
          DateTime t2 =
              DateTime.parse(widget.positionDataList[i + 1].timestamp);
          Duration d = t2.difference(t1);
          if (d.inSeconds < 2) {
            _polyline.add(
              Polyline(
                  polylineId: PolylineId('line$i'),
                  visible: true,
                  points: [
                    LatLng(widget.positionDataList[i].latitude,
                        widget.positionDataList[i].longitude),
                    LatLng(widget.positionDataList[i + 1].latitude,
                        widget.positionDataList[i + 1].longitude)
                  ],
                  width: 5,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                  jointType: JointType.round,
                  color: speedtocolor(widget.positionDataList[i].speed)),
            );
          }
        }
      }
      _controller.moveCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(minLat, minLong),
              northeast: LatLng(maxLat, maxLong)),
          10));
    });
  }
}
