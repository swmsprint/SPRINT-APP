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
                const FriendRecord(),
                const FriendRecord(),
                const FriendRecord(),
                const FriendRecord(),
                const FriendRecord(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
