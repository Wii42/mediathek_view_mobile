// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryResult _$QueryResultFromJson(Map<String, dynamic> json) => QueryResult(
      videos: (json['results'] as List<dynamic>?)
              ?.map((e) => Video.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      queryInfo: json['queryInfo'] == null
          ? null
          : QueryInfo.fromJson(json['queryInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QueryResultToJson(QueryResult instance) =>
    <String, dynamic>{
      'results': instance.videos.map((e) => e.toJson()).toList(),
      'queryInfo': instance.queryInfo?.toJson(),
    };
