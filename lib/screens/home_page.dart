import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/utils/secondstostring.dart';
import 'package:sprint/widgets/friendrecord.dart';
import 'package:sprint/widgets/getrunningdatas.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: [
                  const Padding(padding: EdgeInsets.all(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0.075 * MediaQuery.of(context).size.width),
                      ),
                      const Text(
                        "이번주 기록",
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
                  Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
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
                                "${(rn.distance / 1000).toStringAsFixed(2)}KM",
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
                                "${secondsToString(rn.duration)}\n시간",
                                style: const TextStyle(
                                  fontFamily: 'Anton',
                                  fontSize: 14,
                                  color: Color(0xff5563de),
                                ),
                              ),
                              Text(
                                "${secondsToString((1000 * rn.duration / rn.distance).round())}\n페이스",
                                style: const TextStyle(
                                  fontFamily: 'Anton',
                                  fontSize: 14,
                                  color: Color(0xff5563de),
                                ),
                              ),
                              Text(
                                "${(60 * 2 * rn.duration / 900).toStringAsFixed(2)}\n칼로리",
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
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0.075 * MediaQuery.of(context).size.width),
                      ),
                      const Text(
                        "친구의 기록",
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
                  SizedBox(
                    height: 150,
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      slivers: <Widget>[
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: (0.075 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .width) -
                                          20)),
                              FriendRecord(),
                              FriendRecord(),
                              FriendRecord(),
                              FriendRecord(),
                              FriendRecord(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    indent: (0.075 * MediaQuery.of(context).size.width),
                    endIndent: (0.075 * MediaQuery.of(context).size.width),
                    thickness: 4,
                    color: Colors.grey[300],
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0.075 * MediaQuery.of(context).size.width),
                      ),
                      const Text(
                        "오늘의 기록",
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15,
                          color: Color(0xff5563de),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${(rn.distance / 1000).toStringAsFixed(2)}KM\n거리",
                          style: const TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 14,
                            color: Color(0xff5563de),
                          ),
                        ),
                        Text(
                          "${secondsToString(rn.duration)}\n시간",
                          style: const TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 14,
                            color: Color(0xff5563de),
                          ),
                        ),
                        Text(
                          "${secondsToString((1000 * rn.duration / rn.distance).round())}\n페이스",
                          style: const TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 14,
                            color: Color(0xff5563de),
                          ),
                        ),
                        Text(
                          "${(60 * 2 * rn.duration / 900).toStringAsFixed(2)}\n칼로리",
                          style: const TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 14,
                            color: Color(0xff5563de),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                ],
              ),
            ]),
          ),
          CharacterListView(),
        ],
      ),
    );
  }
}
