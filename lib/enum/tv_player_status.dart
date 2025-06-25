import 'package:collection/collection.dart';

enum TvPlayerStatus {
  playing("playing"),
  paused("paused"),
  stopped("stopped"),
  muted("muted"),
  unmuted("unmuted"),
  disconnected("disconnected");

  final String value;

  const TvPlayerStatus(this.value);

  static TvPlayerStatus? tryFromString(String status) {
    return TvPlayerStatus.values.firstWhereOrNull(
      (e) => e.value == status,
    );
  }
}
