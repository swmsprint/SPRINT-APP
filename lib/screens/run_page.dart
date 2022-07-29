import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:sprint/utils/geolocator.dart';
import 'dart:convert';
import 'dart:async';
import 'package:sprintf/sprintf.dart';

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

class _RunPageState extends State<RunPage> {
  late int _runningID;
  late RunningStatus _runningStatus;
  late int _timer;
  late double _distance;
  late List<PositionData> _positionDataList;

  _postUser() async {
    final response =
        await http.post(Uri.parse('http://localhost:8080/api/running/start'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
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
        timestamp: position.timestamp.toString(),
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
      _postUser();
    }
    setState(() {
      _getCurrentLocation().then((_) {
        _runningStatus = RunningStatus.running;
        runTimer();
      });
    });
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
    _postResult().then((_) => setState(() {
          _runningStatus = RunningStatus.stopped;
          _timer = 0;
          _distance = 0;
          _positionDataList = [];
        }));
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

  String secondsToString(int seconds) {
    return seconds >= 3600
        ? sprintf("%d:%02d:%02d",
            [seconds ~/ 3600, (seconds ~/ 60) % 60, seconds % 60])
        : sprintf("%02d:%02d", [seconds ~/ 60, seconds % 60]);
  }

  @override
  void initState() {
    super.initState();
    getPermission();
    _runningStatus = RunningStatus.stopped;
    _timer = 0;
    _distance = 0;
    _positionDataList = [];
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> runningButtons = [
      ElevatedButton(
        onPressed: _runningStatus == RunningStatus.paused ? resume : pause,
        style: ElevatedButton.styleFrom(primary: Colors.blue),
        child: Text(
          _runningStatus == RunningStatus.paused ? 'Continue' : "Pause",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(20),
      ),
      ElevatedButton(
          onPressed: stop,
          style: ElevatedButton.styleFrom(primary: Colors.grey),
          child: const Text(
            'Stop',
            style: TextStyle(fontSize: 16),
          ))
    ];
    final List<Widget> stoppedButtons = [
      ElevatedButton(
          onPressed: run,
          style: ElevatedButton.styleFrom(primary: Colors.green),
          child: const Text(
            'Start',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ))
    ];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                secondsToString(_timer),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Text(
            _timer == 0
                ? ""
                : _distance < 1000
                    ? sprintf("Distance Run: %.2f m\n Pace: %.2f m/s", [
                        _distance,
                        _positionDataList[_positionDataList.length - 1].speed
                      ])
                    : sprintf("Distance Run: %.2f km\n Pace: %.2f m/s", [
                        _distance / 1000,
                        _positionDataList[_positionDataList.length - 1].speed
                      ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _runningStatus == RunningStatus.stopped
                ? stoppedButtons
                : runningButtons,
          )
        ],
      ),
    );
  }
}
