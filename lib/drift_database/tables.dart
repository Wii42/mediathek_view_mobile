import 'package:drift/drift.dart';
import 'package:flutter_ws/drift_database/converters.dart';

@DataClassName('VideoEntity')
class Videos extends Table with VideoMixin {
  TextColumn get taskId => text().withLength(max: 256)();
  DateTimeColumn get timestampVideoSaved => dateTime().nullable()();
  TextColumn get filePath => text().nullable()();
  TextColumn get fileName => text().nullable()();
  TextColumn get mimeType => text().nullable()();
  RealColumn get rating => real().nullable()();
}

mixin VideoMixin on Table {
  TextColumn get id => text()();
  TextColumn get channel => text()();
  TextColumn get topic => text()();
  TextColumn get description => text().nullable()();
  TextColumn get title => text()();
  DateTimeColumn get timestamp => dateTime().nullable()();
  IntColumn get duration =>
      integer().map(const DurationConverter()).nullable()();
  IntColumn get size => integer().nullable()();
  TextColumn get urlWebsite => text().map(const UriConverter()).nullable()();
  TextColumn get urlVideoLow => text().map(const UriConverter()).nullable()();
  TextColumn get urlVideoHd => text().map(const UriConverter()).nullable()();
  DateTimeColumn get filmlisteTimestamp => dateTime().nullable()();
  TextColumn get urlVideo => text().map(const UriConverter()).nullable()();
  TextColumn get urlSubtitle => text().map(const UriConverter()).nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('VideoProgressEntity')
class VideoProgress extends Table {
  IntColumn get progress =>
      integer().map(const DurationConverter()).nullable()();
  DateTimeColumn get timestampLastViewed => dateTime().nullable()();
}

class ChannelFavorites extends Table {
  TextColumn get channelName => text()();
  TextColumn get groupName => text()();
  TextColumn get logo => text()();
  TextColumn get url => text().map(const UriConverter())();

  @override
  Set<Column<Object>> get primaryKey => {channelName};
}
