import 'package:flutter/material.dart';
import 'package:sprint/models/frienddata.dart';
import 'package:sprint/widgets/friends_page/friendinfo.dart';
import 'package:sprint/widgets/friends_page/friendspageappbar.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';

String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late int _friendsCount;
  late List<FriendData> _friendsList;

  late Future<dynamic> _data;

  @override
  void initState() {
    _friendsCount = 0;
    _friendsList = [];
    super.initState();
    _data = _getFriends().then((data) {
      _friendsCount = data['count'];
      for (int i = 0; i < _friendsCount; i++) {
        _friendsList.add(FriendData.fromJson(data['userList'][i]));
      }
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FriendsPageAppBar(),
      body: FutureBuilder<dynamic>(
        future: _data, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              const Padding(padding: EdgeInsets.all(10)),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 0.075 * MediaQuery.of(context).size.width),
                  ),
                  Text(
                    _friendsCount == 0
                        ? "친구를 추가해 보세요!"
                        : "친구 ($_friendsCount명)",
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
                  children: _friendsList
                      .map((friend) => FriendInfo(friend: friend))
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
                child: Text('친구 목록을 불러 오는데 실패했습니다. 다시 시도해 주세요.'),
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
                child: Text('친구 목록을 불러오는 중...'),
              ),
            ];
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
          );
        },
      ),
    );
  }

  _getFriends() async {
    final response = await http.get(
      Uri.parse('$serverurl:8080/api/user-management/friends/list?userId=1'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result;
    } else {
      print("Failed : ${response.statusCode}");
    }
  }
}
