import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:hello_world/hourglass_timer/animated_cooldown.widget.dart';
import 'package:hello_world/hourglass_timer/control_buttons_widget.dart';
import 'package:hello_world/hourglass_timer/frequent_timer_button_container.widget.dart';
import 'package:hello_world/hourglass_timer/hourglass_timer.class.dart';
import 'package:hello_world/hourglass_timer/timer_picker.widget.dart';

class HourGlassTimerPage extends StatefulWidget {
  final List<Duration> frequentTimers;
  final HourGlassTimer hourGlassTimer;
  HourGlassTimerPage(this.frequentTimers, this.hourGlassTimer, {Key key})
      : super(key: key);

  @override
  _HourGlassTimerPageState createState() => _HourGlassTimerPageState();
}

class _HourGlassTimerPageState extends State<HourGlassTimerPage>
    with TickerProviderStateMixin {
  //*-----------------Properties--------------------//
  DateTime newFrequentTime;
  //*-----------------LifeCycle--------------------//
  @override
  void initState() {
    super.initState();
    if (widget.hourGlassTimer.controller == null) {
      setState(() {
        widget.hourGlassTimer.controller = AnimationController(
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

  void play() {
    if (widget.hourGlassTimer.originalDuration.inSeconds >= 1) {
      widget.hourGlassTimer.controller.duration =
          widget.hourGlassTimer.originalDuration;
      //* --- handle animation --- //
      if (widget.hourGlassTimer.controller.isAnimating)
        widget.hourGlassTimer.controller.stop();
      else {
        widget.hourGlassTimer.controller.reverse(
            from: widget.hourGlassTimer.controller.value == 0.0
                ? 1.0
                : widget.hourGlassTimer.controller.value);
      }
      //* --- handle time --- //
      if (!widget.hourGlassTimer.isStarted) {
        setState(() {
          widget.hourGlassTimer.changingDuration =
              widget.hourGlassTimer.originalDuration;
          widget.hourGlassTimer.isStarted = true;
        });
        widget.hourGlassTimer.tick();
      } else if (widget.hourGlassTimer.isPaused &&
          !widget.hourGlassTimer.isFinished) {
        setState(() {
          widget.hourGlassTimer.isPaused = false;
        });
        widget.hourGlassTimer.nativeStopWatch.start();
        widget.hourGlassTimer.tick();
      } else {
        // pausing
        setState(() {
          widget.hourGlassTimer.nativeStopWatch.stop();
          widget.hourGlassTimer.isPaused = true;
        });
        widget.hourGlassTimer.timer.cancel();
      }
    }
  }

  void repeat() {
    setState(() {
      widget.hourGlassTimer.isStarted = false;
      widget.hourGlassTimer.isFinished = false;
      widget.hourGlassTimer.timer.cancel();
      widget.hourGlassTimer.isPaused = false;
      widget.hourGlassTimer.controller.reset();
      widget.hourGlassTimer.nativeStopWatch = null;
      widget.hourGlassTimer.changingDuration = Duration();
    });
    play();
  }

  void stop() {
    widget.hourGlassTimer.timer.cancel();
    widget.hourGlassTimer.controller.reset();
    widget.hourGlassTimer.nativeStopWatch = null;
    setState(() {
      widget.hourGlassTimer.originalDuration = Duration();
      widget.hourGlassTimer.changingDuration = Duration();
      widget.hourGlassTimer.isStarted = false;
      widget.hourGlassTimer.isPaused = false;
      widget.hourGlassTimer.isFinished = false;
    });
  }

  void toggleShowFrequentTimers() {
    setState(() {
      widget.hourGlassTimer.showFrequentTimers =
          !widget.hourGlassTimer.showFrequentTimers;
    });
  }

  void setTimeFromFrequent(int minutes) {
    setState(() {
      widget.hourGlassTimer.dateTime = DateTime(0, 0, 0, 0, minutes);
      widget.hourGlassTimer.originalDuration = Duration(minutes: minutes);
    });
    print(widget.hourGlassTimer.dateTime);
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

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.backgroundColor,
      body: AnimatedBuilder(
          animation: widget.hourGlassTimer.controller,
          builder: (context, child) => Stack(children: [
                if (!widget.hourGlassTimer.isStarted)
                  TimerPicker(
                    hourGlassTimer: widget.hourGlassTimer,
                  ),
                if (widget.hourGlassTimer.isStarted)
                  AnimatedCooldown(hourGlassTimer: widget.hourGlassTimer),
                if (!widget.hourGlassTimer.isStarted &&
                    widget.hourGlassTimer.showFrequentTimers)
                  FrequentTimerButtonContainer(
                    frequentTimers: widget.frequentTimers,
                    setTimeFromFrequent: setTimeFromFrequent,
                    showNewFrequentTimerModal: showNewFrequentTimerModal,
                    removeFrequentTimer: removeFrequentTimer,
                  ),
                HourGlassTimerControlButtons(
                  hourGlassTimer: widget.hourGlassTimer,
                  play: play,
                  stop: stop,
                  repeat: repeat,
                  toggleShowFrequentTimers: toggleShowFrequentTimers,
                )
              ])),
    );
  }
}
