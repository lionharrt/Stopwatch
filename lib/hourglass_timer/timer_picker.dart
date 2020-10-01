import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:hello_world/hourglass_timer/hourglass_timer.dart';

class TimerPicker extends StatelessWidget {
  final TimerPickerData timerPickerData;
  const TimerPicker({this.timerPickerData, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            margin: EdgeInsets.only(top: 100),
            child: TimePickerSpinner(
              time: timerPickerData.dateTime,
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
                timerPickerData.originalDuration = Duration(
                    hours: time.hour,
                    minutes: time.minute,
                    seconds: time.second);
                timerPickerData.dateTime =
                    DateTime(0, 0, 0, time.hour, time.minute, time.second);
              },
            )));
  }
}
