import 'package:flutter/material.dart';
import 'package:sprint/utils/secondstostring.dart';

class RunningSummary extends StatelessWidget {
  final double distance;
  final int duration;
  const RunningSummary(this.distance, this.duration);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${(distance / 1000).toStringAsFixed(2)}KM",
                  style: const TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 24,
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
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  distance == 0
                      ? "00:00"
                      : secondsToString((1000 * duration / distance).round()),
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
          ]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const Padding(
                padding: EdgeInsets.all(10),
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
