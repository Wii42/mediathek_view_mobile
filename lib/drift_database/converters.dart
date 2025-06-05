import 'package:drift/drift.dart';

class UriConverter extends TypeConverter<Uri?, String?> {
  const UriConverter();

  @override
  Uri? fromSql(String? fromDb) => fromDb == null ? null : Uri.parse(fromDb);

  @override
  String? toSql(Uri? value) => value?.toString();
}

class DurationConverter extends TypeConverter<Duration?, int?> {
  const DurationConverter();

  @override
  Duration? fromSql(int? fromDb) =>
      fromDb == null ? null : Duration(seconds: fromDb);

  @override
  int? toSql(Duration? value) => value?.inSeconds;
}
