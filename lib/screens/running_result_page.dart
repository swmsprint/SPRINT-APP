import 'package:flutter/material.dart';

import 'package:sprint/models/positiondata.dart';
import 'package:sprint/widgets/running_result_page/runmap.dart';
import 'package:sprint/widgets/running_result_page/runningfinishsummary.dart';
import 'package:sprint/widgets/running_result_page/runningresultappbar.dart';

class RunResult extends StatelessWidget {
  final List<PositionData> positionDataList;
  final double distance;
  final int duration;
  final double calories;
  const RunResult(
      {super.key,
      required this.positionDataList,
      required this.distance,
      required this.duration,
      required this.calories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RunningResultAppBar(),
      body: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.all(10)),
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.all(
                      0.025 * MediaQuery.of(context).size.width)),
              Text(
                DateTime.parse(positionDataList[0].timestamp)
                    .add(const Duration(hours: 9))
                    .toString()
                    .substring(0, 16),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Segoe UI',
                  color: Color(0xff5563de),
                ),
              ),
            ],
          ),
          Divider(
            indent: (0.05 * MediaQuery.of(context).size.width),
            endIndent: (0.05 * MediaQuery.of(context).size.width),
            thickness: 4,
            color: Colors.grey[300],
          ),
          const Padding(padding: EdgeInsets.all(5)),
          RunningFinishSummary(distance, duration, calories),
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
