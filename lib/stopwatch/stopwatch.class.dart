import 'package:flutter/material.dart';
import 'package:hello_world/common/ticker.isolate.dart';
import 'package:hello_world/stopwatch/control_buttons.widget.dart';
import 'package:hello_world/stopwatch/lap.widget.dart';
import 'package:hello_world/stopwatch/stopwatch_text.widget.dart';

class StopWatch extends StatefulWidget {
  final List<Lap> laps = [];
  final Ticker ticker;
  StopWatch(this.ticker, {Key key}) : super(key: key);

  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  //*-----------------Properties--------------------//
  Duration duration = Duration();
  bool isStopped = true;
  Stopwatch nativeStopWatch;

//*-----------------LifeCycle--------------------//
  @override
  void initState() {
    super.initState();
    widget.ticker.subscribe(onTimeChange);
    if (widget.ticker.ticks != null) {
      setState(() {
        duration = widget.ticker.ticks;
      });
    }
    if (widget.ticker.isRunning) {
      setState(() {
        isStopped = false;
      });
    }
  }

  @override
  void dispose() {
    if (widget.ticker != null) {
      widget.ticker.unsubscribe();
    }
    super.dispose();
  }

//*-----------------Methods--------------------//

  void onTimeChange(Duration ticks) {
    print('message: $ticks');
    setState(() {
      duration = ticks;
    });
  }

  void play() async {
    if (isStopped) {
      setState(() {
        widget.ticker.start();
        isStopped = false;
      });
    } else {
      setState(() {
        isStopped = true;
        widget.ticker.pause();
      });
    }
  }

  void restart() {
    setState(() {
      isStopped = true;
      nativeStopWatch = null;
      widget.laps.clear();
      duration = Duration();
      widget.ticker.stop();
    });
  }

  void lap() {
    setState(() {
      widget.laps.add(Lap(duration, widget.laps.length + 1));
    });
  }

//*-----------------Build--------------------//
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          StopwatchText(duration),
          Flex(
            direction: Axis.vertical,
            children: [
              Text('Laps', style: TextStyle(color: Colors.grey, fontSize: 16)),
              Divider(
                indent: 1,
              ),
              LapBuilder(widget.laps),
            ],
          ),
          ControlButtons(isStopped, lap, play, restart),
        ]));
  }
}

class Lap {
  static int lapsCounter = 0;
  int lapId;
  Duration duration;
  int lapCount;
  Lap(this.duration, this.lapCount);
}
