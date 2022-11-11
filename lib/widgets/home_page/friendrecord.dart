import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/screens/friends_stats_page.dart';

class FriendRecord extends StatelessWidget {
  final String name;
  final String image;
  final int friendId;
  const FriendRecord(
      {Key? key,
      required this.name,
      required this.image,
      required this.friendId})
      : super(key: key);

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
                  builder: (context) => FriendsStatsPage(
                        userId: friendId,
                        userNickName: name,
                        showActions: true,
                      ),
                  fullscreenDialog: false),
            );
          },
          child: Neumorphic(
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
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(image),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 13,
                        color: Color(0xff5563de),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ],
    );
  }
}
