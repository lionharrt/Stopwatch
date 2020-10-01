import 'package:flutter/material.dart';
import 'package:hello_world/common/generic_button.dart';

class HourGlassTimerControlButtons extends StatelessWidget {
  final bool isFinished;
  final bool isStarted;
  final AnimationController animationController;
  final Function play;
  final Function stop;
  final Function repeat;
  final Function toggleShowFrequentTimers;
  const HourGlassTimerControlButtons(
      {this.isFinished,
      this.isStarted,
      this.animationController,
      this.play,
      this.stop,
      this.repeat,
      this.toggleShowFrequentTimers,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!isFinished)
          Expanded(
              child: GenericButton(
                  icon: Icon(
                    animationController.isAnimating
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
        if (!isStarted)
          GenericButton(
              icon: Icon(Icons.add),
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right: 45, bottom: 30),
              method: toggleShowFrequentTimers,
              size: 25,
              elevation: 4,
              color: themeData.accentColor,
              shape: CircleBorder()),
        if (!isFinished && isStarted)
          GenericButton(
              icon: Icon(Icons.stop),
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right: 45, bottom: 30),
              method: stop,
              size: 25,
              elevation: 4,
              color: themeData.accentColor,
              shape: CircleBorder()),
        if (isFinished)
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
        if (isFinished)
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
    );
  }
}
