import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:sprint/models/groupweeklystat.dart';
import 'package:sprint/screens/edit_group_page.dart';
import 'package:sprint/screens/group_request_page.dart';
import 'package:sprint/utils/secondstostring.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class GroupInfoPage extends StatefulWidget {
  final int groupId;
  final bool isLeader;
  final String groupImage;
  final String groupName;
  final String groupDescription;
  const GroupInfoPage(
      {Key? key,
      required this.groupId,
      required this.isLeader,
      required this.groupImage,
      required this.groupName,
      required this.groupDescription})
      : super(key: key);

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  late Future<dynamic> _groupInfo;
  late GroupWeeklyStat _groupWeeklyStat;

  @override
  void initState() {
    super.initState();
    _groupInfo = _getGroupInfo(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isLeader
          ? AppBar(
              backgroundColor: const Color(0xfff3f5fc),
              foregroundColor: const Color(0xff5563de),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditGroupPage(
                                groupId: widget.groupId,
                                groupName: widget.groupName,
                                groupDescription: widget.groupDescription,
                                groupImage: widget.groupImage,
                              ),
                          fullscreenDialog: false),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_rounded),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GroupRequestPage(),
                          fullscreenDialog: false),
                    );
                  },
                ),
              ],
            )
          : AppBar(
              backgroundColor: const Color(0xfff3f5fc),
              foregroundColor: const Color(0xff5563de),
              actions: [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () {},
                ),
              ],
            ),
      body: FutureBuilder<dynamic>(
        future: _groupInfo, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              Column(
                children: [
                  Stack(children: [
                    Center(
                      child: SizedBox(
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                        child: Image(
                          image: NetworkImage(snapshot.data['groupPicture']),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 180)),
                          Neumorphic(
                            style: const NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              depth: 8,
                              lightSource: LightSource.topLeft,
                              color: Color(0xfff3f5fc),
                            ),
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.85,
                              decoration: BoxDecoration(
                                color: const Color(0xff5563de),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      snapshot.data['groupName'],
                                      style: const TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 30,
                                        color: Color(0xffffffff),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data['groupDescription'],
                                      style: const TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 13,
                                        color: Color(0xffffffff),
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      "인원 : ${snapshot.data['groupPersonnel']} / 50 명",
                                      style: const TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 15,
                                        color: Color(0xffffffff),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const Padding(padding: EdgeInsets.all(10)),
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.075)),
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
                  const Padding(padding: EdgeInsets.all(10)),
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
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "${(_groupWeeklyStat.distance / 1000).toStringAsFixed(2)}KM",
                            style: const TextStyle(
                              fontFamily: 'Anton',
                              fontSize: 37,
                              color: Color(0xfffa7531),
                            ),
                          ),
                          Text(
                            secondsToString(_groupWeeklyStat.time.round()),
                            style: const TextStyle(
                              fontFamily: 'Anton',
                              fontSize: 37,
                              color: Color(0xfffa7531),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Divider(
                    indent: (0.075 * MediaQuery.of(context).size.width),
                    endIndent: (0.075 * MediaQuery.of(context).size.width),
                    thickness: 2,
                    color: const Color(0xff5563de),
                  ),
                ],
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('그룹 정보를 불러 오는데 실패했습니다. 다시 시도해 주세요.'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('그룹 정보를 불러오는 중...'),
              ),
            ];
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
          );
        },
      ),
    );
  }

  _getGroupInfo(groupId) async {
    final response = await http.get(
      Uri.parse('$serverurl:8080/api/user-management/group/$groupId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        _groupWeeklyStat = GroupWeeklyStat.fromJson(result['groupWeeklyStat']);
      });
      return result;
    } else {
      print("Failed : ${response.statusCode}");
    }
  }
}
