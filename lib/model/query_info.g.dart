// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryInfo _$QueryInfoFromJson(Map<String, dynamic> json) => QueryInfo(
      DateTimeParser.fromSecondsSinceEpoch(json['filmlisteTimestamp'] as num?),
      QueryInfo._DurationFromJson(json['searchEngineTime'] as String?),
      (json['resultCount'] as num?)?.toInt(),
      (json['totalResults'] as num?)?.toInt(),
    );

Map<String, dynamic> _$QueryInfoToJson(QueryInfo instance) => <String, dynamic>{
      'filmlisteTimestamp':
          DateTimeParser.toSecondsSinceEpoch(instance.filmlisteTimestamp),
      'searchEngineTime': QueryInfo._DurationToJson(instance.searchEngineTime),
      'resultCount': instance.resultCount,
      'totalResults': instance.totalResults,
    };
