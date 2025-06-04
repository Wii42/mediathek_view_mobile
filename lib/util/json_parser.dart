import 'dart:convert';

import 'package:flutter_ws/model/indexing_info.dart';
import 'package:flutter_ws/model/query_info.dart';
import 'package:flutter_ws/model/query_result.dart';
import 'package:flutter_ws/model/video.dart';

class JSONParser {
  static QueryResult parseQueryResult(String rawData) {
    Map parsedMap = jsonDecode(rawData);
    print("json keys: ${parsedMap.keys}");

    var resultUnparsed = parsedMap["result"];
    print("result keys: ${resultUnparsed.keys}");
    List<dynamic> unparsedResultList = resultUnparsed["results"];
    var unparsedQueryResult = resultUnparsed["queryInfo"];
    print("queryInfo: $unparsedQueryResult");

    QueryInfo queryInfo = QueryInfo.fromJson(unparsedQueryResult);
    print("queryInfo: ${queryInfo.toString()}");
    List<Video> videos =
        unparsedResultList.map((video) => Video.fromMap(video)).toList();

    QueryResult result = QueryResult();
    result.queryInfo = queryInfo;
    result.videos = videos;

    return result;
  }

  static IndexingInfo parseIndexingEvent(String rawData) {
    Map parsedBody = jsonDecode(rawData);
    IndexingInfo info =
        IndexingInfo.fromJson(parsedBody as Map<String, dynamic>);

    info.parsingProgress = (info.parserProgress! * 100).round();
    info.indexingProgress = (info.indexerProgress! * 100).round();

    return info;
  }
}
