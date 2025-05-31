class Calculator {
  static String calculateDuration(Duration duration) {
    try {
      int sekunden = duration.inSeconds;
      if (sekunden == 1) {
        return "1 sek";
      } else if (sekunden < 60) {
        return "$sekunden sek";
      }

      int minuten = (sekunden / 60).floor();
      if (minuten < 60) return "$minuten min";

      int stunden = (minuten / 60).floor();
      int verbleibendeMinuten = minuten % 60;

      return verbleibendeMinuten == 0
          ? "$stunden h "
          : "$stunden h $verbleibendeMinuten min";
    } catch (e) {
      return "";
    }
  }

  static String calculateTimestamp(DateTime time) {
    var minutes = time.minute < 9 ? "0${time.minute}" : time.minute.toString();
    var day = time.day < 9 ? "0${time.day}" : time.day.toString();
    var month = time.month < 9 ? "0${time.month}" : time.month.toString();

    return "$day.$month.${time.year} um ${time.hour}:$minutes";
  }
}
