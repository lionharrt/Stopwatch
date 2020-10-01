import 'package:flutter/material.dart';
import 'package:hello_world/hourglass_timer/custom_timer_painter.widget.dart';
import 'package:hello_world/common/displays_time.mixin.dart';

class AnimatedCooldown extends StatelessWidget with DisplaysTime {
  final AnimationController animationController;
  final bool isFinished;
  final Duration changingDuration;
  const AnimatedCooldown(
      {this.animationController,
      this.isFinished,
      this.changingDuration,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
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
                            animation: animationController,
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
                                isFinished
                                    ? 'Finished'
                                    : formatTimeHMS(changingDuration),
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
}
