import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/screens/friends_page.dart';

class AddFriend extends StatelessWidget {
  const AddFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.all(10)),
        InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FriendsPage(),
                ),
              );
            },
            child: Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
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
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10)),
                        child: const Icon(
                          Icons.group_add,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FriendsPage(),
                                fullscreenDialog: true),
                          );
                        },
                      ),
                      const Text(
                        "친구 추가하기",
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 13,
                          color: Color(0xff5563de),
                        ),
                      ),
                    ]),
              ),
            )),
      ],
    );
  }
}
