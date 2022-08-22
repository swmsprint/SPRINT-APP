import 'package:flutter/material.dart';
import 'package:sprint/utils/secondstostring.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class DailyRecord extends StatefulWidget {
  const DailyRecord({Key? key}) : super(key: key);

  @override
  State<DailyRecord> createState() => _DailyRecordState();
}

class _DailyRecordState extends State<DailyRecord> {
  late int _duration;
  late double _distance;
  late double _calories;

  _getDailyStatistics() async {
    final response = await http.get(
      Uri.parse('$serverurl:8080/api/statistics/1'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      int duration = result["dailyStatistics"]["totalSeconds"].round();
      double distance = result["dailyStatistics"]["distance"];

      double calories = result["dailyStatistics"]["energy"];

      return ([duration, distance, calories]);
    } else {
      print("Failed : ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var result = await _getDailyStatistics();
      setState(() {
        _duration = result[0];
        _distance = result[1];
        _calories = result[2];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDailyStatistics(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${(_distance / 1000).toStringAsFixed(2)}KM\n거리",
                  style: const TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 14,
                    color: Color(0xff5563de),
                  ),
                ),
                Text(
                  "${secondsToString(_duration)}\n시간",
                  style: const TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 14,
                    color: Color(0xff5563de),
                  ),
                ),
                Text(
                  "${secondsToString((1000 * _duration / _distance).round())}\n페이스",
                  style: const TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 14,
                    color: Color(0xff5563de),
                  ),
                ),
                Text(
                  "${_calories.toStringAsFixed(2)}\n칼로리",
                  style: const TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 14,
                    color: Color(0xff5563de),
                  ),
                )
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

/*
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
*/