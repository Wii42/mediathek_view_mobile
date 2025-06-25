import 'package:collection/collection.dart';

enum TvStatus {
  isSupported("ready"),
  unsupported("not_ready"),
  currentlyChecking("currently_checking"),
  notYetChecked("not_yet_checked");

  final String value;

  const TvStatus(this.value);

  static TvStatus? tryFromString(String value) {
    return TvStatus.values.firstWhereOrNull(
      (status) => status.value == value,
    );
  }
}
