import 'package:flutter/material.dart';
import 'package:sprint/models/userdata.dart';
import 'package:sprint/widgets/blocked_users_page/blockeduserinfo.dart';
import 'package:sprint/services/auth_dio.dart';

import 'package:flutter_config/flutter_config.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sprint/widgets/blocked_users_page/blockeduserspageappbar.dart';

const storage = FlutterSecureStorage();
String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class BlockUsersPage extends StatefulWidget {
  const BlockUsersPage({super.key});

  @override
  State<BlockUsersPage> createState() => _BlockUsersPageState();
}

class _BlockUsersPageState extends State<BlockUsersPage> {
  late int _blockedCount;
  late List<UserData> _blockedList;
  late Future<dynamic> _blockedData;

  @override
  void initState() {
    _blockedCount = 0;
    _blockedList = [];
    super.initState();
    _blockedData = _getBlockedUsers().then((data) {
      _blockedCount = data['count'];
      _blockedList = [];
      for (int i = 0; i < _blockedCount; i++) {
        _blockedList.add(UserData.fromJson(data['userList'][i]));
      }
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlockedUsersPageAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: _blockedData,
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
                          _blockedCount == 0
                              ? "????????? ????????? ????????????."
                              : "????????? ??????($_blockedCount???)",
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
                        children: _blockedList
                            .map((user) => BlockedUserInfo(
                                  user: user,
                                  unBlock: () {
                                    setState(() {
                                      _blockedCount--;
                                      _blockedList.remove(user);
                                    });
                                  },
                                ))
                            .toList())
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
                      child: Text('?????? ?????? ????????? ?????? ????????? ??????????????????. ?????? ????????? ?????????.'),
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
                      child: Text('?????? ?????? ????????? ???????????? ???...'),
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

  _getBlockedUsers() async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');

    var response = await dio.get(
      '$serverurl/api/user-management/block/$userID/',
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = response.data;
      return result;
    }
  }
}
