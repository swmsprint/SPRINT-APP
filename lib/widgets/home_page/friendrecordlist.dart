import 'package:flutter/material.dart';
import 'package:sprint/widgets/home_page/friendrecord.dart';

class FriendRecordList extends StatelessWidget {
  const FriendRecordList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: <Widget>[
          SliverFillRemaining(
            hasScrollBody: false,
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        left:
                            (0.075 * MediaQuery.of(context).size.width) - 20)),
                const FriendRecord(name: '신종인', image: "assets/images/2.png"),
                const FriendRecord(name: '예나윤', image: "assets/images/3.png"),
                const FriendRecord(name: '이병창', image: "assets/images/4.png"),
                const FriendRecord(name: '최창현', image: "assets/images/5.png"),
                const FriendRecord(name: '김시은', image: "assets/images/6.png"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
