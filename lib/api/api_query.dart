import 'dart:convert';

import 'package:flutter_ws/widgets/filterMenu/video_length_slider.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../global_state/filter_menu_state.dart';
import '../widgets/filterMenu/search_filter.dart';

class APIQuery {
  final Logger logger = Logger('WebsocketController');

  //callbacks
  void Function(String) onDataReceived;
  void Function(Object, StackTrace) onError;

  static int skip = 0;
  static const int defaultQueryAmount = 60;
  Uri requestUri = Uri.parse('https://mediathekviewweb.de/api/query');

  APIQuery({required this.onDataReceived, required this.onError});

  void search(String? genericQuery, SearchFilters searchFilters) {
    logger.info("Query skip: $skip");

    List<Map<String, dynamic>> queryFilters =
        _buildSearchFilterList(searchFilters, genericQuery);

    Map<String, dynamic> request = {
      "queries": queryFilters,
      "future": searchFilters.includeFutureVideos?.filterValue ?? false,
      "sortBy": "timestamp",
      "sortOrder": "desc",
      "offset": skip,
      "size": defaultQueryAmount,
      ...videoLength(searchFilters.videoLength),
    };

    String requestString = json.encode(request);
    logger.info("Firing request: $requestString");

    execute(requestString);

    skip = skip + defaultQueryAmount;
  }

  List<Map<String, dynamic>> _buildSearchFilterList(
      SearchFilters searchFilters, String? genericQuery) {
    List<Map<String, dynamic>> queryFilters = [];

    if (searchFilters.title != null &&
        searchFilters.title!.filterValue.isNotEmpty) {
      queryFilters.add({
        "fields": ["title"],
        "query": searchFilters.title!.filterValue.toLowerCase()
      });
    }

    if (searchFilters.topic != null &&
        searchFilters.topic!.filterValue.isNotEmpty &&
        genericQuery != null &&
        genericQuery.isNotEmpty) {
      //generics -> title only
      queryFilters.add({
        "fields": ["title"],
        "query": genericQuery.toLowerCase()
      });
    } else if (genericQuery != null && genericQuery.isNotEmpty) {
      queryFilters.add({
        "fields": ["topic", "title"],
        "query": genericQuery.toLowerCase()
      });
    }

    if (searchFilters.topic != null &&
        searchFilters.topic!.filterValue.isNotEmpty) {
      queryFilters.add({
        "fields": ["topic"],
        "query": searchFilters.topic!.filterValue.toLowerCase()
      });
    }

    if (searchFilters.channels != null) {
      for (var channel in searchFilters.channels!.filterValue) {
        queryFilters.add({
          "fields": ["channel"],
          "query": channel.toLowerCase()
        });
      }
    }
    return queryFilters;
  }

  Map<String, int> videoLength(
      SearchFilter<(Duration, Duration)>? lengthFilter) {
    if (lengthFilter == null ||
        lengthFilter.filterValue == VideoLengthSlider.UNDEFINED_FILTER) {
      return {};
    }
    Duration minLength, maxLength;
    (minLength, maxLength) = lengthFilter.filterValue;

    bool discardMaxLength =
        (maxLength >= VideoLengthSlider.MAXIMUM_FILTER_LENGTH);
    // min and max length in seconds
    return {
      "duration_min": minLength.inSeconds,
      if (!discardMaxLength) "duration_max": maxLength.inSeconds
    };
  }

  void resetSkip() {
    skip = 0;
  }

  int getCurrentSkip() {
    return skip;
  }

  void execute(String query) {
    http
        .post(requestUri, body: query)
        .then((value) => onDataReceived(value.body), onError: onError);
  }
}
