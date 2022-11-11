import 'package:flutter/material.dart';
import 'package:sprint/widgets/stats_page/profile.dart';
import 'package:sprint/screens/login_page.dart';
import 'package:sprint/screens/signup_page.dart';
import 'package:sprint/screens/friends_page.dart';
import 'package:sprint/screens/block_users_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

class CustomDrawer extends StatelessWidget {
  int userId;
  CustomDrawer({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff5563de),
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
                      builder: (BuildContext context) => LoginPage()),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
