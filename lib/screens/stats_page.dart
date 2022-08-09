import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:sprint/utils/secondstostring.dart';

class RunningData {
  int runnningId;
  int duration;
  double distance;
  String startTime;

  RunningData({
    required this.runnningId,
    required this.duration,
    required this.distance,
    required this.startTime,
  });
}

RunningData rn = RunningData(
    runnningId: 2,
    duration: 1609,
    distance: 4005.321413,
    startTime: "2022-08-02 07:48:26.382");

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://i.pinimg.com/736x/f9/81/d6/f981d67d2ab128e21f0ae278082d0426.jpg"))),
                ),
                Container(
                  height: 110,
                  width: 200,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      Padding(padding: EdgeInsets.all(10.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://toppng.com/uploads/preview/lightning-bolt-11549723188q9jgshmchb.png"),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10.0)),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://toppng.com/uploads/preview/lightning-bolt-11549723188q9jgshmchb.png"),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10.0)),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://toppng.com/uploads/preview/lightning-bolt-11549723188q9jgshmchb.png"),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )),
        Container(
          height: 150,
          width: MediaQuery.of(context).size.width - 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                  Text(
                    "Total Distance",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                  Text(
                    "2.1 km",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("${secondsToString(rn.duration)}\nmin"),
                  Text(
                    "${secondsToString((1000 * rn.duration / rn.distance).round())}\nAverage Pace",
                  ),
                  Text(
                    "${(60 * 2 * rn.duration / 900).toStringAsFixed(2)}\nCalories",
                  )
                ],
              ),
              ToggleSwitch(
                minWidth: 60,
                minHeight: 20,
                initialLabelIndex: 0,
                totalSwitches: 5,
                fontSize: 10,
                activeBgColor: [Colors.orange],
                labels: ['Daily', 'Weekly', 'Monthly', 'Yearly', 'All Time'],
                animate: true,
                curve: Curves.easeInOut,
                onToggle: (index) {
                  print('switched to: $index');
                },
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.all(10)),
        SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          child: HeatMapCalendar(
              defaultColor: Colors.white,
              flexible: true,
              colorMode: ColorMode.opacity,
              colorsets: const {
                1: Colors.orange
              },
              datasets: {
                DateTime(2022, 8, 6): 3,
                DateTime(2022, 8, 7): 7,
                DateTime(2022, 8, 8): 10,
                DateTime(2022, 8, 9): 13,
                DateTime(2022, 8, 13): 6,
              }),
        ),
        Padding(padding: EdgeInsets.all(10)),
        GestureDetector(
          onTap: () {
            print("Tapped");
          },
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  rn.startTime.substring(0, 16),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.left,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("${(rn.distance / 1000).toStringAsFixed(2)}\nkm"),
                    Text("${secondsToString(rn.duration)}\nmin"),
                    Text(
                      "${secondsToString((1000 * rn.duration / rn.distance).round())}\nAverage Pace",
                    ),
                    Text(
                      "${(60 * 2 * rn.duration / 900).toStringAsFixed(2)}\nCalories",
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(padding: EdgeInsets.all(50)),
      ]),
    );
  }
}
