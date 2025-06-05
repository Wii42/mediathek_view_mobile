class DateTimeParser {
  static DateTime? fromSecondsSinceEpoch(num? timestamp) => timestamp != null
      ? DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000,
          isUtc: true)
      : null;

  static int? toSecondsSinceEpoch(DateTime? dateTime) => dateTime != null
      ? (dateTime.millisecondsSinceEpoch / 1000).round()
      : null;

  static DateTime? fromSecondsSinceEpochString(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return null;
    return fromSecondsSinceEpoch(int.tryParse(timestamp));
  }

  static String? toSecondsSinceEpochString(DateTime? dateTime) {
    return toSecondsSinceEpoch(dateTime)?.toString();
  }
}
