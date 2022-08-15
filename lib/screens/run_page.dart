//ToDo: GPS 측정 주기 설정, 러닝 버튼 누르면 카운트다운 후 자동 시작
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:sprint/screens/running_result_page.dart';
import 'package:sprint/services/permission.dart';
import 'package:sprint/utils/secondstostring.dart';
import 'package:sprint/widgets/currentmap.dart';
import 'dart:convert';
import 'dart:async';

import 'package:sprint/widgets/runningsummary.dart';

enum RunningStatus { running, paused, stopped }

class PositionData {
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final String timestamp;

  const PositionData({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.speed,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'speed': speed,
        'timestamp': timestamp
      };
}

class RunPage extends StatefulWidget {
  const RunPage({Key? key}) : super(key: key);

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> with SingleTickerProviderStateMixin {
  late int _runningID;
  late RunningStatus _runningStatus;
  late int _timer;
  late double _distance;
  late List<PositionData> _positionDataList;

  late AnimationController controller;

  _postUser() async {
    final response =
        await http.post(Uri.parse('http://localhost:8080/api/running/start'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "startTime": DateTime.now().toUtc().toString(),
              'userId': 1, //Demo user
            }));
    if (response.statusCode == 200) {
      _runningID = jsonDecode(response.body)['runningId'];
      print(_runningID);
    } else {
      print("Failed : ${response.statusCode}");
    }
  }

  // 백엔드 서버 완성된 후 Test 필요
  _postResult() async {
    var body = jsonEncode({
      'userId': 1, //Demo user
      'runningId': _runningID,
      "duration": _timer,
      "runningData": _positionDataList,
    });
    final response =
        await http.post(Uri.parse('http://localhost:8080/api/running/finish'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: body);
    if (response.statusCode == 200) {
      print("Success");
    } else {
      print("Failed : ${response.statusCode}");
    }
  }

  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _positionDataList.add(PositionData(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        speed: position.speed,
        timestamp: position.timestamp.toString().substring(0, 23),
      ));
      //Update Distance
      if (_timer > 0 && _runningStatus == RunningStatus.running) {
        _distance += Geolocator.distanceBetween(
          _positionDataList[_positionDataList.length - 1].latitude,
          _positionDataList[_positionDataList.length - 1].longitude,
          _positionDataList[_positionDataList.length - 2].latitude,
          _positionDataList[_positionDataList.length - 2].longitude,
        );
      }
    });
  }

  void run() {
    if (_timer == 0) {
      _postUser().then((_) {
        setState(() {
          _getCurrentLocation().then((_) {
            _runningStatus = RunningStatus.running;
            runTimer();
          });
        });
      });
    } else {
      setState(() {
        _getCurrentLocation().then((_) {
          _runningStatus = RunningStatus.running;
          runTimer();
        });
      });
    }
  }

  void pause() {
    setState(() {
      _runningStatus = RunningStatus.paused;
    });
  }

  void resume() {
    run();
  }

  void stop() {
    _postResult().then((_) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RunResult(
                  positionDataList: _positionDataList,
                  duration: _timer,
                  distance: _distance),
              fullscreenDialog: true),
        ));
  }

  void runTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      switch (_runningStatus) {
        case RunningStatus.paused:
          t.cancel();
          break;
        case RunningStatus.stopped:
          t.cancel();
          break;
        case RunningStatus.running:
          setState(() {
            _timer++;
            _getCurrentLocation();
          });
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getPermission();
    _runningStatus = RunningStatus.stopped;
    _timer = 0;
    _distance = 0;
    _positionDataList = [];

    controller = AnimationController(vsync: this);

    controller.repeat(min: 0.0, max: 1.0, period: const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> runningButtons = [
      NeumorphicButton(
        style: const NeumorphicStyle(
          boxShape: NeumorphicBoxShape.circle(),
          color: Colors.transparent,
        ),
        onPressed: _runningStatus == RunningStatus.paused ? resume : pause,
        padding: const EdgeInsets.all(18.0),
        child: Icon(
          _runningStatus == RunningStatus.paused
              ? Icons.play_arrow_rounded
              : Icons.pause_rounded,
          color: const Color(0xff5563de),
          size: 50,
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(20),
      ),
      NeumorphicButton(
        style: const NeumorphicStyle(
          boxShape: NeumorphicBoxShape.circle(),
          color: Colors.transparent,
        ),
        onPressed: stop,
        padding: const EdgeInsets.all(18.0),
        child: const Icon(
          Icons.stop_rounded,
          color: Color(0xff5563de),
          size: 50,
        ),
      ),
    ];

    final List<Widget> stoppedButtons = [
      NeumorphicButton(
        style: const NeumorphicStyle(
          boxShape: NeumorphicBoxShape.circle(),
          color: Colors.transparent,
        ),
        onPressed: run,
        padding: const EdgeInsets.all(18.0),
        child: const Icon(
          Icons.play_arrow_rounded,
          color: Color(0xff5563de),
          size: 50,
        ),
      ),
    ];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _runningStatus == RunningStatus.paused
              ? CurrentMap()
              : AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Neumorphic(
                        margin: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.2,
                            0,
                            MediaQuery.of(context).size.width * 0.2,
                            0),
                        style: const NeumorphicStyle(
                          boxShape: NeumorphicBoxShape.circle(),
                          color: Colors.transparent,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${(_distance / 1000).toStringAsFixed(2)}KM",
                                style: const TextStyle(
                                  color: Color(0xfffa7531),
                                  fontFamily: 'Anton',
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                secondsToString(_timer),
                                style: const TextStyle(
                                  color: Color(0xff5563de),
                                  fontFamily: 'Nirmala',
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff5563de),
                              width: 4,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                MediaQuery.of(context).size.width * 0.4))),
                      ),
                      RotationTransition(
                        turns: controller,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.05 + 10),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color(0xff5563de),
                            ),
                            height: 20.0,
                            width: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          _runningStatus == RunningStatus.paused
              ? RunningSummary(_distance, _timer)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                      Text(
                        '다음 5분은 이렇게 추천해요',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15,
                          color: const Color(0xff5563de),
                        ),
                      ),
                      Text(
                        '7"00" 페이스',
                        style: TextStyle(
                          color: Color(0xff5563de),
                          fontFamily: 'Anton',
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        '안쪽으로 10분간 달려보아요!',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15,
                          color: Color(0xff5563de),
                        ),
                      ),
                    ]),
          /*
          Text(_timer == 0
              ? ""
              : _distance < 1000
                  ? sprintf("Distance Run: %.2f m\n Pace: %.2f m/s", [
                      _distance,
                      _positionDataList[_positionDataList.length - 1].speed
                    ])
                  : sprintf("Distance Run: %.2f km\n Pace: %.2f m/s", [
                      _distance / 1000,
                      _positionDataList[_positionDataList.length - 1].speed
                    ])),
                    */
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _runningStatus == RunningStatus.stopped
                ? stoppedButtons
                : runningButtons,
          ),
          const Padding(padding: EdgeInsets.all(20)),
        ],
      ),
    );
  }
}
