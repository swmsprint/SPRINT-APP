import 'package:flutter/material.dart';
import 'package:sprint/models/frienddata.dart';

import 'package:flutter_config/flutter_config.dart';
import 'package:sprint/services/auth_dio.dart';

import 'package:sprint/screens/friends_stats_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class RecievedRequestInfo extends StatelessWidget {
  final FriendData friend;
  final Function() acceptRequest;
  final Function() denyRequest;
  const RecievedRequestInfo(
      {Key? key,
      required this.friend,
      required this.acceptRequest,
      required this.denyRequest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    respondFriendRequest(targetUserId, acceptance) async {
      var dio = await authDio(context);
      final userID = await storage.read(key: 'userID');

      await dio.put('$serverurl/api/user-management/friend', data: {
        "friendState": acceptance,
        "sourceUserId": userID,
        'targetUserId': targetUserId,
      });
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
                                userId: friend.userId,
                                userNickName: friend.nickname,
                                showActions: true,
                              ),
                          fullscreenDialog: false),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          friend.profile,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            friend.nickname,
                            style: const TextStyle(
                              color: Color(0xff5563de),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(5)),
                        ],
                      ),
                    ],
                  )),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.check,
                  color: Color(0xff5563de),
                ),
                onPressed: () {
                  respondFriendRequest(friend.userId, "ACCEPT");
                  acceptRequest();
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.disabled_by_default,
                  color: Colors.red,
                ),
                onPressed: () {
                  respondFriendRequest(friend.userId, "REJECT");
                  denyRequest();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
