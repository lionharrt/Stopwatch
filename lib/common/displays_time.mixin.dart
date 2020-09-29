class DisplaysTime {
  String formatTimeMSMs(duration) {
    String minutes = duration.inMinutes.remainder(60) < 10
        ? '0${duration.inMinutes.remainder(60)}'
        : '${duration.inMinutes.remainder(60)}';
    String seconds = duration.inSeconds.remainder(60) < 10
        ? '0${duration.inSeconds.remainder(60)}'
        : '${duration.inSeconds.remainder(60)}';

    String milliseconds = '0${duration.inMilliseconds}';
    if (milliseconds.length > 2) {
      milliseconds = milliseconds.substring(
        "${duration.inMilliseconds}".length - 2,
        "${duration.inMilliseconds}".length - 0,
      );
    }

    return "$minutes:$seconds:$milliseconds";
  }

  String formatTimeHMS(Duration duration) {
    String hours =
        duration.inHours < 10 ? '0${duration.inHours}' : '${duration.inHours}';
    String minutes = duration.inMinutes % 60 < 10
        ? '0${duration.inMinutes % 60}'
        : '${duration.inMinutes % 60}';
    String seconds = duration.inSeconds % 60 < 10
        ? '0${duration.inSeconds % 60}'
        : '${duration.inSeconds % 60}';

    print("$hours:$minutes:$seconds");
    return "$hours:$minutes:$seconds";
  }
}
