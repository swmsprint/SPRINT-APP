import 'package:flutter/material.dart';
import 'package:sprint/utils/secondstostring.dart';
import 'package:sprint/models/runningdata.dart';

RunningData rn = RunningData(
    runningId: 2,
    duration: 1609,
    distance: 4005.321413,
    startTime: "2022-08-02 07:48:26.382",
    calories: 214.53);

class DailyRecord extends StatelessWidget {
  const DailyRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${(rn.distance / 1000).toStringAsFixed(2)}KM\n거리",
            style: const TextStyle(
              fontFamily: 'Anton',
              fontSize: 14,
              color: Color(0xff5563de),
            ),
          ),
          Text(
            "${secondsToString(rn.duration)}\n시간",
            style: const TextStyle(
              fontFamily: 'Anton',
              fontSize: 14,
              color: Color(0xff5563de),
            ),
          ),
          Text(
            "${secondsToString((1000 * rn.duration / rn.distance).round())}\n페이스",
            style: const TextStyle(
              fontFamily: 'Anton',
              fontSize: 14,
              color: Color(0xff5563de),
            ),
          ),
          Text(
            "${rn.calories.toStringAsFixed(2)}\n칼로리",
            style: const TextStyle(
              fontFamily: 'Anton',
              fontSize: 14,
              color: Color(0xff5563de),
            ),
          )
        ],
      ),
    );
  }
}
