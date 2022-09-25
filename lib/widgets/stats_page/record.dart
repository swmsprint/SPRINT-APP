import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/utils/secondstostring.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class Record extends StatefulWidget {
  final int userId;
  const Record({Key? key, required this.userId}) : super(key: key);

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  // 토글 인덱스
  late int _selectedIndex;

  late List<int> _durationList;
  late List<double> _caloriesList;
  late List<double> _distanceList;

  _getStatistics() async {
    final response = await http.get(
      Uri.parse('$serverurl:8080/api/statistics/${widget.userId}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      List<int> duration = [
        result["dailyStatistics"]["totalSeconds"].round(),
        result["weeklyStatistics"]["totalSeconds"].round(),
        result["monthlyStatistics"]["totalSeconds"].round(),
        result["yearlyStatistics"]["totalSeconds"].round(),
        result["totalStatistics"]["totalSeconds"].round()
      ];
      List<double> distance = [
        result["dailyStatistics"]["distance"],
        result["weeklyStatistics"]["distance"],
        result["monthlyStatistics"]["distance"],
        result["yearlyStatistics"]["distance"],
        result["totalStatistics"]["distance"]
      ];
      List<double> calories = [
        result["dailyStatistics"]["energy"],
        result["weeklyStatistics"]["energy"],
        result["monthlyStatistics"]["energy"],
        result["yearlyStatistics"]["energy"],
        result["totalStatistics"]["energy"]
      ];
      return ([duration, distance, calories]);
    } else {
      print("Failed : ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var result = await _getStatistics();
      setState(() {
        _selectedIndex = 0;
        _durationList = result[0];
        _distanceList = result[1];
        _caloriesList = result[2];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getStatistics(),
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
              height: 180,
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
                        "${(_distanceList[_selectedIndex] / 1000).toStringAsFixed(2)}KM",
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
                        "${secondsToString(_durationList[_selectedIndex])}\n시간",
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 14,
                          color: Color(0xff5563de),
                        ),
                      ),
                      Text(
                        "${secondsToString((_distanceList[_selectedIndex] == 0 ? 0 : 1000 * _durationList[_selectedIndex] / _distanceList[_selectedIndex]).round())}\n페이스",
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 14,
                          color: Color(0xff5563de),
                        ),
                      ),
                      Text(
                        "${_caloriesList[_selectedIndex].toStringAsFixed(2)}\n칼로리",
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 14,
                          color: Color(0xff5563de),
                        ),
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(5.0)),
                  NeumorphicToggle(
                    height: 30,
                    displayForegroundOnlyIfSelected: true,
                    selectedIndex: _selectedIndex,
                    children: [
                      ToggleElement(
                        background: const Center(
                            child: Text(
                          "일간",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        foreground: const Center(
                            child: Text(
                          "일간",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.white),
                        )),
                      ),
                      ToggleElement(
                        background: const Center(
                            child: Text(
                          "주간",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        foreground: const Center(
                            child: Text(
                          "주간",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.white),
                        )),
                      ),
                      ToggleElement(
                        background: const Center(
                            child: Text(
                          "월간",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        foreground: const Center(
                            child: Text(
                          "월간",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.white),
                        )),
                      ),
                      ToggleElement(
                        background: const Center(
                            child: Text(
                          "연간",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        foreground: const Center(
                            child: Text(
                          "연간",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.white),
                        )),
                      ),
                      ToggleElement(
                        background: const Center(
                            child: Text(
                          "통산",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        foreground: const Center(
                            child: Text(
                          "통산",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.white),
                        )),
                      )
                    ],
                    thumb: Neumorphic(
                      style: NeumorphicStyle(
                        color: const Color(0xff5563de),
                        boxShape: NeumorphicBoxShape.roundRect(
                            const BorderRadius.all(Radius.circular(12))),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedIndex = value;
                      });
                    },
                  ),
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
