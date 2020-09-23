import 'dart:async';

import 'package:flutter/material.dart';

class Lap {
  int hours;
  int minutes;
  int seconds;
  int lapCount;
  Lap(this.hours, this.minutes, this.seconds, this.lapCount);
}

class StopWatch extends StatefulWidget {
  final Function(StopWatch) removeStopWatch;

  StopWatch(
    this.removeStopWatch, {
    Key key,
  }) : super(key: key);

  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  bool isPlaying = false;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  final List<Lap> laps = [];

  Timer timer;

  String formatNumber(int input) {
    if (input <= 9) {
      return "0$input";
    }
    return "$input";
  }

  void play() {
    if (!isPlaying) {
      setState(() {
        isPlaying = true;
      });
      timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (seconds == 59) {
          setState(() {
            seconds = 0;
          });
          if (minutes == 59) {
            setState(() {
              minutes = 0;
              hours++;
            });
          } else {
            setState(() {
              minutes++;
            });
          }
        } else {
          setState(() {
            seconds++;
          });
        }
      });
    } else {
      setState(() {
        isPlaying = false;
      });
      timer.cancel();
    }
  }

  void lap() {
    setState(() {
      laps.add(new Lap(
          this.hours, this.minutes, this.seconds, this.laps.length + 1));
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
            child: Text("#${lap.lapCount}:",
                style: TextStyle(
                  fontSize: 25.0,
                )),
          ),
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Text(
                "${formatNumber(lap.hours)}:${formatNumber(lap.minutes)}:${formatNumber(lap.seconds)}",
                style: TextStyle(
                  fontSize: 25.0,
                )),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height:
            double.parse('${laps.length > 0 ? 100 + (laps.length * 45) : 75}'),
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
                            "${formatNumber(hours)}:${formatNumber(minutes)}:${formatNumber(seconds)}",
                            style: TextStyle(
                              fontSize: 35.0,
                            ),
                          ),
                        )),
                    Spacer(),
                    Text('${widget.hashCode}'),
                    IconButton(
                      icon: Icon(Icons.assistant_photo),
                      tooltip: 'Lap',
                      onPressed: () => lap(),
                    ),
                    IconButton(
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      tooltip: 'Play',
                      onPressed: () => play(),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline),
                      tooltip: 'Delete Stopwatch',
                      onPressed: () => {widget.removeStopWatch(widget)},
                    ),
                  ]),
              if (laps.length > 0)
                Text('Laps',
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              Expanded(
                child: SizedBox(
                    height: 200.0,
                    child: new ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 16.0,
                        ),
                        itemCount: laps.length,
                        itemBuilder: (BuildContext ctxt, int index) =>
                            generateLap(laps[index]))),
              ),
              Divider(
                color: Colors.black,
              )
            ]));
  }
}
