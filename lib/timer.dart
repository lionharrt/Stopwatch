import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:hello_world/generic_button.dart';

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

  void _tick() {
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
  //*-----------------Listeners--------------------//

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
  String formatTime() {
    String hours = widget.hourGlassTimer.changingDuration.inHours < 10
        ? '0${widget.hourGlassTimer.changingDuration.inHours}'
        : '${widget.hourGlassTimer.changingDuration.inHours}';
    String minutes = widget.hourGlassTimer.changingDuration.inMinutes % 60 < 10
        ? '0${widget.hourGlassTimer.changingDuration.inMinutes % 60}'
        : '${widget.hourGlassTimer.changingDuration.inMinutes % 60}';
    String seconds = widget.hourGlassTimer.changingDuration.inSeconds % 60 < 10
        ? '0${widget.hourGlassTimer.changingDuration.inSeconds % 60}'
        : '${widget.hourGlassTimer.changingDuration.inSeconds % 60}';

    print("$hours:$minutes:$seconds");
    return "$hours:$minutes:$seconds";
  }

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
        widget.hourGlassTimer._tick();
      } else if (widget.hourGlassTimer.isPaused &&
          !widget.hourGlassTimer.isFinished) {
        setState(() {
          widget.hourGlassTimer.isPaused = false;
        });
        widget.hourGlassTimer.nativeStopWatch.start();
        widget.hourGlassTimer._tick();
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

  void onComplete() {
    this.setState(() {});
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

  // *-----------------Widgets--------------------//
  Widget getNumberButton(
      int number, EdgeInsets margin, Function method, BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      margin: margin,
      child: RawMaterialButton(
        onPressed: () => method(number),
        elevation: 2.0,
        fillColor: themeData.accentColor,
        child: Column(children: [
          Text('$number',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          Text('mins', style: TextStyle(fontWeight: FontWeight.w400))
        ]),
        padding: EdgeInsets.all(12),
        shape: CircleBorder(),
      ),
    );
  }

  Widget getTimePicker() {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            margin: EdgeInsets.only(top: 100),
            child: TimePickerSpinner(
              time: widget.hourGlassTimer.dateTime,
              spacing: 5,
              isForce2Digits: true,
              itemWidth: 80,
              itemHeight: 80,
              alignment: Alignment.center,
              normalTextStyle: TextStyle(
                fontSize: 35,
              ),
              highlightedTextStyle:
                  TextStyle(fontSize: 45, fontWeight: FontWeight.w600),
              isShowSeconds: true,
              onTimeChange: (time) {
                setState(() {
                  widget.hourGlassTimer.originalDuration = Duration(
                      hours: time.hour,
                      minutes: time.minute,
                      seconds: time.second);
                  widget.hourGlassTimer.dateTime =
                      DateTime(0, 0, 0, time.hour, time.minute, time.second);
                });
              },
            )));
  }

  Widget getAnimatedCountdown(ThemeData themeData) {
    return Padding(
        padding: EdgeInsets.all(60.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: FractionalOffset.topCenter,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: CustomPaint(
                              painter: CustomTimerPainter(
                            animation: widget.hourGlassTimer.controller,
                            backgroundColor: Colors.white,
                            color: themeData.accentColor,
                          )),
                        ),
                        Align(
                          alignment: FractionalOffset.topCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.hourGlassTimer.isFinished
                                    ? 'Finished'
                                    : formatTime(),
                                style: TextStyle(
                                    fontSize: 60.0, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ]));
  }

  Widget getFrequentTimerButtons(ThemeData themeData) {
    List<Widget> frequentTimers = [];
    widget.frequentTimers.forEach((e) {
      frequentTimers.add(getNumberButton(e.inMinutes,
          EdgeInsets.only(bottom: 120), setTimeFromFrequent, context));
    });
    frequentTimers.add(GenericButton(
        icon: Icon(Icons.add),
        alignment: null,
        margin: EdgeInsets.only(bottom: 120),
        method: toggleShowFrequentTimers,
        size: 25,
        elevation: 4,
        color: themeData.accentColor,
        shape: CircleBorder()));

    return Container(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: frequentTimers)));
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
                  if (!widget.hourGlassTimer.isStarted) getTimePicker(),
                  if (widget.hourGlassTimer.isStarted)
                    getAnimatedCountdown(themeData),
                  if (!widget.hourGlassTimer.isStarted &&
                      widget.hourGlassTimer.showFrequentTimers)
                    getFrequentTimerButtons(themeData),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!widget.hourGlassTimer.isFinished)
                        Expanded(
                            child: GenericButton(
                                icon: Icon(
                                  widget.hourGlassTimer.controller.isAnimating
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 50,
                                ),
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.only(left: 135, bottom: 20),
                                method: play,
                                size: 20,
                                elevation: 4,
                                color: themeData.accentColor,
                                shape: CircleBorder())),
                      if (!widget.hourGlassTimer.isStarted)
                        GenericButton(
                            icon: Icon(Icons.add),
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.only(right: 45, bottom: 30),
                            method: toggleShowFrequentTimers,
                            size: 25,
                            elevation: 4,
                            color: themeData.accentColor,
                            shape: CircleBorder()),
                      if (!widget.hourGlassTimer.isFinished &&
                          widget.hourGlassTimer.isStarted)
                        GenericButton(
                            icon: Icon(Icons.stop),
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.only(right: 45, bottom: 30),
                            method: stop,
                            size: 25,
                            elevation: 4,
                            color: themeData.accentColor,
                            shape: CircleBorder()),
                      if (widget.hourGlassTimer.isFinished)
                        Expanded(
                            child: GenericButton(
                                icon: Icon(
                                  Icons.replay,
                                  size: 50,
                                ),
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.only(left: 135, bottom: 20),
                                method: repeat,
                                size: 25,
                                elevation: 4,
                                color: themeData.accentColor,
                                shape: CircleBorder())),
                      if (widget.hourGlassTimer.isFinished)
                        GenericButton(
                            icon: Icon(Icons.keyboard_return),
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(right: 45, bottom: 30),
                            method: stop,
                            size: 25,
                            elevation: 4,
                            color: themeData.accentColor,
                            shape: CircleBorder())
                    ],
                  )
                ])));
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
