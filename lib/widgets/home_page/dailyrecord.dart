import 'package:flutter/material.dart';
import 'package:sprint/utils/secondstostring.dart';
import 'package:sprint/services/auth_dio.dart';

import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();
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
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');
    final response = await dio.get('$serverurl:8080/api/statistics/$userID');
    if (response.statusCode == 200) {
      Map<String, dynamic> result = response.data;
      int duration = result["dailyStatistics"]["totalSeconds"].round();
      double distance = result["dailyStatistics"]["distance"];
      double calories = result["dailyStatistics"]["energy"];
      return ([duration, distance, calories]);
    }
  }

  @override
  void initState() {
    super.initState();
    _duration = 0;
    _distance = 0;
    _calories = 0;
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
                  "${secondsToString((_distance == 0 ? 0 : 1000 * _duration / _distance).round())}\n페이스",
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
