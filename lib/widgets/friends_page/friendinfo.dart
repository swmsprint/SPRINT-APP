import 'package:flutter/material.dart';
import 'package:sprint/models/frienddata.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:sprint/screens/friends_stats_page.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class FriendInfo extends StatelessWidget {
  final FriendData friend;
  const FriendInfo({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        builder: (context) =>
                            FriendsStatsPage(userId: friend.userId),
                        fullscreenDialog: false),
                  );
                },
                child: Row(children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      "assets/images/${friend.userId}.png",
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
                      Text(
                        friend.email,
                        style: const TextStyle(
                          color: Color(0xff5563de),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.group_remove,
                  color: Color(0xff5563de),
                ),
                onPressed: () {
                  _deleteFriend(friend.userId);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  _deleteFriend(targetUserId) async {
    final response =
        await http.put(Uri.parse('$serverurl:8080/api/user-management/friends'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "friendState": "DELETE",
              "sourceUserId": 1,
              'targetUserId': targetUserId,
            }));
    if (response.statusCode == 200) {
      print("Success");
    } else {
      print("Failed : ${response.statusCode}");
    }
  }
}
