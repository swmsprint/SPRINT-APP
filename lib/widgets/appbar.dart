import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      title: const Text(
        "SPRINT",
        style: TextStyle(
            color: Colors.blue,
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
              backgroundImage: NetworkImage('https://i.imgur.com/BoN9kdC.png'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
