import 'dart:async';

import 'package:flutter/animation.dart';

class HourGlassTimer {
  AnimationController controller;

  Duration originalDuration = Duration();
  Duration changingDuration = Duration();

  Timer timer;
  Stopwatch nativeStopWatch;

  bool showFrequentTimers = false;
  bool isStarted = false;
  bool isPaused = false;
  bool isFinished = false;
  DateTime dateTime = DateTime(0);

  void tick() {
    timer = Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
      // if stopwatch is not created  ? start
      if (nativeStopWatch == null) {
        nativeStopWatch = Stopwatch();
        nativeStopWatch.start();
      }
      if (changingDuration.inMilliseconds < 350) {
        changingDuration = Duration(
            milliseconds: originalDuration.inMilliseconds -
                nativeStopWatch.elapsedMilliseconds);
        isFinished = true;
        timer.cancel();
      } else {}
      changingDuration = Duration(
          milliseconds: originalDuration.inMilliseconds -
              nativeStopWatch.elapsedMilliseconds);
    });
  }
}
