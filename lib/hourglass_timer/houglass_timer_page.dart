import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/hourglass_timer/hourglass_timer.dart';

class HourGlassTimerPage extends StatelessWidget {
  final HourGlassTimer hourGlassTimer;

  const HourGlassTimerPage(this.hourGlassTimer, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
        backgroundColor: themeData.backgroundColor, body: hourGlassTimer);
  }
}
