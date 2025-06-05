class DurationParser {
  static Duration? fromSeconds(num? timeS) =>
      timeS != null ? Duration(seconds: timeS.toInt()) : null;

  static int? toSeconds(Duration? duration) => duration?.inSeconds;
}
