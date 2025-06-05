import 'package:drift/drift.dart';
import 'package:flutter_ws/drift_database/converters.dart';

@DataClassName('VideoEntity')
class VideosTable extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().withLength(max: 256)();
  TextColumn get channel => text()();
  TextColumn get topic => text()();
  TextColumn get description => text().nullable()();
  TextColumn get title => text()();
  DateTimeColumn get timestamp => dateTime().nullable()();
  DateTimeColumn get timestampVideoSaved => dateTime().nullable()();
  IntColumn get duration =>
      integer().map(const DurationConverter()).nullable()();
  IntColumn get size => integer().nullable()();
  TextColumn get urlWebsite => text().map(const UriConverter()).nullable()();
  TextColumn get urlVideoLow => text().map(const UriConverter()).nullable()();
  TextColumn get urlVideoHd => text().map(const UriConverter()).nullable()();
  DateTimeColumn get filmlisteTimestamp => dateTime().nullable()();
  TextColumn get urlVideo => text().map(const UriConverter()).nullable()();
  TextColumn get urlSubtitle => text().map(const UriConverter()).nullable()();
  TextColumn get filePath => text().nullable()();
  TextColumn get fileName => text().nullable()();
  TextColumn get mimeType => text().nullable()();
  RealColumn get rating => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
