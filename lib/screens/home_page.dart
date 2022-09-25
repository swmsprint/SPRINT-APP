import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/widgets/home_page/dailyrecord.dart';
import 'package:sprint/widgets/home_page/friendrecordlist.dart';
import 'package:sprint/widgets/home_page/weeklyrecord.dart';
import 'package:sprint/widgets/stats_page/getrunningdatas.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
                  const WeeklyRecord(),
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
                  const FriendRecordList(),
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
                  const DailyRecord(),
                  const Padding(padding: EdgeInsets.all(10)),
                  const RunningListView(
                    userId: 1,
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
