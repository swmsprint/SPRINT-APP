import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sprint/models/memberdata.dart';
import 'package:sprint/screens/friends_stats_page.dart';
import 'package:sprint/services/auth_dio.dart';
import 'package:sprint/utils/secondstostring.dart';

class MemberInfo extends StatelessWidget {
  final MemberData member;
  final bool isLeader;
  final int leaderId;
  final int groupId;

  getUserID() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'userID');
  }

  const MemberInfo(
      {Key? key,
      required this.member,
      required this.isLeader,
      required this.leaderId,
      required this.groupId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    changeLeader() async {
      var dio = await authDio(context);
      var response = await dio.put(
          '$serverurl/api/user-management/group/group-member/leader',
          data: {
            "groupId": groupId,
            "newGroupLeaderUserId": member.userId,
          });
      if (response.statusCode == 200) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }

    changeLeaderAlert() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text('정말로 리더를 변경하시겠습니까?'),
                content: const Text('리더를 변경하면 되돌릴 수 없습니다!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child:
                        const Text('취소', style: TextStyle(color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: changeLeader,
                    child:
                        const Text('확인', style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return FutureBuilder(
      future: getUserID(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(top: 10),
            child: Neumorphic(
              style: NeumorphicStyle(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 8,
                lightSource: LightSource.topLeft,
                color: const Color(0xfff3f5fc),
              ),
              child: Container(
                width: (0.8 * MediaQuery.of(context).size.width),
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FriendsStatsPage(
                                userId: member.userId,
                                userNickName: member.nickname,
                                showActions:
                                    int.parse(snapshot.data) == member.userId
                                        ? false
                                        : true,
                              ),
                          fullscreenDialog: false),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(member.profile),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.nickname,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff5563de),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                "뛴 거리\n${(member.distance / 1000).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xff5563de),
                                ),
                              ),
                              const VerticalDivider(
                                color: Colors.black,
                                thickness: 1,
                              ),
                              Text(
                                "뛴 시간\n${secondsToString((member.seconds).round())}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xff5563de),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      isLeader && member.userId != leaderId
                          ? TextButton(
                              onPressed: changeLeaderAlert,
                              child: const Text("리더 변경하기",
                                  style: TextStyle(
                                      color: Color(0xff5563de),
                                      fontWeight: FontWeight.bold)),
                            )
                          : member.userId == leaderId
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.engineering,
                                    color: Color(0xff5563de),
                                  ),
                                  onPressed: () {},
                                )
                              : Container(),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Text('Loading...');
        }
      },
    );
  }
}
