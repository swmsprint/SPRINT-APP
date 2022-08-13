import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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

class Record extends StatefulWidget {
  const Record({Key? key}) : super(key: key);

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  // 토글 인덱스
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                  "2.1 km",
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
                //Todo: 데이터 새로 받아오기
              },
            ),
          ],
        ),
      ),
    );
  }
}
