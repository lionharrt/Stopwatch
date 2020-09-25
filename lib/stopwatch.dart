import 'dart:async';

import 'package:flutter/material.dart';

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
  StopWatchPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  final List<StopWatch> stopwatches = [];
  // final List<StopWatchWidget> stopwatches = [];

  void addStopWatch() {
    setState(() {
      stopwatches.add(StopWatch());
    });
  }

  // void printStopWatches() {
  //   stopwatches.asMap().forEach((index, StopWatchWidget value) {
  //     print('$index ${value.hashCode}');
  //   });
  // }

  void removeStopWatch(StopWatch stopwatch) {
    final int index = stopwatches.indexOf(stopwatch);
    setState(() {
      stopwatches.removeAt(index);
    });
  }

  void removeAllStopWatches() {
    setState(() {
      stopwatches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ListView.builder(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 16.0,
              ),
              itemCount: stopwatches.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return StopWatchWidget(stopwatches[index], removeStopWatch);
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: addStopWatch,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class StopWatchWidget extends StatefulWidget {
  final Function(StopWatch) removeStopWatch;
  final StopWatch stopWatch;

  StopWatchWidget(this.stopWatch, this.removeStopWatch, {Key key})
      : super(key: key);

  @override
  _StopWatchWidgetState createState() => _StopWatchWidgetState();
}

class _StopWatchWidgetState extends State<StopWatchWidget> {
  bool isStopped = true;
  Timer timer;

  String formatNumber(int input) {
    if (input <= 9) {
      return "0$input";
    } else if (input > 99 && input < 999) {
      return "0$input".substring(1, 3);
    } else if (input > 999) {
      return "$input".substring(1, 3);
    }
    return "$input";
  }

  void play() {
    if (isStopped) {
      isStopped = false;
      timer = Timer.periodic(Duration(milliseconds: 10), (Timer timer) {
        widget.stopWatch.duration = Duration(
            milliseconds: widget.stopWatch.duration.inMilliseconds + 10);
        setState(() {});
      });
    } else {
      setState(() {
        isStopped = true;
      });
      timer.cancel();
    }
  }

  void lap() {
    setState(() {
      widget.stopWatch.laps.add(
          Lap(widget.stopWatch.duration, widget.stopWatch.laps.length + 1));
    });
  }

  @override
  void dispose() {
    if (this.timer != null) {
      this.timer.cancel();
    }
    super.dispose();
  }

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
            child: Text(
                "${formatNumber(lap.duration.inMinutes)}:${formatNumber(lap.duration.inSeconds)}:${formatNumber(lap.duration.inMilliseconds)}",
                style: TextStyle(
                  fontSize: 25.0,
                )),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.parse(
            '${widget.stopWatch.laps.length > 0 ? 110 + (widget.stopWatch.laps.length * 45) : 75}'),
        child: Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flex(
                  direction: Axis.horizontal,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 16),
                        child: Center(
                          child: Text(
                            "${formatNumber(widget.stopWatch.duration.inMinutes)}:${formatNumber(widget.stopWatch.duration.inSeconds)}:${formatNumber(widget.stopWatch.duration.inMilliseconds)}",
                            style: TextStyle(
                              fontSize: 35.0,
                            ),
                          ),
                        )),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.assistant_photo),
                      tooltip: 'Lap',
                      onPressed: () => lap(),
                    ),
                    IconButton(
                      icon: Icon(isStopped ? Icons.play_arrow : Icons.pause),
                      tooltip: 'Play',
                      onPressed: () => play(),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline),
                      tooltip: 'Delete Stopwatch',
                      onPressed: () =>
                          {widget.removeStopWatch(widget.stopWatch)},
                    ),
                  ]),
              if (widget.stopWatch.laps.length > 0)
                Text('Laps',
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              if (widget.stopWatch.laps.length > 0)
                Divider(
                  indent: 1,
                ),
              Expanded(
                child: SizedBox(
                    height: 200.0,
                    child: new ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 16.0,
                        ),
                        itemCount: widget.stopWatch.laps.length,
                        itemBuilder: (BuildContext ctxt, int index) =>
                            generateLap(widget.stopWatch.laps[index]))),
              ),
              Divider(
                color: Colors.black,
              )
            ]));
  }
}
