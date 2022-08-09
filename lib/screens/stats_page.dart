import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
                            color: Colors.blue[500]),
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
        Align(
          alignment: Alignment.centerLeft,
          child: Row(children: [
            Text(
              "     Stats",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[500],
              ),
            ),
          ]),
        ),
        Container(
          height: 150,
          width: MediaQuery.of(context).size.width - 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.grey[300],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(padding: EdgeInsets.all(10.0)),
              Text(
                "Total Distance",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[500],
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                "2.1 km",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[500],
                ),
                textAlign: TextAlign.left,
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
        HeatMapCalendar(
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
        Padding(padding: EdgeInsets.all(50)),
      ]),
    );
  }
}
