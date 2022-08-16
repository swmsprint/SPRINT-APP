import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

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
                      image: NetworkImage(
                          "https://i.pinimg.com/736x/f9/81/d6/f981d67d2ab128e21f0ae278082d0426.jpg"))),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            const Text(
              "성이름",
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 20,
                color: Color(0xff5563de),
              ),
            ),
          ],
        ),
      ],
      // ToDo: 배지 박기
    );
  }
}
