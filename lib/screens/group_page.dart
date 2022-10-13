import 'package:flutter/material.dart';
import 'package:sprint/models/groupdata.dart';
import 'package:sprint/screens/create_group_page.dart';
import 'package:sprint/screens/search_group_page.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:sprint/widgets/group_page/groupabstract.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  late int _groupsCount;
  late List<GroupData> _groupsList;
  late Future<dynamic> _groupsData;

  @override
  void initState() {
    _groupsCount = 0;
    _groupsList = [];
    super.initState();
    _groupsData = _getGroups().then((data) {
      _groupsCount = data['count'];
      for (int i = 0; i < _groupsCount; i++) {
        _groupsList.add(GroupData.fromJson(data['groupList'][i]));
      }
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _groupsCount == 0
                      ? "그룹에 가입해 보세요"
                      : "가입한 그룹 ($_groupsCount 개)",
                  style: const TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 15,
                    color: Color(0xff5563de),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchGroupPage(),
                                fullscreenDialog: true),
                          );
                        },
                        icon: const Icon(
                          Icons.search,
                          size: 20,
                          color: Color(0xff5563de),
                        )),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateGroupPage(),
                              fullscreenDialog: true),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                        color: Color(0xff5563de),
                      ),
                    )
                  ],
                )
              ],
            ),
            FutureBuilder<dynamic>(
              future:
                  _groupsData, // a previously-obtained Future<String> or null
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[
                    Column(
                        children: _groupsList
                            .map((group) => GroupAbstract(
                                  group: group,
                                ))
                            .toList()),
                  ];
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('그룹 목록을 불러 오는데 실패했습니다. 다시 시도해 주세요.'),
                    ),
                  ];
                } else {
                  children = const <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('그룹 목록을 불러오는 중...'),
                    ),
                  ];
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: children,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _getGroups() async {
    final response = await http.get(
      Uri.parse('$serverurl:8080/api/user-management/group/list/1'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(utf8.decode(response.bodyBytes));
      return result;
    } else {
      print("Failed : ${response.statusCode}");
    }
  }
}
