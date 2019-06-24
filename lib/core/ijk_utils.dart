import 'package:flutter/material.dart';

String formatTime(double sec) {
  Duration d = Duration(seconds: sec.toInt());
  final ms = d.inMilliseconds;
  int seconds = ms ~/ 1000;
  final int hours = seconds ~/ 3600;
  seconds = seconds % 3600;
  var minutes = seconds ~/ 60;
  seconds = seconds % 60;

  final hoursString = hours >= 10 ? '$hours' : hours == 0 ? '00' : '0$hours';

  final minutesString =
      minutes >= 10 ? '$minutes' : minutes == 0 ? '00' : '0$minutes';

  final secondsString =
      seconds >= 10 ? '$seconds' : seconds == 0 ? '00' : '0$seconds';

  final formattedTime =
      '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';

  return formattedTime;
}
PageRouteBuilder NoTransitionPageRoute(
    {@required BuildContext context, @required TransitionBuilder builder}) {
  return PageRouteBuilder(
    settings: RouteSettings(isInitialRoute: false),
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) {
      return AnimatedBuilder(
        animation: animation,
        builder: builder,
      );
    },
  );
}