import 'package:flutter/material.dart';
import 'package:hello_world/common/generic_button.dart';
import 'package:hello_world/hourglass_timer/minute_button.widget.dart';

class FrequentTimerButtonContainer extends StatelessWidget {
  final List<Duration> frequentTimers;
  final Function setTimeFromFrequent;
  final Function showNewFrequentTimerModal;
  final Function removeFrequentTimer;
  const FrequentTimerButtonContainer(
      {this.frequentTimers,
      this.setTimeFromFrequent,
      this.showNewFrequentTimerModal,
      this.removeFrequentTimer,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final List<Widget> frequentTimerButtons = [];
    frequentTimers.forEach((e) {
      frequentTimerButtons.add(MinuteButton(
        number: e.inMinutes,
        pressMethod: setTimeFromFrequent,
        longPressMethod: removeFrequentTimer,
      ));
    });
    frequentTimerButtons.add(GenericButton(
        icon: Icon(Icons.add),
        alignment: null,
        margin: EdgeInsets.only(bottom: 120),
        method: showNewFrequentTimerModal,
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
                children: frequentTimerButtons)));
  }
}
