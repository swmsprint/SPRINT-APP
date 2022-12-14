import 'package:flutter/material.dart';
import 'package:sprint/models/frienddata.dart';
import 'package:sprint/widgets/friends_page/friendinfo.dart';
import 'package:sprint/widgets/friends_page/friendspageappbar.dart';
import 'package:sprint/widgets/friend_requests_page/recievedrequestinfo.dart';
import 'package:sprint/services/auth_dio.dart';

import 'package:flutter_config/flutter_config.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();
String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late int _recievedCount;
  late List<FriendData> _recievedList;
  late int _friendsCount;
  late List<FriendData> _friendsList;

  late Future<dynamic> _recievedData;
  late Future<dynamic> _friendsData;

  @override
  void initState() {
    _friendsCount = 0;
    _recievedCount = 0;
    _friendsList = [];
    _recievedList = [];
    super.initState();
    _recievedData = _getRecievedRequests().then((data) {
      _recievedCount = data['count'];
      _recievedList = [];
      for (int i = 0; i < _recievedCount; i++) {
        _recievedList.add(FriendData.fromJson(data['userList'][i]));
      }
      return data;
    });
    _friendsData = _getFriends().then((data) {
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
      appBar: const FriendsPageAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: _recievedData,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = _recievedCount > 0
                      ? <Widget>[
                          const Padding(padding: EdgeInsets.all(10)),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 0.075 *
                                        MediaQuery.of(context).size.width),
                              ),
                              Text(
                                "?????? ?????? ($_recievedCount???)",
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
                              children: _recievedList
                                  .map((friend) => RecievedRequestInfo(
                                      friend: friend,
                                      acceptRequest: () {
                                        setState(() {
                                          _recievedCount--;
                                          _friendsCount++;
                                          _friendsList.add(friend);
                                          _recievedList.remove(friend);
                                        });
                                      },
                                      denyRequest: () {
                                        setState(() {
                                          _recievedCount--;
                                          _recievedList.remove(friend);
                                        });
                                      }))
                                  .toList()),
                        ]
                      : <Widget>[];
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
            FutureBuilder<dynamic>(
              future:
                  _friendsData, // a previously-obtained Future<String> or null
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
                              ? "????????? ????????? ?????????!"
                              : "?????? ($_friendsCount???)",
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
                            .map((friend) => FriendInfo(
                                friend: friend,
                                reduceFriendsCount: () {
                                  setState(() {
                                    _friendsCount--;
                                    _friendsList.remove(friend);
                                  });
                                }))
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
                      child: Text('?????? ????????? ?????? ????????? ??????????????????. ?????? ????????? ?????????.'),
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
                      child: Text('?????? ????????? ???????????? ???...'),
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

  _getRecievedRequests() async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');

    var response = await dio.get(
      '$serverurl/api/user-management/friend/$userID/received',
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = response.data;
      return result;
    }
  }

  _getFriends() async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');

    var response = await dio.get(
      '$serverurl/api/user-management/friend/$userID',
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = response.data;
      return result;
    }
  }
}
