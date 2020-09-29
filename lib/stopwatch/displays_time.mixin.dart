class DisplaysTime {
  String formatTime(duration) {
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
}
