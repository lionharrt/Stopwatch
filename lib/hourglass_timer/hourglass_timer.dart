import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:hello_world/hourglass_timer/animated_cooldown.dart';
import 'package:hello_world/hourglass_timer/control_buttons.dart';
import 'package:hello_world/hourglass_timer/frequent_timer_button_container.dart';
import 'package:hello_world/hourglass_timer/timer_picker.dart';

//!-- class is to keep timer picker widget stateless
class TimerPickerData {
  Duration originalDuration = Duration();
  Duration changingDuration = Duration();
  DateTime dateTime = DateTime(0);
}

class HourGlassTimer extends StatefulWidget {
  final List<Duration> frequentTimers;
  HourGlassTimer(this.frequentTimers, {Key key}) : super(key: key);

  @override
  _HourGlassTimerState createState() => _HourGlassTimerState();
}

class _HourGlassTimerState extends State<HourGlassTimer>
    with TickerProviderStateMixin {
  //*-----------------Properties--------------------//
  AnimationController controller;

  TimerPickerData timerPickerData = TimerPickerData();

  Timer timer;
  Stopwatch nativeStopWatch;

  bool showFrequentTimers = false;
  bool isStarted = false;
  bool isPaused = false;
  bool isFinished = false;

  DateTime newFrequentTime;

  //*-----------------LifeCycle--------------------//
  @override
  void initState() {
    super.initState();
    if (controller == null) {
      setState(() {
        controller = AnimationController(
          vsync: this,
          duration: Duration(),
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  //*-----------------Methods--------------------//
  void tick() {
    timer = Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
      // if stopwatch is not created  ? start
      if (nativeStopWatch == null) {
        nativeStopWatch = Stopwatch();
        nativeStopWatch.start();
      }
      if (timerPickerData.changingDuration.inMilliseconds < 350) {
        timerPickerData.changingDuration = Duration(
            milliseconds: timerPickerData.originalDuration.inMilliseconds -
                nativeStopWatch.elapsedMilliseconds);
        isFinished = true;
        timer.cancel();
      } else {}
      timerPickerData.changingDuration = Duration(
          milliseconds: timerPickerData.originalDuration.inMilliseconds -
              nativeStopWatch.elapsedMilliseconds);
    });
  }

  void play() {
    if (timerPickerData.originalDuration.inSeconds >= 1) {
      controller.duration = timerPickerData.originalDuration;
      //* --- handle animation --- //
      if (controller.isAnimating)
        controller.stop();
      else {
        controller.reverse(
            from: controller.value == 0.0 ? 1.0 : controller.value);
      }
      //* --- handle time --- //
      if (!isStarted) {
        setState(() {
          timerPickerData.changingDuration = timerPickerData.originalDuration;
          isStarted = true;
        });
        tick();
      } else if (isPaused && !isFinished) {
        setState(() {
          isPaused = false;
        });
        nativeStopWatch.start();
        tick();
      } else {
        // pausing
        setState(() {
          nativeStopWatch.stop();
          isPaused = true;
        });
        timer.cancel();
      }
    }
  }

  void repeat() {
    setState(() {
      isStarted = false;
      isFinished = false;
      timer.cancel();
      isPaused = false;
      controller.reset();
      nativeStopWatch = null;
      timerPickerData.changingDuration = Duration();
    });
    play();
  }

  void stop() {
    timer.cancel();
    controller.reset();
    nativeStopWatch = null;
    setState(() {
      timerPickerData.originalDuration = Duration();
      timerPickerData.changingDuration = Duration();
      isStarted = false;
      isPaused = false;
      isFinished = false;
    });
  }

  void toggleShowFrequentTimers() {
    setState(() {
      showFrequentTimers = !showFrequentTimers;
    });
  }

  void setTimeFromFrequent(int minutes) {
    setState(() {
      timerPickerData.dateTime = DateTime(0, 0, 0, 0, minutes);
      timerPickerData.originalDuration = Duration(minutes: minutes);
    });
  }

  void addNewFrequentTimer(BuildContext context) {
    Duration timeToAdd = Duration(
        hours: newFrequentTime.hour,
        minutes: newFrequentTime.minute,
        seconds: newFrequentTime.second);
    if (!widget.frequentTimers
        .any((element) => element.inMinutes == timeToAdd.inMinutes)) {
      widget.frequentTimers.add(timeToAdd);
    }
    Navigator.pop(context);
  }

  void removeFrequentTimer(int number) {
    widget.frequentTimers.removeWhere((timer) => timer.inMinutes == number);
  }

  showNewFrequentTimerModal() {
    this.newFrequentTime = DateTime(0);
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          ThemeData themeData = Theme.of(context);
          return Container(
              height: 200,
              color: themeData.accentColor,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TimePickerSpinner(
                    time: newFrequentTime,
                    spacing: 10,
                    isForce2Digits: true,
                    itemWidth: 40,
                    itemHeight: 40,
                    alignment: Alignment.center,
                    normalTextStyle: TextStyle(
                      fontSize: 25,
                    ),
                    highlightedTextStyle:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    isShowSeconds: true,
                    onTimeChange: (time) {
                      newFrequentTime = time;
                    },
                  ),
                  RaisedButton(
                    child: const Text('Add'),
                    color: themeData.buttonColor,
                    onPressed: () => addNewFrequentTimer(context),
                  )
                ],
              )));
        });
  }

  //*-----------------Build--------------------//
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) => Stack(children: [
              if (!isStarted)
                TimerPicker(
                  timerPickerData: timerPickerData,
                ),
              if (isStarted)
                AnimatedCooldown(
                  changingDuration: timerPickerData.changingDuration,
                  animationController: controller,
                  isFinished: isFinished,
                ),
              if (!isStarted && showFrequentTimers)
                FrequentTimerButtonContainer(
                  frequentTimers: widget.frequentTimers,
                  setTimeFromFrequent: setTimeFromFrequent,
                  showNewFrequentTimerModal: showNewFrequentTimerModal,
                  removeFrequentTimer: removeFrequentTimer,
                ),
              HourGlassTimerControlButtons(
                isFinished: isFinished,
                animationController: controller,
                isStarted: isStarted,
                play: play,
                stop: stop,
                repeat: repeat,
                toggleShowFrequentTimers: toggleShowFrequentTimers,
              ),
            ]));
  }
}
