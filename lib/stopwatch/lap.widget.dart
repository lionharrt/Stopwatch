import 'package:flutter/cupertino.dart';
import 'package:hello_world/common/displays_time.mixin.dart';
import 'package:hello_world/stopwatch/stopwatch.dart';

class LapWidget extends StatelessWidget with DisplaysTime {
  final Lap lap;
  const LapWidget(this.lap, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Text("#${lap.lapCount}",
                style: TextStyle(
                  fontSize: 25.0,
                )),
          ),
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Text(formatTimeMSMs(lap.duration),
                style: TextStyle(
                  fontSize: 25.0,
                )),
          )
        ]);
  }
}

class LapBuilder extends StatelessWidget {
  final List<Lap> laps;
  const LapBuilder(this.laps, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
      height: 250,
      child: new ListView.builder(
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 16.0,
          ),
          itemCount: laps.length,
          itemBuilder: (BuildContext ctxt, int index) =>
              LapWidget(laps[index])),
    ));
  }
}
