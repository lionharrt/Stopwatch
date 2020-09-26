import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_world/data_storage.dart';
import 'package:hello_world/generic_button.dart';

class StopWatch {
  List<Lap> laps = [];
  Duration duration = Duration();
}

class Lap {
  static int lapsCounter = 0;
  int lapId;
  Duration duration;
  int lapCount;
  Lap(this.duration, this.lapCount);
}

class StopWatchPage extends StatefulWidget {
  final DataStorage dataStorage;
  StopWatchPage(this.dataStorage, {Key key, this.title}) : super(key: key);
  final String title;

  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.backgroundColor,
      body: Center(child: StopWatchWidget(widget.dataStorage.stopwatchState)),
    );
  }
}

class StopWatchWidget extends StatefulWidget {
  final StopWatch stopWatch;

  StopWatchWidget(this.stopWatch, {Key key}) : super(key: key);

  @override
  _StopWatchWidgetState createState() => _StopWatchWidgetState();
}

class _StopWatchWidgetState extends State<StopWatchWidget> {
/* 
*    ----- Properties --- 
*/
  bool isStopped = true;
  Timer timer;
  Stopwatch nativeStopWatch;

/* 
*    ----- Methods --- 
*/
  String formatTime(duration) {
    String minutes = duration.inMinutes.remainder(60) < 10
        ? '0${duration.inMinutes.remainder(60)}'
        : '${duration.inMinutes.remainder(60)}';
    String seconds = duration.inSeconds.remainder(60) < 10
        ? '0${duration.inSeconds.remainder(60)}'
        : '${duration.inSeconds.remainder(60)}';

    String milliseconds = '0${duration.inMilliseconds}';
    if (milliseconds.length > 2) {
      milliseconds = milliseconds.substring(
        "${duration.inMilliseconds}".length - 2,
        "${duration.inMilliseconds}".length - 0,
      );
    }

    return "$minutes:$seconds:$milliseconds";
  }

  void play() {
    if (isStopped) {
      setState(() {
        isStopped = false;
      });
      _tick();
    } else {
      setState(() {
        nativeStopWatch.stop();
        isStopped = true;
      });
      timer.cancel();
    }
  }

  void restart() {
    setState(() {
      timer.cancel();
      isStopped = true;
      nativeStopWatch = null;
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

  void _tick() {
    timer = Timer.periodic(Duration(milliseconds: 1), (Timer timer) {
      if (nativeStopWatch == null) {
        nativeStopWatch = Stopwatch();
        nativeStopWatch.start();
      } else {
        nativeStopWatch.start();
      }
      setState(() {
        widget.stopWatch.duration =
            Duration(milliseconds: nativeStopWatch.elapsedMilliseconds);
      });
    });
  }

/* 
*    ----- LifeCycle --- 
*/

  @override
  void dispose() {
    if (this.timer != null) {
      this.timer.cancel();
    }
    super.dispose();
  }

/* 
*    ----- Widgets --- 
*/
  Widget generateLap(Lap lap) {
    return Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Text("#${lap.lapCount}",
                style: TextStyle(
                  fontSize: 25.0,
                )),
          ),
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Text(formatTime(lap.duration),
                style: TextStyle(
                  fontSize: 25.0,
                )),
          )
        ]);
  }

  Widget getText() {
    return Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(top: 50),
        child: Text(
          formatTime(widget.stopWatch.duration),
          style: TextStyle(
            fontSize: 60.0,
          ),
        ));
  }

  Widget getButtons(ThemeData themeData) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GenericButton(
        icon: Icon(Icons.assistant_photo),
        method: lap,
        alignment: Alignment.bottomLeft,
        color: themeData.accentColor,
        elevation: 4.0,
        shape: CircleBorder(),
        size: 25,
        margin: EdgeInsets.only(bottom: 20, left: 45),
      ),
      GenericButton(
        icon: Icon(
          isStopped ? Icons.play_arrow : Icons.pause,
          size: 50,
        ),
        method: play,
        alignment: Alignment.bottomCenter,
        color: themeData.accentColor,
        elevation: 4.0,
        shape: CircleBorder(),
        size: 20,
        margin: EdgeInsets.only(
          bottom: 20,
        ),
      ),
      GenericButton(
        icon: Icon(Icons.refresh),
        method: restart,
        alignment: Alignment.bottomRight,
        color: themeData.accentColor,
        elevation: 4.0,
        shape: CircleBorder(),
        size: 25,
        margin: EdgeInsets.only(bottom: 20, right: 45),
      ),
    ]);
  }

  Widget getLapsBuilder() {
    return SizedBox(
      height: 250,
      child: new ListView.builder(
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 16.0,
          ),
          itemCount: widget.stopWatch.laps.length,
          itemBuilder: (BuildContext ctxt, int index) =>
              generateLap(widget.stopWatch.laps[index])),
    );
  }

  /* 
*    ----- Build --- 
*/
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getText(),
          Flex(
            direction: Axis.vertical,
            children: [
              Text('Laps', style: TextStyle(color: Colors.grey, fontSize: 16)),
              Divider(
                indent: 1,
              ),
              getLapsBuilder(),
            ],
          ),
          getButtons(themeData),
        ]);
  }
}
