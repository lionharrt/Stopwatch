import 'dart:async';

import 'dart:isolate';

class StopWatch {
  List<Lap> laps = [];
  Duration duration = Duration();
  bool isStopped = true;
  Timer timer;
  Stopwatch nativeStopWatch;
  SendPort sendPort;

  void tick() {
    timer = Timer.periodic(Duration(milliseconds: 1), (Timer timer) {
      if (nativeStopWatch == null) {
        nativeStopWatch = Stopwatch();
        nativeStopWatch.start();
      } else {
        nativeStopWatch.start();
      }
      duration = Duration(milliseconds: nativeStopWatch.elapsedMilliseconds);
    });
  }
}

class Lap {
  static int lapsCounter = 0;
  int lapId;
  Duration duration;
  int lapCount;
  Lap(this.duration, this.lapCount);
}
