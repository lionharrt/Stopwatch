import 'package:hello_world/common/ticker.isolate.dart';
import 'package:hello_world/hourglass_timer/hourglass_timer.class.dart';
import 'package:hello_world/stopwatch/stopwatch.class.dart';

class DataStorage {
  static final DataStorage _singleton = DataStorage._internal();
  final StopWatch stopwatchState = StopWatch(Ticker(1));
  final HourGlassTimer hourGlassTimerState = HourGlassTimer(
      [Duration(minutes: 5), Duration(minutes: 10), Duration(minutes: 15)]);

  factory DataStorage() {
    return _singleton;
  }

  DataStorage._internal();
}
