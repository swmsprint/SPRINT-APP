import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:flutter_config/flutter_config.dart';
import 'package:sprint/models/groupweeklystat.dart';
import 'package:sprint/screens/edit_group_page.dart';
import 'package:sprint/screens/group_request_page.dart';
import 'package:sprint/services/auth_dio.dart';
import 'package:sprint/widgets/group_info_page/groupmemberlist.dart';
import 'package:sprint/widgets/group_info_page/groupprofile.dart';
import 'package:sprint/widgets/group_info_page/grouprecord.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class GroupInfoPage extends StatefulWidget {
  final int groupId;
  final int groupMemberCount;
  final bool isLeader;
  final String groupImage;
  final String groupName;
  final String groupDescription;
  const GroupInfoPage(
      {Key? key,
      required this.groupId,
      required this.groupMemberCount,
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
      appBar: AppBar(
        backgroundColor: const Color(0xfff3f5fc),
        foregroundColor: const Color(0xff5563de),
        actions: widget.isLeader
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditGroupPage(
                                groupId: widget.groupId,
                                groupMemberCount: widget.groupMemberCount,
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
                          builder: (context) => GroupRequestPage(
                                groupId: widget.groupId,
                              ),
                          fullscreenDialog: false),
                    );
                  },
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: leaveGroupAlert,
                ),
              ],
      ),
      body: FutureBuilder<dynamic>(
        future: _groupInfo,
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
                    GroupProfile(
                      groupName: snapshot.data['groupName'],
                      groupDescription: snapshot.data['groupDescription'],
                      groupPersonnel: snapshot.data['groupPersonnel'],
                    )
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
                  GroupRecord(
                      distance: _groupWeeklyStat.distance,
                      time: _groupWeeklyStat.time),
                  const Padding(padding: EdgeInsets.all(10)),
                  Divider(
                    indent: (0.075 * MediaQuery.of(context).size.width),
                    endIndent: (0.075 * MediaQuery.of(context).size.width),
                    thickness: 2,
                    color: const Color(0xff5563de),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.075)),
                      Text(
                        "그룹원 목록 (${snapshot.data['groupPersonnel']}명)",
                        style: const TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 15,
                          color: Color(0xff5563de),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  GroupMemberList(
                    groupId: widget.groupId,
                    isLeader: widget.isLeader,
                    leaderId: snapshot.data['groupLeaderId'],
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
    var dio = await authDio(context);
    final response = await dio.get(
      '$serverurl/api/user-management/group/$groupId',
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = response.data;
      setState(() {
        _groupWeeklyStat = GroupWeeklyStat.fromJson(result['groupWeeklyStat']);
      });
      return result;
    }
  }

  leaveGroup() async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');
    var response = await dio.delete(
        '$serverurl/api/user-management/group/group-member',
        data: {"groupId": widget.groupId, "userId": userID});
    if (response.statusCode == 200) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  leaveGroupAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('정말로 그룹을 탈퇴하시겠습니까?'),
              content: const Text('그룹을 탈퇴하면 다시 가입해야 합니다.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('취소', style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: leaveGroup,
                  child: const Text('확인', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
