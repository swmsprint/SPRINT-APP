import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:sprint/services/auth_dio.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();
String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class HMCalendar extends StatefulWidget {
  final int userId;
  const HMCalendar({Key? key, required this.userId}) : super(key: key);

  @override
  State<HMCalendar> createState() => _HMCalendarState();
}

class _HMCalendarState extends State<HMCalendar> {
  late int _year;
  late int _month;

  @override
  void initState() {
    final today = DateTime.now();
    _year = today.year;
    _month = today.month;
    super.initState();
  }

  setCalendar(int year, int month) async {
    var dio = await authDio(context);
    var response = await dio.get(
        '$serverurl/api/statistics/streak/${widget.userId}',
        queryParameters: {
          "year": year,
          "month": month,
        });
    var cal = response.data;
    Map<DateTime, int> dataset = {};
    for (int i = 0; i < cal.length; i++) {
      if (cal[i] > 0 && cal[i] < 1000) {
        dataset[DateTime(year, month, i + 1)] = 1; // 1키로 미만으로 뛴 날은 1로 처리
      } else {
        dataset[DateTime(year, month, i + 1)] = (cal[i] / 1000).round();
      }
    }
    return dataset;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setCalendar(_year, _month),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(fontSize: 15),
            ),
          );
        } else {
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
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
              child: HeatMapCalendar(
                  defaultColor: Colors.grey[350],
                  textColor: Colors.white,
                  flexible: true,
                  colorMode: ColorMode.color,
                  colorsets: const {
                    1: Color(0x6f5563de),
                    2: Color(0x7f5563de),
                    3: Color(0x8f5563de),
                    4: Color(0x9f5563de),
                    5: Color(0xaf5563de),
                    6: Color(0xbf5563de),
                    7: Color(0xcf5563de),
                    8: Color(0xdf5563de),
                    9: Color(0xef5563de),
                    10: Color(0xff5563de),
                  },
                  datasets: snapshot.data),
            ),
          );
        }
      },
    );
  }
}
