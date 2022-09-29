import 'package:flutter/material.dart';
import 'package:sprint/models/groupdata.dart';
import 'package:sprint/widgets/group_page/groupinfo.dart';
import 'package:sprint/widgets/group_page/grouppageappbar.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class SearchGroupPage extends StatefulWidget {
  const SearchGroupPage({super.key});

  @override
  State<SearchGroupPage> createState() => _SearchGroupPageState();
}

class _SearchGroupPageState extends State<SearchGroupPage> {
  late TextEditingController _controller;
  late int _groupCount;
  late List<GroupData> _groupList;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _groupCount = -1;
    _groupList = [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GroupPageAppBar(isSearchGroup: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            SizedBox(
              width: 0.85 * MediaQuery.of(context).size.width,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Color(0xff5563de),
                    ),
                    onPressed: () async {
                      setState(() {
                        _groupCount = 0;
                      });
                      _getGroups(_controller.text);
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color(0xff5563de),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color(0xff5563de),
                    ),
                  ),
                  labelText: '그룹 이름을 입력하세요',
                  labelStyle: const TextStyle(
                    color: Color(0xff5563de),
                  ),
                ),
                onSubmitted: (String value) async {
                  setState(() {
                    _groupCount = 0;
                  });
                  _getGroups(value);
                },
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                Text(
                  _groupCount == -1 ? "" : "검색 결과 ($_groupCount개)",
                  style: const TextStyle(
                    color: Color(0xff5563de),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            Column(
                children: _groupList
                    .map((group) => GroupInfo(group: group))
                    .toList()),
          ],
        ),
      ),
    );
  }

  _getGroups(keyword) async {
    final response = await http.get(
      Uri.parse(
          '$serverurl:8080/api/user-management/groups/list/?target=$keyword&userId=1'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));
      print(result);
      setState(() {
        _groupCount = result['count'];
      });
      _groupList = [];
      for (int i = 0; i < _groupCount; i++) {
        _groupList.add(GroupData.fromJson(result['groupList'][i]));
      }
    } else {
      print("Failed : ${response.statusCode}");
    }
  }
}
