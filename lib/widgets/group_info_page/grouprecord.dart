import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sprint/utils/secondstostring.dart';

class GroupRecord extends StatelessWidget {
  final double distance;
  final double time;
  const GroupRecord({
    Key? key,
    required this.distance,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        depth: 8,
        lightSource: LightSource.topLeft,
        color: const Color(0xffffffff),
      ),
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${(distance / 1000).toStringAsFixed(2)}KM",
              style: const TextStyle(
                fontFamily: 'Anton',
                fontSize: 37,
                color: Color(0xfffa7531),
              ),
            ),
            Text(
              secondsToString(time.round()),
              style: const TextStyle(
                fontFamily: 'Anton',
                fontSize: 37,
                color: Color(0xfffa7531),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
