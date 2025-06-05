import 'package:json_annotation/json_annotation.dart';

import '../util/date_time_parser.dart';

part 'query_info.g.dart';

@JsonSerializable()
class QueryInfo {
  @JsonKey(
    fromJson: DateTimeParser.fromSecondsSinceEpoch,
    toJson: DateTimeParser.toSecondsSinceEpoch,
  )
  DateTime? filmlisteTimestamp;
  @JsonKey(
    fromJson: _DurationFromJson,
    toJson: _DurationToJson,
  )
  Duration? searchEngineTime;
  int? resultCount;
  int? totalResults;

  QueryInfo(this.filmlisteTimestamp, this.searchEngineTime, this.resultCount,
      this.totalResults);

  static QueryInfo fromJson(Map<String, dynamic> json) =>
      _$QueryInfoFromJson(json);

  @override
  String toString() {
    return 'QueryInfo{filmlisteTimestamp: $filmlisteTimestamp, searchEngineTime: $searchEngineTime, resultCount: $resultCount, totalResults: $totalResults}';
  }

  Map<String, dynamic> toJson() => _$QueryInfoToJson(this);

  static Duration? _DurationFromJson(String? timeMs) => timeMs != null
      ? Duration(microseconds: (double.parse(timeMs) * 1000).round())
      : null;

  static String? _DurationToJson(Duration? duration) =>
      duration != null ? (duration.inMicroseconds / 1000).toString() : null;
}
