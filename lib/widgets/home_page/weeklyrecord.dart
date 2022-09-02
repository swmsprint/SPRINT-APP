import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/utils/secondstostring.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class WeeklyRecord extends StatefulWidget {
  const WeeklyRecord({Key? key}) : super(key: key);

  @override
  State<WeeklyRecord> createState() => _WeeklyRecordState();
}

class _WeeklyRecordState extends State<WeeklyRecord> {
  late int _duration;
  late double _distance;
  late double _calories;

  _getWeeklyStatistics() async {
    final response = await http.get(
      Uri.parse('$serverurl:8080/api/statistics/1'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      int duration = result["weeklyStatistics"]["totalSeconds"].round();
      double distance = result["weeklyStatistics"]["distance"];

      double calories = result["weeklyStatistics"]["energy"];

      return ([duration, distance, calories]);
    } else {
      print("Failed : ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var result = await _getWeeklyStatistics();
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
      future: _getWeeklyStatistics(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
              depth: 8,
              lightSource: LightSource.topLeft,
              color: const Color(0xffffffff),
            ),
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "총",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Segoe UI',
                          fontWeight: FontWeight.w600,
                          color: Color(0xfffa7531),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${(_distance / 1000).toStringAsFixed(2)}KM",
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 37,
                          color: Color(0xfffa7531),
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(5.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                  const Padding(padding: EdgeInsets.all(5.0)),
                ],
              ),
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
