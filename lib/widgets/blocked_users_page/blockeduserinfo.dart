import 'package:flutter/material.dart';
import 'package:sprint/models/userdata.dart';
import 'package:sprint/services/auth_dio.dart';

import 'package:flutter_config/flutter_config.dart';
import 'package:sprint/screens/friends_stats_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

  const storage = FlutterSecureStorage();

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class BlockedUserInfo extends StatelessWidget {
  final UserData user;
  final Function() unBlock;
  const BlockedUserInfo({Key? key, required this.user, required this.unBlock})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    deleteBlockedUser(targetUserId, reduceUserCount) async {
      var dio = await authDio(context);
      final userID = await storage.read(key: 'userID');
      final response =
          await dio.delete('$serverurl/api/user-management/block', data: {
        "sourceUserId": userID,
        "targetUserId": targetUserId,
      });
      if (response.statusCode == 200) {
        reduceUserCount();
      }
    }

    return SizedBox(
      width: 0.85 * MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(5)),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendsStatsPage(
                              userId: user.userId,
                              userNickName: user.nickname,
                              showActions: false,
                            ),
                        fullscreenDialog: false),
                  );
                },
                child: Row(children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.profile,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.nickname,
                        style: const TextStyle(
                          color: Color(0xff5563de),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                    ],
                  ),
                ]),
              ),
              const Spacer(),
              TextButton(
                child: const Text(
                  "해제",
                  style: TextStyle(
                    color: Color(0xff5563de),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  deleteBlockedUser(user.userId, unBlock);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
