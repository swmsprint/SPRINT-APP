import 'package:flutter/material.dart';
import 'package:sprint/screens/search_friends_page.dart';
import 'package:sprint/screens/friend_request_page.dart';

class FriendsPageAppBar extends StatelessWidget with PreferredSizeWidget {
  bool isSearchFriends = false;
  FriendsPageAppBar({Key? key, this.isSearchFriends = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xfff3f5fc),
      elevation: 0.0,
      iconTheme: const IconThemeData(
        color: Color(0xff5563de),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      title: Text(
        isSearchFriends ? "친구 찾기" : "친구 관리",
        style: const TextStyle(
            color: Color(0xff5563de),
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1),
      ),
      actions: isSearchFriends
          ? [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FriendRequestPage(),
                        fullscreenDialog: true),
                  );
                },
                icon: const Icon(Icons.send),
              )
            ]
          : [
              IconButton(
                icon: const Icon(Icons.group_add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchFriendsPage(),
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
