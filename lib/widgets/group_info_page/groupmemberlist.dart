import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/models/memberdata.dart';
import 'package:sprint/services/auth_dio.dart';

import 'package:flutter_config/flutter_config.dart';
import 'package:sprint/widgets/group_info_page/memberinfo.dart';


String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class GroupMemberList extends StatefulWidget {
  final int groupId;
  final int leaderId;
  final bool isLeader;
  const GroupMemberList(
      {Key? key,
      required this.groupId,
      required this.leaderId,
      required this.isLeader})
      : super(key: key);

  @override
  State<GroupMemberList> createState() => _GroupMemberListState();
}

class _GroupMemberListState extends State<GroupMemberList> {
  late int _memberCount;
  late List<MemberData> _memberList;
  late Future<dynamic> _memberData;

  @override
  void initState() {
    _memberCount = 0;
    _memberList = [];
    super.initState();
    _memberData = _getGroupMembers().then((data) {
      _memberCount = data['count'];
      for (int i = 0; i < _memberCount; i++) {
        _memberList.add(MemberData.fromJson(data['userList'][i]));
      }
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
            future: _memberData,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  Column(
                      children: _memberList
                          .map((member) => MemberInfo(
                                member: member,
                                isLeader: widget.isLeader,
                                leaderId: widget.leaderId,
                                groupId: widget.groupId,
                              ))
                          .toList()),
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
                    child: Text('그룹원 목록을 불러 오는데 실패했습니다. 다시 시도해 주세요.'),
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
                    child: Text('그룹원 목록을 불러오는 중...'),
                  ),
                ];
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: children,
              );
            },
          ),
        ],
      ),
    );
  }

  _getGroupMembers() async {
    var dio = await authDio(context);
    var response = await dio.get(
        '$serverurl/api/user-management/group/group-member/${widget.groupId}');
    if (response.statusCode == 200) {
      return response.data;
    }
  }
}
