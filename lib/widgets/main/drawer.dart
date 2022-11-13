import 'package:flutter/material.dart';
import 'package:sprint/services/auth_dio.dart';
import 'package:sprint/widgets/stats_page/profile.dart';
import 'package:sprint/screens/login_page.dart';
import 'package:sprint/screens/signup_page.dart';
import 'package:sprint/screens/friends_page.dart';
import 'package:sprint/screens/block_users_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_config/flutter_config.dart';

final storage = new FlutterSecureStorage();
String serverurl = FlutterConfig.get('SERVER_ADDRESS');

class CustomDrawer extends StatelessWidget {
  int userId;
  CustomDrawer({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _resign() async {
      var dio = await authDio(context);
      final userID = await storage.read(key: 'userID');

      var response = await dio.delete(
        '$serverurl/api/user-management/user/$userID/disable',
      );
      if (response.statusCode == 200) {
        await storage.deleteAll();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (route) => false);
      }
    }

    _resignAlert() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('정말로 탈퇴하시겠습니까?'),
            content: const Text('한번 탈퇴한 계정은 복구할 수 없습니다.'),
            actions: <Widget>[
              TextButton(
                child: const Text('취소', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('탈퇴하기', style: TextStyle(color: Colors.red)),
                onPressed: _resign,
              ),
            ],
          );
        },
      );
    }

    return Drawer(
      backgroundColor: const Color(0xff5563de),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const Padding(padding: EdgeInsets.all(30)),
                Profile(userId: userId, isDrawer: true),
                const Padding(padding: EdgeInsets.all(10)),
                ListTile(
                  title: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0.075 * MediaQuery.of(context).size.width),
                      ),
                      const Icon(
                        Icons.feed,
                        color: Colors.white,
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      const Text(
                        "운동 피드",
                        style: TextStyle(
                          fontFamily: 'YDIYGO',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0.075 * MediaQuery.of(context).size.width),
                      ),
                      const Icon(
                        Icons.group,
                        color: Colors.white,
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      const Text(
                        "친구 관리",
                        style: TextStyle(
                          fontFamily: 'YDIYGO',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FriendsPage(),
                          fullscreenDialog: true),
                    );
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0.075 * MediaQuery.of(context).size.width),
                      ),
                      const Icon(
                        Icons.block,
                        color: Colors.white,
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      const Text(
                        "차단 관리",
                        style: TextStyle(
                          fontFamily: 'YDIYGO',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BlockUsersPage(),
                          fullscreenDialog: true),
                    );
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0.075 * MediaQuery.of(context).size.width),
                      ),
                      const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      const Text(
                        "회원 정보 수정",
                        style: TextStyle(
                          fontFamily: 'YDIYGO',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpPage(isNewUser: false),
                          fullscreenDialog: true),
                    );
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 0.075 * MediaQuery.of(context).size.width),
                      ),
                      const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      const Text(
                        "로그아웃",
                        style: TextStyle(
                          fontFamily: 'YDIYGO',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    await storage.deleteAll();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginPage()),
                        (route) => false);
                  },
                ),
              ],
            ),
          ),
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: [
                  const Divider(),
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          "회원 탈퇴하기",
                          style: TextStyle(
                            fontFamily: 'YDIYGO',
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                      ],
                    ),
                    onTap: _resignAlert,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
