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
              DateTime(2022, 7, 20): 3,
              DateTime(2022, 7, 23): 6,
              DateTime(2022, 7, 24): 4,
              DateTime(2022, 7, 25): 8,
              DateTime(2022, 7, 26): 2,
              DateTime(2022, 7, 29): 9,
              DateTime(2022, 8, 1): 4,
              DateTime(2022, 8, 6): 5,
              DateTime(2022, 8, 7): 6,
              DateTime(2022, 8, 8): 5,
              DateTime(2022, 8, 9): 4,
              DateTime(2022, 8, 13): 5,
              DateTime(2022, 8, 15): 8,
              DateTime(2022, 8, 17): 2,
              DateTime(2022, 8, 19): 4,
              DateTime(2022, 8, 21): 3,
              DateTime(2022, 8, 24): 3,
            }),
      ),
    );
  }
}
