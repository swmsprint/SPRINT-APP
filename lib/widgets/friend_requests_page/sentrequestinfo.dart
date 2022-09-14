import 'package:flutter/material.dart';
import 'package:sprint/models/frienddata.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class SentRequestInfo extends StatefulWidget {
  final FriendData friend;
  const SentRequestInfo({Key? key, required this.friend}) : super(key: key);

  @override
  State<SentRequestInfo> createState() => _SentRequestInfoState();
}

class _SentRequestInfoState extends State<SentRequestInfo> {
  late bool _isSent;

  @override
  void initState() {
    _isSent = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.85 * MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(5)),
          Row(
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
              const Spacer(),
              _isSent
                  ? IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Color(0xff5563de),
                      ),
                      onPressed: () {
                        _deleteFriendRequest(widget.friend.userId);
                        setState(() {
                          _isSent = false;
                        });
                      },
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.group_add,
                        color: Color(0xff5563de),
                      ),
                      onPressed: () {
                        _postFriendRequest(widget.friend.userId);
                        setState(() {
                          _isSent = true;
                        });
                      },
                    ),
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
}
