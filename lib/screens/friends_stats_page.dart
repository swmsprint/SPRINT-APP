import 'package:flutter/material.dart';
import 'package:sprint/screens/stats_page.dart';

class FriendsStatsPage extends StatelessWidget {
  final int userId;
  final String userNickName;
  const FriendsStatsPage(
      {Key? key, required this.userId, required this.userNickName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userNickName),
        backgroundColor: const Color(0xfff3f5fc),
        foregroundColor: const Color(0xff5563de),
      ),
      body: StatsPage(userId: userId),
    );
  }
}
