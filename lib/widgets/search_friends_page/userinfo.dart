import 'package:flutter/material.dart';
import 'package:sprint/models/userdata.dart';
import 'package:sprint/screens/friends_stats_page.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class UserInfo extends StatefulWidget {
  final UserData user;
  const UserInfo({Key? key, required this.user}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late int _actionButtonindex;

  @override
  void initState() {
    if (widget.user.isFriend == "NOT_FRIEND") {
      _actionButtonindex = 0;
    } else {
      if (widget.user.isFriend == "REQUEST") {
        _actionButtonindex = 1;
      } else {
        if (widget.user.isFriend == "RECEIVE") {
          _actionButtonindex = 2;
        } else {
          _actionButtonindex = 3;
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List actionButtons = [
      IconButton(
        icon: const Icon(
          Icons.group_add,
          color: Color(0xff5563de),
        ),
        onPressed: () {
          setState(() {
            _actionButtonindex = 1;
          });
          _postFriendRequest(widget.user.userId);
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.check,
          color: Color(0xff5563de),
        ),
        onPressed: () {
          setState(() {
            _actionButtonindex = 0;
          });
          _deleteFriendRequest(widget.user.userId);
        },
      ),
      Row(children: [
        IconButton(
          icon: const Icon(
            Icons.check,
            color: Color(0xff5563de),
          ),
          onPressed: () {
            _respondFriendRequest(widget.user.userId, "ACCEPT");
            setState(() {
              _actionButtonindex = 3;
            });
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.disabled_by_default,
            color: Colors.red,
          ),
          onPressed: () {
            _respondFriendRequest(widget.user.userId, "REJECT");
            setState(() {
              _actionButtonindex = 0;
            });
          },
        ),
      ]),
      const SizedBox()
    ];

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
                            FriendsStatsPage(userId: widget.user.userId),
                        fullscreenDialog: false),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(
                        "assets/images/${widget.user.userId}.png",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.nickname,
                          style: const TextStyle(
                            color: Color(0xff5563de),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(5)),
                        Text(
                          widget.user.email,
                          style: const TextStyle(
                            color: Color(0xff5563de),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              actionButtons[_actionButtonindex],
            ],
          ),
        ],
      ),
    );
  }

  _postFriendRequest(targetUserId) async {
    final response = await http.post(
        Uri.parse('$serverurl:8080/api/user-management/friends'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "sourceUserId": 1,
          'targetUserId': targetUserId, //Demo user
        }));
    if (response.statusCode == 200) {
      print("Success");
    } else {
      print("Failed : ${response.statusCode}");
    }
  }

  _deleteFriendRequest(targetUserId) async {
    final response =
        await http.put(Uri.parse('$serverurl:8080/api/user-management/friends'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "friendState": "CANCEL",
              "sourceUserId": 1,
              'targetUserId': targetUserId,
            }));
    if (response.statusCode == 200) {
      print("Success");
    } else {
      print("Failed : ${response.statusCode}");
    }
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

  _respondFriendRequest(targetUserId, acceptance) async {
    final response =
        await http.put(Uri.parse('$serverurl:8080/api/user-management/friends'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "friendState": acceptance,
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
