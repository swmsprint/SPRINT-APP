import 'package:flutter/material.dart';
import 'package:sprint/models/frienddata.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

import 'package:sprint/screens/friends_stats_page.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class RecievedRequestInfo extends StatefulWidget {
  final FriendData friend;
  const RecievedRequestInfo({Key? key, required this.friend}) : super(key: key);

  @override
  State<RecievedRequestInfo> createState() => _RecievedRequestInfoState();
}

class _RecievedRequestInfoState extends State<RecievedRequestInfo> {
  late bool _show;

  @override
  void initState() {
    super.initState();
    _show = true;
  }

  @override
  Widget build(BuildContext context) {
    return _show
        ? SizedBox(
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
                                    userId: widget.friend.userId),
                                fullscreenDialog: false),
                          );
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/images/${widget.friend.userId}.png",
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(10)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.friend.nickname,
                                  style: const TextStyle(
                                    color: Color(0xff5563de),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(5)),
                                Text(
                                  widget.friend.email,
                                  style: const TextStyle(
                                    color: Color(0xff5563de),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
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
                        _respondFriendRequest(widget.friend.userId, "ACCEPT");
                        setState(() {
                          _show = false;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.disabled_by_default,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _respondFriendRequest(widget.friend.userId, "REJECT");
                        setState(() {
                          _show = false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox();
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
