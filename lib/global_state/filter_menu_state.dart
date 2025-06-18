import 'package:flutter/material.dart';

import '../widgets/filterMenu/search_filter.dart';

class FilterMenuState extends ChangeNotifier {
  bool _isFilterMenuOpen;
  final SearchFilters searchFilters = SearchFilters();

  FilterMenuState([this._isFilterMenuOpen = false]) {
    searchFilters.addListener(() => notifyListeners());
  }

  bool get isFilterMenuOpen => _isFilterMenuOpen;

  bool toggleFilterMenu() {
    _isFilterMenuOpen = !_isFilterMenuOpen;
    notifyListeners();
    return _isFilterMenuOpen;
  }
}

class SearchFilters extends ChangeNotifier {
  SearchFilter<String>? topic;
  SearchFilter<String>? title;
  SearchFilter<Set<String>>? channels;
  SearchFilter<(Duration, Duration)>? videoLength;
  SearchFilter<bool>? includeFutureVideos;

  /// Returns a list of all filters that are not null.
  List<SearchFilter> toList() {
    return [
      if (topic != null) topic!,
      if (title != null) title!,
      if (channels != null) channels!,
      if (videoLength != null) videoLength!,
    ];
  }

  /// Returns the first filter where [filterType] matches.
  ///
  /// Analog tho [Map[filterId]].
  SearchFilter<T>? getByType<T extends Object>(SearchFilterType filterType) {
    for (var filter in toList()) {
      if (filter.filterType == filterType) {
        assert(filter.filterValue is T,
            "Filter value type mismatch: expected $T but got ${filter.filterValue.runtimeType}");
        return filter as SearchFilter<T>;
      }
    }
    return null;
  }

  /// Sets the first filter where [filterType] matches to [null].
  /// Returns the removed filter if it was found, otherwise returns null.
  ///
  /// Analog to [Map.remove].
  SearchFilter<T>? removeByType<T extends Object>(SearchFilterType filterType) {
    switch (filterType) {
      case SearchFilterType.topic:
        if (topic != null) {
          SearchFilter<T> removed = topic as SearchFilter<T>;
          topic = null;
          notifyListeners();
          return removed;
        }
        break;
      case SearchFilterType.title:
        if (title != null) {
          SearchFilter<T> removed = title as SearchFilter<T>;
          title = null;
          notifyListeners();
          return removed;
        }
        break;
      case SearchFilterType.channels:
        if (channels != null) {
          SearchFilter<T> removed = channels as SearchFilter<T>;
          channels = null;
          notifyListeners();
          return removed;
        }
        break;
      case SearchFilterType.videoLength:
        if (videoLength != null) {
          SearchFilter<T> removed = videoLength as SearchFilter<T>;
          videoLength = null;
          notifyListeners();
          return removed;
        }
        break;
      case SearchFilterType.includeFutureVideos:
        if (includeFutureVideos != null) {
          SearchFilter<T> removed = includeFutureVideos as SearchFilter<T>;
          includeFutureVideos = null;
          notifyListeners();
          return removed;
        }
        break;
    }

    return null;
  }

  SearchFilter<T> putIfAbsent<T extends Object>(
      SearchFilterType filterType, SearchFilter<T> Function() ifAbsent) {
    SearchFilter<T>? existingFilter = getByType<T>(filterType);
    if (existingFilter != null) {
      return existingFilter;
    }
    SearchFilter<T> newFilter = ifAbsent();
    switch (newFilter.filterType) {
      case SearchFilterType.topic:
        topic = newFilter as SearchFilter<String>;
        break;
      case SearchFilterType.title:
        title = newFilter as SearchFilter<String>;
        break;
      case SearchFilterType.channels:
        channels = newFilter as SearchFilter<Set<String>>;
        break;
      case SearchFilterType.videoLength:
        videoLength = newFilter as SearchFilter<(Duration, Duration)>;
        break;
      case SearchFilterType.includeFutureVideos:
        includeFutureVideos = newFilter as SearchFilter<bool>;
        break;
    }
    notifyListeners();
    return newFilter;
  }
}
