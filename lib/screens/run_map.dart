import 'run_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sprint/utils/heatmap.dart';

class RunMap extends StatefulWidget {
  final List<PositionData> positionDataList;
  const RunMap({super.key, required this.positionDataList});
  @override
  State<RunMap> createState() => _RunMapState();
}

class _RunMapState extends State<RunMap> {
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

      for (int i = 0; i < s - 1; i++) {
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
    });
  }
}
