import 'package:flutter/material.dart';
import 'package:sprint/services/auth_dio.dart';
import 'package:sprint/widgets/search_friends_page/userinfo.dart';
import 'package:sprint/widgets/friends_page/friendspageappbar.dart';

import 'package:sprint/models/userdata.dart';

import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();
String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class SearchFriendsPage extends StatefulWidget {
  const SearchFriendsPage({super.key});

  @override
  State<SearchFriendsPage> createState() => _SearchFriendsPageState();
}

class _SearchFriendsPageState extends State<SearchFriendsPage> {
  late TextEditingController _controller;
  late int _userCount;
  late List<UserData> _userList;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _userCount = -1;
    _userList = [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FriendsPageAppBar(isSearchFriends: true),
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
                          _userCount = 0;
                          _userList = [];
                        });
                        _getUsers(_controller.text);
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
                    labelText: '친구의 닉네임을 입력하세요',
                    labelStyle: const TextStyle(
                      color: Color(0xff5563de),
                    ),
                  ),
                  onSubmitted: (String value) async {
                    setState(() {
                      _userCount = 0;
                      _userList = [];
                    });
                    _getUsers(value);
                  }),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 0.075 * MediaQuery.of(context).size.width),
                ),
                Text(
                  _userCount == -1 ? "" : "검색 결과 ($_userCount명)",
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
                children:
                    _userList.map((user) => UserInfo(user: user)).toList()),
          ],
        ),
      ),
    );
  }

  _getUsers(keyword) async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');

    var response = await dio.get('$serverurl:8081/api/user-management/user/',
        queryParameters: {"target": keyword, "userId": userID});
    if (response.statusCode == 200) {
      Map<String, dynamic> result = response.data;
      print(result);
      setState(() {
        _userCount = result['count'];
        _userList = [];
        for (int i = 0; i < _userCount; i++) {
          _userList.add(UserData.fromJson(result['userList'][i]));
        }
      });
    }
  }
}
