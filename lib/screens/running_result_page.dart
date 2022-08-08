import 'package:flutter/material.dart';
import 'package:sprint/main.dart';
import 'package:sprint/screens/run_page.dart';
import 'package:sprint/widgets/run_map.dart';
import 'package:sprint/utils/secondstostring.dart';
import 'package:sprintf/sprintf.dart';

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
        title: Text('Summary'),
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
          Padding(padding: const EdgeInsets.all(10)),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${positionDataList[0].timestamp.substring(0, 16)} ~ ${positionDataList[positionDataList.length - 1].timestamp.substring(0, 16)}",
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Distance: ${distance.toStringAsFixed(2)} m",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Running Time \n ${secondsToString(duration)}",
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Average Pace \n ${secondsToString((1000 * duration / distance).round())}",
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Calories \n ${(60 * 2 * duration / 900).toStringAsFixed(2)}", // 나중에 체중으로 변경
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Padding(padding: const EdgeInsets.all(10)),
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
