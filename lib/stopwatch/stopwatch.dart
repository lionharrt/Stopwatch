import 'package:flutter/material.dart';
import 'package:hello_world/stopwatch/stopwatch.class.dart';

class StopWatchPage extends StatefulWidget {
  final StopWatch stopWatch;
  StopWatchPage(this.stopWatch, {Key key}) : super(key: key);

  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
        backgroundColor: themeData.backgroundColor,
        body: Center(child: widget.stopWatch));
  }
}
