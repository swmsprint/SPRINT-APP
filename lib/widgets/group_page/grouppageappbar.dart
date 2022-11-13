import 'package:flutter/material.dart';

class GroupPageAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool isSearchGroup;
  const GroupPageAppBar({Key? key, this.isSearchGroup = false}) : super(key: key);

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
        isSearchGroup ? "그룹 찾기" : "그룹 만들기",
        style: const TextStyle(
            color: Color(0xff5563de),
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
