import 'package:flutter_ws/model/query_info.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query_result.g.dart';

@JsonSerializable(explicitToJson: true)
class QueryResult {
  @JsonKey(name: "results", defaultValue: [])
  List<Video> videos;
  QueryInfo? queryInfo;

  QueryResult({this.videos = const [], this.queryInfo});

  static QueryResult fromJson(Map<String, dynamic> json) =>
      _$QueryResultFromJson(json);

  Map<String, dynamic> toJson() => _$QueryResultToJson(this);

  @override
  String toString() {
    return 'QueryResult{videos: $videos, queryInfo: $queryInfo}';
  }
}
