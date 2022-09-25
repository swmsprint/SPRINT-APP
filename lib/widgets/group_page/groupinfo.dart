import 'package:flutter/material.dart';
import 'package:sprint/models/groupdata.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class GroupInfo extends StatefulWidget {
  final GroupData group;
  const GroupInfo({Key? key, required this.group}) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  late int _actionButtonindex;
  @override
  void initState() {
    _actionButtonindex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List actionButtons = [
      TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xff5563de),
        ),
        onPressed: () {
          setState(() {
            _actionButtonindex = 1;
          });
          _postJoinRequest(widget.group.groupId);
        },
        child: const Text(
          "그룹 가입하기",
          style: TextStyle(color: Colors.white),
        ),
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
        },
      ),
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
                onTap: () {},
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(
                        "assets/images/${widget.group.groupId}.png",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.group.groupName,
                          style: const TextStyle(
                            color: Color(0xff5563de),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(5)),
                        Text(
                          widget.group.groupDescription,
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

  _postJoinRequest(groupId) async {
    final response = await http.post(
        Uri.parse('$serverurl:8080/api/user-management/groups/group-member'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"groupId": groupId, "userId": 1}));
    if (response.statusCode == 200) {
      print("Success");
    } else {
      print("Failed : ${response.statusCode}");
    }
  }
}
