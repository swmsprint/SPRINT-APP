import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final GlobalKey<ScaffoldState> _key;
  CustomAppBar(_scaffoldKey) : _key = _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xfff3f5fc),
      elevation: 0.0,
      title: const Text(
        "SPRINT",
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5),
          child: IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Color(0xfffa7531),
            ),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {},
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://this-person-does-not-exist.com/img/avatar-85a1136f5c868f411a1aaf47007312eb.jpg"),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _key.currentState!.openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
