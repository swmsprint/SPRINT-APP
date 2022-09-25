import 'package:flutter/material.dart';
import 'package:sprint/widgets/stats_page/profile.dart';
import 'package:sprint/screens/friends_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff5563de),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const Padding(padding: EdgeInsets.all(20)),
          Profile(userId: 1, isDrawer: true),
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
                Padding(padding: EdgeInsets.all(10)),
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
                Padding(padding: EdgeInsets.all(10)),
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
                  Icons.group_add,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.all(10)),
                const Text(
                  "초대 링크",
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
                  Icons.settings,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.all(10)),
                const Text(
                  "설정",
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
                  Icons.help,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.all(10)),
                const Text(
                  "도움",
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
        ],
      ),
    );
  }
}
