import 'package:sprintf/sprintf.dart';

String secondsToString(int seconds) {
  return seconds >= 3600
      ? sprintf(
          "%d:%02d:%02d", [seconds ~/ 3600, (seconds ~/ 60) % 60, seconds % 60])
      : sprintf("%02d:%02d", [seconds ~/ 60, seconds % 60]);
}
