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
                const FriendRecord(
                    name: '신종인',
                    image:
                        "https://i.ibb.co/kcspMdp/Kakao-Talk-Photo-2022-08-17-18-00-24.png"),
                const FriendRecord(
                    name: '예나윤',
                    image:
                        'https://this-person-does-not-exist.com/img/avatar-9c4f6dbf7f87be277c7edf0924910826.jpg'),
                const FriendRecord(
                    name: '이병창',
                    image:
                        'https://this-person-does-not-exist.com/img/avatar-dfe086172c746817cf74ca9bdf36d217.jpg'),
                const FriendRecord(
                    name: '최창현',
                    image:
                        'https://this-person-does-not-exist.com/img/avatar-8c68c0f26a37420f68bd49ff8748cb50.jpg'),
                const FriendRecord(
                    name: '김시은',
                    image:
                        'https://this-person-does-not-exist.com/img/avatar-b2e48a6eb05e64a6f7018e38418a8970.jpg'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
