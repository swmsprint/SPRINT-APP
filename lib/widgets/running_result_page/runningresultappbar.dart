import 'package:flutter/material.dart';
import 'package:sprint/main.dart';

class RunningResultAppBar extends StatelessWidget with PreferredSizeWidget {
  const RunningResultAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xfff3f5fc),
      title: const Text('Summary',
          style: TextStyle(
            color: Color(0xff5563de),
          )),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Color(0xff5563de),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const RootPage();
          }));
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
