import 'package:flutter/material.dart';

import '../widgets/filterMenu/search_filter.dart';

class FilterMenuState extends ChangeNotifier {
  bool _isFilterMenuOpen;
  final SearchFilters searchFilters = SearchFilters();

  FilterMenuState([this._isFilterMenuOpen = false]);

  bool get isFilterMenuOpen => _isFilterMenuOpen;

  bool toggleFilterMenu() {
    _isFilterMenuOpen = !_isFilterMenuOpen;
    notifyListeners();
    return _isFilterMenuOpen;
  }
}

class SearchFilters {
  SearchFilter<String>? topic;
  SearchFilter<String>? title;
  SearchFilter<Set<String>>? channels;
  SearchFilter<(double, double)>? videoLength;

  /// Returns a list of all filters that are not null.
  List<SearchFilter> toList() {
    return [
      if (topic != null) topic!,
      if (title != null) title!,
      if (channels != null) channels!,
      if (videoLength != null) videoLength!,
    ];
  }

  /// Returns the first filter where [filterId] matches.
  ///
  /// Analog tho [Map[filterId]].
  SearchFilter<T>? getById<T extends Object>(String filterId) {
    for (var filter in toList()) {
      if (filter.filterId == filterId) {
        assert(filter.filterValue is T,
            "Filter value type mismatch: expected $T but got ${filter.filterValue.runtimeType}");
        return filter as SearchFilter<T>;
      }
    }
    return null;
  }

  /// Sets the first filter where [filterId] matches to [null].
  /// Returns the removed filter if it was found, otherwise returns null.
  ///
  /// Analog to [Map.remove].
  SearchFilter<T>? removeById<T extends Object>(String filterId) {
    if (topic?.filterId == filterId) {
      SearchFilter<T> removed = topic as SearchFilter<T>;
      topic = null;
      return removed;
    }
    if (title?.filterId == filterId) {
      SearchFilter<T> removed = title as SearchFilter<T>;
      title = null;
      return removed;
    }
    if (channels?.filterId == filterId) {
      SearchFilter<T> removed = channels as SearchFilter<T>;
      channels = null;
      return removed;
    }
    if (videoLength?.filterId == filterId) {
      SearchFilter<T> removed = videoLength as SearchFilter<T>;
      videoLength = null;
      return removed;
    }
    return null;
  }

  SearchFilter<T> putIfAbsent<T extends Object>(
      String filterId, SearchFilter<T> Function() ifAbsent) {
    SearchFilter<T>? existingFilter = getById<T>(filterId);
    if (existingFilter != null) {
      return existingFilter;
    } else {
      SearchFilter<T> newFilter = ifAbsent();
      switch (newFilter.filterId) {
        case "Thema":
          topic = newFilter as SearchFilter<String>;
          break;
        case "Titel":
          title = newFilter as SearchFilter<String>;
          break;
        case "Sender":
          channels = newFilter as SearchFilter<Set<String>>;
          break;
        case "Länge":
          videoLength = newFilter as SearchFilter<(double, double)>;
          break;
      }
      return newFilter;
    }
  }
}
