import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final GlobalKey<ScaffoldState> _key;
  CustomAppBar(_scaffoldKey) : _key = _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    print(_key);
    return AppBar(
      backgroundColor: Colors.transparent,
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
          padding: EdgeInsets.all(5),
          child: IconButton(
            icon: const Icon(Icons.notifications, color: Colors.orange),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: InkWell(
            onTap: () {},
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://i.pinimg.com/736x/f9/81/d6/f981d67d2ab128e21f0ae278082d0426.jpg"),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _key.currentState!.openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
