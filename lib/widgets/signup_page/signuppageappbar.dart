import 'package:flutter/material.dart';

class SignupPageAppBar extends StatelessWidget with PreferredSizeWidget {
  SignupPageAppBar({Key? key}) : super(key: key);

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
      title: const Text(
        "추가 정보 입력",
        style: TextStyle(
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
