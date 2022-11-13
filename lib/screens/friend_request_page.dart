import 'package:flutter/material.dart';

import 'package:flutter_config/flutter_config.dart';

import 'package:sprint/models/frienddata.dart';
import 'package:sprint/widgets/friend_requests_page/recievedrequestinfo.dart';
import 'package:sprint/widgets/friend_requests_page/sentrequestinfo.dart';
import 'package:sprint/services/auth_dio.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();
String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({super.key});

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  late int _recievedCount;
  late List<FriendData> _recievedList;
  late int _sentCount;
  late List<FriendData> _sentList;

  late Future<dynamic> _recievedData;
  late Future<dynamic> _sentData;

  @override
  void initState() {
    super.initState();
    _recievedCount = 0;
    _sentCount = 0;
    _recievedList = [];
    _sentList = [];
    _recievedData = _getRecievedRequests().then((data) {
      _recievedCount = data['count'];
      _recievedList = [];
      for (int i = 0; i < _recievedCount; i++) {
        _recievedList.add(FriendData.fromJson(data['userList'][i]));
      }
      return data;
    });
    _sentData = _getSentRequests().then((data) {
      _sentCount = data['count'];
      _sentList = [];
      for (int i = 0; i < _sentCount; i++) {
        _sentList.add(FriendData.fromJson(data['userList'][i]));
      }
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff3f5fc),
        iconTheme: const IconThemeData(
          color: Color(0xff5563de),
        ),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: const Text(
          "친구 요청",
          style: TextStyle(
              color: Color(0xff5563de),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: _recievedData,
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
                          _recievedCount == 0
                              ? "받은 요청이 없습니다"
                              : "받은 요청 ($_recievedCount개)",
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
                                      _recievedList.remove(friend);
                                    });
                                  },
                                  denyRequest: () {
                                    setState(() {
                                      _recievedCount--;
                                      _recievedList.remove(friend);
                                    });
                                  },
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
                      child: Text('받은 친구 요청을 불러 오는데 실패했습니다. 다시 시도해 주세요.'),
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
                      child: Text('받은 친구 요청을 불러오는 중...'),
                    ),
                  ];
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: children,
                );
              },
            ),
            FutureBuilder(
              future: _sentData,
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
                          _sentCount == 0
                              ? "보낸 요청이 없습니다"
                              : "보낸 요청 ($_sentCount개)",
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
                        children: _sentList
                            .map((user) => SentRequestInfo(
                                friend: user,
                                cancelRequest: () {
                                  setState(() {
                                    _sentCount--;
                                    _sentList.remove(user);
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
                      child: Text('보낸 친구 요청을 불러 오는데 실패했습니다. 다시 시도해 주세요.'),
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
                      child: Text('보낸 친구 요청을 불러오는 중...'),
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

  _getSentRequests() async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');

    final response = await dio.get(
      '$serverurl/api/user-management/friend/$userID/requested',
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = response.data;
      return result;
    }
  }
}
