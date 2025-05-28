import 'package:flutter/material.dart';

class FilterMenuState extends ChangeNotifier{
  bool _isFilterMenuOpen;
  FilterMenuState([this._isFilterMenuOpen = false]);

  bool get isFilterMenuOpen => _isFilterMenuOpen;

  bool toggleFilterMenu() {
    _isFilterMenuOpen = !_isFilterMenuOpen;
    notifyListeners();
    return _isFilterMenuOpen;
  }
}

