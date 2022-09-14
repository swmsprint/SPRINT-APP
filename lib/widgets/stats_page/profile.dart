import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  bool isDrawer = false;
  final int userId;
  Profile({Key? key, this.isDrawer = false, required this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: 0.075 * MediaQuery.of(context).size.width),
        ),
        Column(
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/1.png"))),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            Text(
              "서다영",
              style: TextStyle(
                fontFamily: 'YDIYGO',
                fontSize: 20,
                color: isDrawer ? Colors.white : const Color(0xff5563de),
              ),
            ),
          ],
        ),
      ],
      // ToDo: 배지 박기
    );
  }
}
