import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class HourGlassTimerPage extends StatefulWidget {
  HourGlassTimerPage({Key key}) : super(key: key);

  @override
  _HourGlassTimerPageState createState() => _HourGlassTimerPageState();
}

class _HourGlassTimerPageState extends State<HourGlassTimerPage>
    with TickerProviderStateMixin {
  //-----------------Properties--------------------//
  AnimationController controller;

  Duration originalDuration = Duration();
  Duration changingDuration = Duration();

  Timer timer;
  Stopwatch nativeStopWatch;

  bool isStarted = false;
  bool isPaused = false;
  bool isFinished = false;
  DateTime dateTime = DateTime(2000);

//-----------------LifeCycle--------------------//
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    controller.dispose();
    super.dispose();
  }

  //-----------------Methods--------------------//
  String formatTime() {
    String hours = changingDuration.inHours < 10
        ? '0${changingDuration.inHours}'
        : '${changingDuration.inHours}';
    String minutes = changingDuration.inMinutes % 60 < 10
        ? '0${changingDuration.inMinutes % 60}'
        : '${changingDuration.inMinutes % 60}';
    String seconds = changingDuration.inSeconds % 60 < 10
        ? '0${changingDuration.inSeconds % 60}'
        : '${changingDuration.inSeconds % 60}';

    print("$hours:$minutes:$seconds");
    return "$hours:$minutes:$seconds";
  }

  void play() {
    if (originalDuration.inSeconds >= 1) {
      controller.duration = originalDuration;
      // --- handle animation --- //
      if (controller.isAnimating)
        controller.stop();
      else {
        controller.reverse(
            from: controller.value == 0.0 ? 1.0 : controller.value);
      }
      // --- handle time --- //
      if (!isStarted) {
        setState(() {
          changingDuration = originalDuration;
          isStarted = true;
        });
        _tick();
      } else if (isPaused && !isFinished) {
        setState(() {
          isPaused = false;
        });
        nativeStopWatch.start();
        _tick();
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
      isFinished = false;
    });
    play();
  }

  void _tick() {
    timer = Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
      // if stopwatch is not created  ? start
      if (nativeStopWatch == null) {
        nativeStopWatch = Stopwatch();
        nativeStopWatch.start();
      }
      if (changingDuration.inMilliseconds < 250) {
        setState(() {
          changingDuration = Duration(
              milliseconds: originalDuration.inMilliseconds -
                  nativeStopWatch.elapsedMilliseconds);
          isFinished = true;
        });
        timer.cancel();
      } else {}
      setState(() {
        changingDuration = Duration(
            milliseconds: originalDuration.inMilliseconds -
                nativeStopWatch.elapsedMilliseconds);
      });
    });
  }

  void stop() {
    timer.cancel();
    controller.reset();
    nativeStopWatch = null;
    setState(() {
      originalDuration = Duration();
      changingDuration = Duration();
      isStarted = false;
      isPaused = false;
      isFinished = false;
    });
  }

  //-----------------Widgets--------------------//
  Widget getButton(IconData icon, Alignment alignment, EdgeInsets margin,
      Function method, BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Align(
        alignment: alignment,
        child: Container(
          margin: margin,
          child: RawMaterialButton(
            onPressed: () => method(),
            elevation: 2.0,
            fillColor: themeData.accentColor,
            child:
                Icon(icon, size: 35.0, color: themeData.accentIconTheme.color),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          ),
        ));
  }

  Widget getTimePicker() {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            margin: EdgeInsets.only(top: 100),
            child: TimePickerSpinner(
              time: dateTime,
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
                  originalDuration = Duration(
                      hours: time.hour,
                      minutes: time.minute,
                      seconds: time.second);
                });
              },
            )));
  }

  Widget getAnimatedCountdown(context) {
    ThemeData themeData = Theme.of(context);
    return Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: FractionalOffset.center,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: CustomPaint(
                              painter: CustomTimerPainter(
                            animation: controller,
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
                                isFinished ? 'Finished' : formatTime(),
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
  //-----------------Build--------------------//

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
        backgroundColor: themeData.backgroundColor,
        body: AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Stack(children: [
                  if (!isStarted) getTimePicker(),
                  if (isStarted) getAnimatedCountdown(context),
                  if (!isFinished)
                    getButton(
                        controller.isAnimating ? Icons.pause : Icons.play_arrow,
                        Alignment.bottomCenter,
                        EdgeInsets.only(bottom: 20),
                        play,
                        context),
                  if (!isFinished)
                    getButton(Icons.stop, Alignment.bottomRight,
                        EdgeInsets.only(right: 45, bottom: 20), stop, context),
                  if (isFinished)
                    getButton(Icons.replay, Alignment.bottomCenter,
                        EdgeInsets.only(bottom: 20), repeat, context)
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
