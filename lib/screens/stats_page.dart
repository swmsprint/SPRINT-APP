import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/services/auth_dio.dart';
import 'package:sprint/widgets/stats_page/profile.dart';
import 'package:sprint/widgets/stats_page/calendar.dart';
import 'package:sprint/widgets/stats_page/record.dart';
import 'package:sprint/widgets/stats_page/getrunningdatas.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_config/flutter_config.dart';

const storage = FlutterSecureStorage();

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class StatsPage extends StatefulWidget {
  final int userId;
  final bool showActions;
  const StatsPage({Key? key, required this.userId, required this.showActions})
      : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final _reportReasonList = ['부적절한 프로필 사진', '부적절한 닉네임', '어뷰징 의심', '기타'];
  var _reportReason = '';
  @override
  void initState() {
    _reportReason = _reportReasonList[3];
    super.initState();
  }

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Profile(userId: widget.userId),
                          !widget.showActions
                              ? const Spacer()
                              : Row(
                                  children: [
                                    Neumorphic(
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.concave,
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            BorderRadius.circular(12)),
                                        depth: 8,
                                        lightSource: LightSource.topLeft,
                                      ),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                              Icons.report_gmailerrorred_sharp),
                                          onPressed: reportAlert,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 8, right: 8),
                                    ),
                                    Neumorphic(
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.concave,
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            BorderRadius.circular(12)),
                                        depth: 8,
                                        lightSource: LightSource.topLeft,
                                      ),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.block),
                                          onPressed: blockAlert,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 0.075 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .width),
                                    ),
                                  ],
                                ),
                        ],
                      ),
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
                        userId: widget.userId,
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      HMCalendar(
                        userId: widget.userId,
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                    ],
                  ),
                ],
              ),
            ),
            RunningListView(
              userId: widget.userId,
            ),
            const SliverPadding(padding: EdgeInsets.only(top: 100)),
          ],
        ),
      ),
    );
  }

  reportAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('신고하기'),
              content: DropdownButton(
                value: _reportReason,
                items: _reportReasonList.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _reportReason = value!;
                  });
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('취소', style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () => report(_reportReason),
                  child: const Text('확인', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  report(String reportReason) async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');
    var response = await dio.post('$serverurl/api/user-management/report',
        data: {
          "message": reportReason,
          "sourceUserId": userID,
          "targetUserId": widget.userId
        });
    if (response.statusCode == 200) {
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  blockAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('차단하기'),
          content: const Text('차단하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('확인', style: TextStyle(color: Colors.red)),
              onPressed: () => block(),
            ),
          ],
        );
      },
    );
  }

  block() async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');
    var response = await dio.post('$serverurl/api/user-management/block',
        data: {"sourceUserId": userID, "targetUserId": widget.userId});
    if (response.statusCode == 200) {
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}
