import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class GroupProfile extends StatelessWidget {
  final String groupName;
  final String groupDescription;
  final int groupPersonnel;
  const GroupProfile({
    Key? key,
    required this.groupName,
    required this.groupDescription,
    required this.groupPersonnel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 180)),
          Neumorphic(
            style: const NeumorphicStyle(
              shape: NeumorphicShape.concave,
              depth: 8,
              lightSource: LightSource.topLeft,
              color: Color(0xfff3f5fc),
            ),
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: const Color(0xff5563de),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      groupName,
                      style: const TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 30,
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      groupDescription,
                      style: const TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 13,
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      "인원 : $groupPersonnel / 20 명",
                      style: const TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 15,
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
