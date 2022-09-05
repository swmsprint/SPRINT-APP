import 'package:flutter/material.dart';
import 'package:sprint/screens/add_friends_page.dart';

class FriendsPageAppBar extends StatelessWidget with PreferredSizeWidget {
  bool isAddFriends = false;
  FriendsPageAppBar({Key? key, this.isAddFriends = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xfff3f5fc),
      elevation: 0.0,
      iconTheme: const IconThemeData(
        color: Color(0xff5563de),
      ),
      title: Text(
        isAddFriends ? "친구 찾기" : "친구 관리",
        style: const TextStyle(
            color: Color(0xff5563de),
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1),
      ),
      actions: isAddFriends
          ? null
          : [
              IconButton(
                icon: const Icon(Icons.group_add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddFriendsPage(),
                        fullscreenDialog: true),
                  );
                },
              ),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
