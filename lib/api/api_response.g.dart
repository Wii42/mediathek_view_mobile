// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) => ApiResponse(
      result: json['result'] == null
          ? null
          : QueryResult.fromJson(json['result'] as Map<String, dynamic>),
      error: json['error'],
    );

Map<String, dynamic> _$ApiResponseToJson(ApiResponse instance) =>
    <String, dynamic>{
      'result': instance.result?.toJson(),
      'error': instance.error,
    };
