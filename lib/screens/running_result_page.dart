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
      body: Column(
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(30)),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Distance: $distance miles',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Average Speed: ${distance / duration} miles per hour',
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
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RootPage();
                }));
              },
              child: Text('Exit')),
          Expanded(
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
