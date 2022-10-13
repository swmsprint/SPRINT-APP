import 'package:flutter/material.dart';
import 'package:sprint/models/groupdata.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:sprint/screens/group_info_page.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class GroupAbstract extends StatefulWidget {
  final GroupData group;
  const GroupAbstract({Key? key, required this.group}) : super(key: key);

  @override
  State<GroupAbstract> createState() => _GroupAbstractState();
}

class _GroupAbstractState extends State<GroupAbstract> {
  late int _actionButtonindex;
  @override
  void initState() {
    if (widget.group.state == "NOT_MEMBER") {
      _actionButtonindex = 0;
    } else if (widget.group.state == "REQUEST") {
      _actionButtonindex = 1;
    } else {
      _actionButtonindex = 2;
    }

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
          _cancelJoinRequest(widget.group.groupId);
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupInfoPage(
                              groupId: widget.group.groupId,
                              isLeader: (widget.group.state == "LEADER"),
                              groupName: widget.group.groupName,
                              groupDescription: widget.group.groupDescription,
                              groupImage: widget.group.groupPicture,
                            ),
                        fullscreenDialog: false),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.group.groupPicture,
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
              Text(
                "${widget.group.groupPersonnel} / ${widget.group.groupMaxPersonnel}",
                style: const TextStyle(
                  color: Color(0xff5563de),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Padding(padding: EdgeInsets.all(10)),
              actionButtons[_actionButtonindex],
            ],
          ),
        ],
      ),
    );
  }

  _postJoinRequest(groupId) async {
    final response = await http.post(
        Uri.parse('$serverurl:8080/api/user-management/group/group-member'),
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

  _cancelJoinRequest(groupId) async {
    final response = await http.put(
        Uri.parse('$serverurl:8080/api/user-management/group/group-member'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {"groupId": groupId, "groupMemberState": "CANCEL", "userId": 1}));
    if (response.statusCode == 200) {
      print("Success");
    } else {
      print("Failed : ${response.statusCode}");
    }
  }
}