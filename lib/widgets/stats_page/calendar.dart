import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class HMCalendar extends StatefulWidget {
  const HMCalendar({Key? key}) : super(key: key);

  @override
  State<HMCalendar> createState() => _HMCalendarState();
}

class _HMCalendarState extends State<HMCalendar> {
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
        width: MediaQuery.of(context).size.width * 0.85,
        padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
        child: HeatMapCalendar(
            defaultColor: Colors.grey[350],
            textColor: Colors.white,
            flexible: true,
            colorMode: ColorMode.opacity,
            colorsets: const {
              1: Color(0xff5563de)
            },
            datasets: {
              DateTime(2022, 8, 6): 3,
              DateTime(2022, 8, 7): 7,
              DateTime(2022, 8, 8): 10,
              DateTime(2022, 8, 9): 13,
              DateTime(2022, 8, 13): 6,
            }),
      ),
    );
  }
}
