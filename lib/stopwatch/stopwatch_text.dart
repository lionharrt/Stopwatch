import 'package:flutter/material.dart';
import 'package:hello_world/common/displays_time.mixin.dart';

class StopwatchText extends StatelessWidget with DisplaysTime {
  final Duration duration;
  const StopwatchText(this.duration, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(top: 50),
        child: Text(
          formatTimeMSMs(duration),
          style: TextStyle(
            fontSize: 60.0,
          ),
        ));
  }
}
