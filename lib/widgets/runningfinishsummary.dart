import 'package:flutter/material.dart';
import 'package:sprint/utils/secondstostring.dart';

class RunningFinishSummary extends StatelessWidget {
  late String starttime;
  late String endtime;
  late double distance;
  late int duration;
  RunningFinishSummary(this.distance, this.duration);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${(distance / 1000).toStringAsFixed(2)}KM",
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 37,
                      color: Color(0xff5563de),
                      letterSpacing: 2.568,
                    ),
                  ),
                  const Text(
                    "거리",
                    style: TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 15,
                      color: Color(0xff5563de),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    secondsToString((1000 * duration / distance).round()),
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 24,
                      color: Color(0xff5563de),
                      letterSpacing: 2.568,
                    ),
                  ),
                  const Text(
                    "페이스",
                    style: TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 15,
                      color: Color(0xff5563de),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    secondsToString(duration),
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 24,
                      color: Color(0xff5563de),
                      letterSpacing: 2.568,
                    ),
                  ),
                  const Text(
                    "시간",
                    style: TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 15,
                      color: Color(0xff5563de),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (60 * 2 * duration / 900).toStringAsFixed(2),
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 24,
                      color: Color(0xff5563de),
                      letterSpacing: 2.568,
                    ),
                  ),
                  const Text(
                    "칼로리",
                    style: TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 15,
                      color: Color(0xff5563de),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
