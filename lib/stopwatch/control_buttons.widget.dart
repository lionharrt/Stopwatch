import 'package:hello_world/generic_button.dart';
import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  final Function lapFunction;
  final Function playFunction;
  final Function restartFunction;
  final bool isStopped;
  const ControlButtons(
      this.isStopped, this.lapFunction, this.playFunction, this.restartFunction,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GenericButton(
        icon: Icon(Icons.assistant_photo),
        method: lapFunction,
        alignment: Alignment.bottomLeft,
        color: themeData.accentColor,
        elevation: 4.0,
        shape: CircleBorder(),
        size: 25,
        margin: EdgeInsets.only(bottom: 20, left: 45),
      ),
      GenericButton(
        icon: Icon(
          isStopped ? Icons.play_arrow : Icons.pause,
          size: 50,
        ),
        method: playFunction,
        alignment: Alignment.bottomCenter,
        color: themeData.accentColor,
        elevation: 4.0,
        shape: CircleBorder(),
        size: 20,
        margin: EdgeInsets.only(
          bottom: 20,
        ),
      ),
      GenericButton(
        icon: Icon(Icons.refresh),
        method: restartFunction,
        alignment: Alignment.bottomRight,
        color: themeData.accentColor,
        elevation: 4.0,
        shape: CircleBorder(),
        size: 25,
        margin: EdgeInsets.only(bottom: 20, right: 45),
      ),
    ]);
  }
}
