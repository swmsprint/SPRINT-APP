import 'package:flutter/material.dart';
import 'package:sprint/main.dart';
import 'package:sprint/screens/run_page.dart';
import 'package:sprint/screens/run_map.dart';

class RunResult extends StatelessWidget {
  final List<PositionData> positionDataList;
  final double distance;
  final int duration;
  const RunResult(
      {super.key,
      required this.positionDataList,
      required this.distance,
      required this.duration});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RootPage();
            }));
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(30)),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Distance: $distance m',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Average Speed: ${distance / duration} m/s',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Time: $duration seconds',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            width: 300,
            height: 500,
            child: RunMap(
              positionDataList: positionDataList,
            ),
          ),
        ],
      ),
    );
    //MapSample(positionDataList: positionDataList);
  }
}
