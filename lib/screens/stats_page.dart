import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/widgets/stats_page/profile.dart';
import 'package:sprint/widgets/stats_page/calendar.dart';
import 'package:sprint/widgets/stats_page/record.dart';
import 'package:sprint/widgets/stats_page/getrunningdatas.dart';

class StatsPage extends StatelessWidget {
  final int userId;
  const StatsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      Profile(userId: userId),
                      const Padding(padding: EdgeInsets.all(10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                    0.075 * MediaQuery.of(context).size.width),
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
                      Record(
                        userId: userId,
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      HMCalendar(
                        userId: userId,
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      RunningListView(
                        userId: userId,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
