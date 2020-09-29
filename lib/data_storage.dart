import 'package:hello_world/stopwatch.dart';
import 'package:hello_world/timer.dart';

class DataStorage {
  static final DataStorage _singleton = DataStorage._internal();
  final StopWatch stopwatchState = StopWatch();
  final List<Duration> frequentTimers = [
    Duration(minutes: 5),
    Duration(minutes: 10),
    Duration(minutes: 15)
  ];
  final HourGlassTimer hourGlassTimerState = HourGlassTimer();

  factory DataStorage() {
    return _singleton;
  }

  DataStorage._internal();
}
