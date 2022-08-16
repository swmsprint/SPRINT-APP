import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FriendRecord extends StatelessWidget {
  const FriendRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.all(10)),
        Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
            depth: 8,
            lightSource: LightSource.topLeft,
            color: const Color(0xffffffff),
          ),
          child: Container(
            width: 90,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                        "https://i.pinimg.com/736x/f9/81/d6/f981d67d2ab128e21f0ae278082d0426.jpg"),
                  ),
                  Text(
                    '성이름',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 13,
                      color: Color(0xff5563de),
                    ),
                  ),
                ]),
          ),
        )
      ],
    );
  }
}
