import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/models/positiondata.dart';
import 'package:sprint/models/runningdata.dart';
import 'package:sprint/widgets/stats_page/profile.dart';
import 'package:sprint/widgets/stats_page/calendar.dart';
import 'package:sprint/widgets/stats_page/record.dart';
import 'package:sprint/widgets/stats_page/getrunningdatas.dart';

RunningData rn = RunningData(
    runnningId: 2,
    duration: 1609,
    distance: 4005.321413,
    startTime: "2022-08-02 07:48:26.382");

List<PositionData> rawdata = const [
  PositionData(
      latitude: 37.33028771,
      longitude: -122.02810514,
      altitude: 0,
      speed: 4.05,
      timestamp: "2022-08-02 07:48:26.382Z"),
  PositionData(
      latitude: 37.33028312,
      longitude: -122.02805328,
      altitude: 0,
      speed: 4.05,
      timestamp: "2022-08-02 07:48:27.310Z"),
  PositionData(
      latitude: 37.33028179,
      longitude: -122.02799851,
      altitude: 0,
      speed: 4.21,
      timestamp: "2022-08-02 07:48:28.280Z"),
  PositionData(
      latitude: 37.33027655,
      longitude: -122.02794361,
      altitude: 0,
      speed: 4.2,
      timestamp: "2022-08-02 07:48:29.391Z"),
  PositionData(
      latitude: 37.33025622,
      longitude: -122.02763446,
      altitude: 0,
      speed: 4.13,
      timestamp: "2022-08-02 07:48:35.348Z"),
  PositionData(
      latitude: 37.33025362,
      longitude: -122.02758396,
      altitude: 0,
      speed: 4.16,
      timestamp: "2022-08-02 07:48:36.377Z"),
  PositionData(
      latitude: 37.33025232,
      longitude: -122.02753387,
      altitude: 0,
      speed: 4.14,
      timestamp: "2022-08-02 07:48:37.341Z"),
  PositionData(
      latitude: 37.33025158,
      longitude: -122.02748438,
      altitude: 0,
      speed: 4.11,
      timestamp: "2022-08-02 07:48:38.296Z"),
  PositionData(
      latitude: 37.3302507,
      longitude: -122.027435,
      altitude: 0,
      speed: 4.1,
      timestamp: "2022-08-02 07:48:39.341Z"),
  PositionData(
      latitude: 37.33024596,
      longitude: -122.02719578,
      altitude: 0,
      speed: 3.91,
      timestamp: "2022-08-02 07:48:44.371Z"),
  PositionData(
      latitude: 37.33023967,
      longitude: -122.02714858,
      altitude: 0,
      speed: 4.02,
      timestamp: "2022-08-02 07:48:45.378Z"),
];

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  children: [
                    const Profile(),
                    const Padding(padding: EdgeInsets.all(10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 0.075 * MediaQuery.of(context).size.width),
                        ),
                        const Text(
                          "기록",
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 15,
                            color: Color(0xff5563de),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    const Record(),
                    const Padding(padding: EdgeInsets.all(10)),
                    const HMCalendar(),
                    const Padding(padding: EdgeInsets.all(10)),
                  ],
                ),
              ],
            ),
          ),
          const CharacterListView(),
        ],
      ),
    );
  }
}
