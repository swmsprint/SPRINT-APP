import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:sprintf/sprintf.dart';

enum RunningStatus { running, paused, stopped }

class RunPage extends StatefulWidget {
  const RunPage({Key? key}) : super(key: key);

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  late RunningStatus _runningStatus;
  late int _timer;

  @override
  void initState() {
    super.initState();
    _runningStatus = RunningStatus.stopped;
    print(_runningStatus.toString());
    _timer = 0;
    // postUser()
  }

  void run() {
    setState(() {
      _runningStatus = RunningStatus.running;
      print("[=>] " + _runningStatus.toString());
      runTimer();
    });
  }

  void pause() {
    setState(() {
      _runningStatus = RunningStatus.paused;
      print("[=>] " + _runningStatus.toString());
    });
  }

  void resume() {
    run();
  }

  void stop() {
    setState(() {
      _timer = 0;
      _runningStatus = RunningStatus.stopped;
      print("[=>] " + _runningStatus.toString());
    });
  }

  void runTimer() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
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
          });
          break;
      }
    });
  }

  _postUser() async {
    final response =
        await http.post(Uri.parse('http://localhost:8080/api/running/start'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'user_id': 1,
            }));
    if (response.statusCode == 200) {
      print("Success");
    } else {
      print("Failed");
    }
  }

  String secondsToString(int seconds) {
    return seconds >= 3600
        ? sprintf("%d:%02d:%02d",
            [seconds ~/ 3600, (seconds ~/ 60) % 60, seconds % 60])
        : sprintf("%02d:%02d", [seconds ~/ 60, seconds % 60]);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _runningButtons = [
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
    final List<Widget> _stoppedButtons = [
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                secondsToString(_timer),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _runningStatus == RunningStatus.stopped
                ? _stoppedButtons
                : _runningButtons,
          )
        ],
      ),
    );
  }
}
