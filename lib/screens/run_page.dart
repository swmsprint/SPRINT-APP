//ToDo: GPS 측정 주기 설정, 러닝 버튼 누르면 카운트다운 후 자동 시작
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_config/flutter_config.dart';

import 'package:sprint/screens/running_result_page.dart';
import 'package:sprint/services/permission.dart';
import 'package:sprint/utils/secondstostring.dart';
import 'package:sprint/widgets/run_page/currentmap.dart';
import 'package:sprint/widgets/run_page/pacemaker.dart';
import 'package:sprint/models/positiondata.dart';
import 'dart:convert';
import 'dart:async';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:sprint/widgets/run_page/runningsummary.dart';

class RunningDataStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/runningData.json');
  }

  Future<File> writeRunningData(String body) async {
    final file = await _localFile;

    // 파일 쓰기
    return file.writeAsString(body);
  }
}

enum RunningStatus { running, paused, stopped }

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

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
              ? const CurrentMap()
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
              : const PaceMaker(),
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

  _getRunningID() async {
    final response =
        await http.post(Uri.parse('$serverurl:8080/api/running/start'),
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

  _postResult() async {
    var body = jsonEncode({
      'userId': 1, //Demo user
      'runningId': _runningID,
      "distance": _distance,
      "duration": _timer,
      "runningData": _positionDataList,
    });
    final RunningDataStorage storage = RunningDataStorage();
    await storage.writeRunningData(body);

    final response =
        await http.post(Uri.parse('$serverurl:8080/api/running/finish'),
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
      _getRunningID().then((_) {
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
                    distance: _distance,
                    calories: (60 * 2 * _timer / 900),
                  ),
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
}
