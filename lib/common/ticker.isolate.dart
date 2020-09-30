import 'dart:async';
import 'dart:isolate';

class Ticker {
  bool _isRunning = false;
  bool _isPaused = false;
  Duration _ticks;
  StreamController<Duration> _controller;
  StreamSubscription _subscription;
  int _millisecondsPerTick = 1;

  Isolate isolate;

  bool get isPaused => _isPaused;
  bool get isRunning => _isRunning;
  Duration get ticks => _ticks;

  Ticker(this._millisecondsPerTick);
  Capability resumeCapability;

  void subscribe(Function onTimeChange) async {
    _controller = StreamController<Duration>();
    _subscription = _controller.stream.listen(onTimeChange);
  }

  void unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void start() async {
    this._isPaused = false;
    this._isRunning = true;
    ReceivePort receivePort = ReceivePort();
    if (isolate == null) {
      isolate = await Isolate.spawn(_tick, receivePort.sendPort);
      receivePort.listen(_reciever);
    } else {
      isolate.resume(resumeCapability);
    }
  }

  void pause() {
    this._isPaused = true;
    resumeCapability = isolate.pause();
  }

  void stop() {
    this._isPaused = false;
    _killIsolate();
    this._ticks = Duration();
    _controller.add(this._ticks);
  }

  void _reciever(dynamic data) {
    if (!this._isRunning) {
      return;
    }
    _ticks = Duration(milliseconds: data.inMilliseconds * _millisecondsPerTick);
    _controller.add(_ticks);
  }

  static void _tick(SendPort sendPort) {
    Stopwatch nativeStopWatch = Stopwatch();
    nativeStopWatch.start();
    Timer.periodic(Duration(milliseconds: 1), (Timer timer) {
      sendPort
          .send(Duration(milliseconds: nativeStopWatch.elapsedMilliseconds));
    });
  }

  void _killIsolate() {
    _isRunning = false;
    if (isolate != null) {
      print('killing isolate');
      isolate.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }
}
