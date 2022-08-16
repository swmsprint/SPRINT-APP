import 'package:flutter/material.dart';

class PaceMaker extends StatelessWidget {
  const PaceMaker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      Text(
        '다음 5분은 이렇게 추천해요',
        style: TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 15,
          color: Color(0xff5563de),
        ),
      ),
      Text(
        '7"00" 페이스',
        style: TextStyle(
          color: Color(0xff5563de),
          fontFamily: 'Anton',
          fontSize: 30,
        ),
      ),
      Text(
        '안쪽으로 10분간 달려보아요!',
        style: TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 15,
          color: Color(0xff5563de),
        ),
      ),
    ]);
  }
}
