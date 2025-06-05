import 'package:json_annotation/json_annotation.dart';

import '../model/query_result.dart';

part 'api_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ApiResponse {
  QueryResult? result;
  Object? error;

  ApiResponse({this.result, this.error});

  static ApiResponse fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
