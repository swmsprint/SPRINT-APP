import 'package:flutter/material.dart';
import 'package:sprint/models/pacemakerstats.dart';
import 'package:sprint/utils/secondstostring.dart';

class PaceMaker extends StatefulWidget {
  final int pacemakerLevel;
  final int time;
  final double distance;
  const PaceMaker(
      {Key? key,
      required this.pacemakerLevel,
      required this.time,
      required this.distance})
      : super(key: key);

  @override
  State<PaceMaker> createState() => _PaceMakerState();
}

class _PaceMakerState extends State<PaceMaker> {
  late bool isRun;
  late double previousDistance;
  late int previousTime;
  late int cycle;

  @override
  void initState() {
    isRun = true;
    previousDistance = 0;
    previousTime = 0;
    cycle = pacemakerStats[widget.pacemakerLevel]["Run_Seconds"]! +
        pacemakerStats[widget.pacemakerLevel]["Rest_Seconds"]!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.time % cycle == 0) {
      isRun = true;
      previousDistance = widget.distance;
      previousTime = widget.time;
    }
    if (widget.time % cycle ==
        pacemakerStats[widget.pacemakerLevel]["Run_Seconds"]) {
      isRun = false;
      previousDistance = widget.distance;
      previousTime = widget.time;
    }

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        '[페이스메이커 레벨 ${widget.pacemakerLevel}]',
        style: const TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 18,
          color: Color(0xff5563de),
        ),
      ),
      const Padding(padding: EdgeInsets.all(5)),
      Text(
        isRun ? "힘껏 달리기" : "잠시 휴식하기",
        style: const TextStyle(
          color: Color(0xff5563de),
          fontFamily: 'YDIYGO',
          fontSize: 25,
        ),
      ),
      Text(
        isRun
            ? secondsToString(
                pacemakerStats[widget.pacemakerLevel]["Run_Pace"]!)
            : secondsToString(
                pacemakerStats[widget.pacemakerLevel]["Rest_Pace"]!),
        style: const TextStyle(
          color: Color(0xfffa7531),
          fontFamily: 'Anton',
          fontSize: 30,
        ),
      ),
      Text(
        isRun
            ? pacemakerStats[widget.pacemakerLevel]["Run_Seconds"]! % 6 == 0
                ? '페이스로 ${(pacemakerStats[widget.pacemakerLevel]["Run_Seconds"]! / 60).round().toString()}분간 달려보아요!'
                : '페이스로 ${(pacemakerStats[widget.pacemakerLevel]["Run_Seconds"]! / 60).round().toString()}분 ${(pacemakerStats[widget.pacemakerLevel]["Run_Seconds"]! % 60)}초간 달려보아요!'
            : pacemakerStats[widget.pacemakerLevel]["Rest_Seconds"]! % 6 == 0
                ? '페이스로 ${(pacemakerStats[widget.pacemakerLevel]["Rest_Seconds"]! / 60).round().toString()}분간 천천히 휴식해보아요!'
                : '페이스로 ${(pacemakerStats[widget.pacemakerLevel]["Rest_Seconds"]! / 60).round().toString()}분 ${(pacemakerStats[widget.pacemakerLevel]["Rest_Seconds"]! % 60) == 0}초간 천천히 휴식해보아요!',
        style: const TextStyle(
          fontFamily: 'YDIYGO',
          fontSize: 22,
          color: Color(0xff5563de),
        ),
      ),
      const Padding(padding: EdgeInsets.all(5)),
      Text(
        widget.distance == previousDistance
            ? ""
            : isRun
                ? ((1000 *
                                (widget.time - previousTime) ~/
                                (widget.distance - previousDistance)) -
                            pacemakerStats[widget.pacemakerLevel]["Run_Pace"]! <
                        -30)
                    ? "현재 페이스는 ${secondsToString(1000 * (widget.time - previousTime) ~/ (widget.distance - previousDistance))}입니다.\n무리하시는 것 아닌가요?\n조금 더 천천히 뛰어보세요!"
                    : ((1000 *
                                    (widget.time - previousTime) ~/
                                    (widget.distance - previousDistance)) -
                                pacemakerStats[widget.pacemakerLevel]
                                    ["Run_Pace"]! >
                            30)
                        ? "현재 페이스는 ${secondsToString(1000 * (widget.time - previousTime) ~/ (widget.distance - previousDistance))}입니다.\n조금 더 빠르게 뛰어보세요!\n할 수 있어요!"
                        : "현재 페이스는 ${secondsToString(1000 * (widget.time - previousTime) ~/ (widget.distance - previousDistance))}입니다.\n잘 하고 있어요! "
                : ((1000 *
                                (widget.time - previousTime) ~/
                                (widget.distance - previousDistance)) -
                            pacemakerStats[widget.pacemakerLevel]
                                ["Rest_Pace"]! <
                        -30)
                    ? "현재 페이스는 ${secondsToString(1000 * (widget.time - previousTime) ~/ (widget.distance - previousDistance))}입니다.\n잠시 휴식해보는건 어떠신가요?"
                    : "현재 페이스는 ${secondsToString(1000 * (widget.time - previousTime) ~/ (widget.distance - previousDistance))}입니다.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'YDIYGO',
          fontSize: 16,
          color: widget.distance == previousDistance
              ? Colors.transparent
              : isRun
                  ? ((1000 *
                                  (widget.time - previousTime) ~/
                                  (widget.distance - previousDistance)) -
                              pacemakerStats[widget.pacemakerLevel]
                                  ["Run_Pace"]! <
                          -30)
                      ? Colors.orange
                      : ((1000 *
                                      (widget.time - previousTime) ~/
                                      (widget.distance - previousDistance)) -
                                  pacemakerStats[widget.pacemakerLevel]
                                      ["Run_Pace"]! >
                              30)
                          ? Colors.red
                          : Colors.green
                  : ((1000 *
                                  (widget.time - previousTime) ~/
                                  (widget.distance - previousDistance)) -
                              pacemakerStats[widget.pacemakerLevel]
                                  ["Rest_Pace"]! <
                          -30)
                      ? Colors.orange
                      : Colors.green,
        ),
      )
    ]);
  }
}
