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
  AnimationController controller;
  Duration duration = Duration();
  Timer timer;

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
      duration: Duration(seconds: 5),
    );
  }

  //-----------------Methods--------------------//
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
    controller.duration = duration;
    if (controller.isAnimating)
      controller.stop();
    else {
      controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value);
    }

    if (isPaused || !isStarted && !isFinished) {
      isStarted = true;
      isPaused = false;
      timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (duration.inSeconds == 0) {
          setState(() {
            isFinished = true;
          });
          timer.cancel();
        } else {}
        setState(() {
          duration = Duration(seconds: duration.inSeconds - 1);
        });
      });
    } else {
      setState(() {
        isPaused = true;
      });
      timer.cancel();
    }
  }

  void goBack() {
    setState(() {
      this.isStarted = false;
      this.isPaused = false;
      this.isFinished = false;
    });
  }

  //-----------------Widgets--------------------//
  Widget getPlayButton() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          child: RawMaterialButton(
            onPressed: () => play(),
            elevation: 2.0,
            fillColor: Colors.grey[800],
            child: Icon(
              Icons.play_arrow,
              size: 35.0,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          ),
        ));
  }

  Widget getBackButton() {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.only(left: 45, bottom: 20),
          child: RawMaterialButton(
            onPressed: () => {},
            elevation: 2.0,
            fillColor: Colors.grey[800],
            child: Icon(
              Icons.arrow_back,
              size: 35.0,
              color: Colors.white,
            ),
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
                  duration = Duration(
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
                                "Count Down Timer",
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black),
                              ),
                              Text(
                                "${formatNumber(duration.inHours)}:${formatNumber(duration.inMinutes)}:${formatNumber(duration.inSeconds)}",
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
    return Scaffold(
        backgroundColor: Colors.white10,
        body: AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Stack(children: [
                  if (!isStarted) getTimePicker(),
                  if (isStarted) getAnimatedCountdown(context),
                  getPlayButton(),
                  getBackButton()
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
