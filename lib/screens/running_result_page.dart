import 'package:flutter/material.dart';
import 'package:sprint/main.dart';
import 'package:sprint/screens/run_page.dart';
import 'package:sprint/widgets/runmap.dart';
import 'package:sprint/widgets/runningsummary.dart';

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
        backgroundColor: const Color(0xff5563de),
        title: const Text('Summary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RootPage();
            }));
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.all(10)),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${positionDataList[0].timestamp.substring(0, 16)} ~ ${positionDataList[positionDataList.length - 1].timestamp.substring(0, 16)}",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Segoe UI',
                color: const Color(0xfffa7531),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          RunningSummary(distance, duration),
          const Padding(padding: EdgeInsets.all(10)),
          Expanded(
            child: RunResultMap(
              positionDataList: positionDataList,
            ),
          ),
        ],
      ),
    );
  }
}
