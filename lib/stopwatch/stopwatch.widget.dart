import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/stopwatch/control_buttons.widget.dart';
import 'package:hello_world/stopwatch/lap.widget.dart';
import 'package:hello_world/stopwatch/stopwatch.class.dart';
import 'package:hello_world/stopwatch/stopwatch_text.widget.dart';

class StopWatchPage extends StatefulWidget {
  final StopWatch stopWatch;
  StopWatchPage(this.stopWatch, {Key key}) : super(key: key);

  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
//*   ----- Properties ---
  Timer changeDetection;
//*   ----- LifeCycle ---

  @override
  void initState() {
    super.initState();
    changeDetection = Timer.periodic(Duration(milliseconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.stopWatch.timer != null) {
      widget.stopWatch.timer.cancel();
    }
    widget.stopWatch.isStopped = true;
    changeDetection.cancel();
    super.dispose();
  }

//*    ----- Methods ---

  void play() async {
    if (widget.stopWatch.isStopped) {
      setState(() {
        widget.stopWatch.isStopped = false;
      });
      widget.stopWatch.tick();
    } else {
      setState(() {
        widget.stopWatch.nativeStopWatch.stop();
        widget.stopWatch.isStopped = true;
      });
      widget.stopWatch.timer.cancel();
    }
  }

  void restart() {
    setState(() {
      if (widget.stopWatch.timer != null) {
        widget.stopWatch.timer.cancel();
      }
      widget.stopWatch.isStopped = true;
      widget.stopWatch.nativeStopWatch = null;
      widget.stopWatch.laps.clear();
      widget.stopWatch.duration = Duration();
    });
  }

  void lap() {
    setState(() {
      widget.stopWatch.laps.add(
          Lap(widget.stopWatch.duration, widget.stopWatch.laps.length + 1));
    });
  }

  /* 
*    ----- Build --- 
*/
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
        backgroundColor: themeData.backgroundColor,
        body: Center(
            child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              StopwatchText(widget.stopWatch.duration),
              Flex(
                direction: Axis.vertical,
                children: [
                  Text('Laps',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  Divider(
                    indent: 1,
                  ),
                  LapBuilder(widget.stopWatch.laps),
                ],
              ),
              ControlButtons(widget.stopWatch.isStopped, lap, play, restart),
            ])));
  }
}
