import 'package:flutter/material.dart';

import '../widgets/filterMenu/search_filter.dart';

class FilterMenuState extends ChangeNotifier{
  bool _isFilterMenuOpen;
  Map<String, SearchFilter> searchFilters = {};

  FilterMenuState([this._isFilterMenuOpen = false]);

  bool get isFilterMenuOpen => _isFilterMenuOpen;

  bool toggleFilterMenu() {
    _isFilterMenuOpen = !_isFilterMenuOpen;
    notifyListeners();
    return _isFilterMenuOpen;
  }
}

