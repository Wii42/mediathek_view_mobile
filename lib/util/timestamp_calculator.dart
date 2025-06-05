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
    String minutes =
        time.minute < 9 ? "0${time.minute}" : time.minute.toString();
    String day = time.day < 9 ? "0${time.day}" : time.day.toString();
    String month = time.month < 9 ? "0${time.month}" : time.month.toString();

    DateTime now = DateTime.now();
    bool isToday =
        time.year == now.year && time.month == now.month && time.day == now.day;

    String dateString = isToday ? "Heute" : "$day.$month.${time.year}";

    return "$dateString um ${time.hour}:$minutes";
  }
}
