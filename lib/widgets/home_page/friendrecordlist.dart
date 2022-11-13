import 'package:flutter/material.dart';
import 'package:sprint/models/frienddata.dart';
import 'package:sprint/widgets/home_page/addfriend.dart';
import 'package:sprint/widgets/home_page/friendrecord.dart';
import 'package:sprint/services/auth_dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class FriendRecordList extends StatefulWidget {
  const FriendRecordList({super.key});

  @override
  State<FriendRecordList> createState() => _FriendRecordListState();
}

class _FriendRecordListState extends State<FriendRecordList> {
  late List<Widget> _friendsData;

  @override
  void initState() {
    super.initState();
    _friendsData = [];
    _getFriends();
  }

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
                ..._friendsData,
                const AddFriend(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getFriends() async {
    var dio = await authDio(context);
    final userID = await storage.read(key: 'userID');

    var response = await dio.get(
      '$serverurl/api/user-management/friend/$userID',
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> result = response.data;
      int friendsCount = result['count'];
      List<FriendData> friendsList = [];
      for (int i = 0; i < friendsCount; i++) {
        friendsList.add(FriendData.fromJson(response.data['userList'][i]));
      }
      setState(() {
        _friendsData = friendsList
            .map((friend) => FriendRecord(
                  name: friend.nickname,
                  image: friend.profile,
                  friendId: friend.userId,
                ))
            .toList();
      });
    }
  }
}
