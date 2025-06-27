import 'package:flutter/material.dart';

class FloatingMiniPlayerState extends ChangeNotifier {
  Widget? _floatingMiniPlayer;

  /// to which size the mini player should default to when it is shown
  Size? _widgetDefaultSize;

  /// offset must be between 0, 1 fro both [dx] and [dy]
  Offset _relativePosition;

  double _scalingFactor;

  FloatingMiniPlayerState({
    Offset initialRelativePosition = const Offset(1, 1),
    double initialScalingFactor = 1,
  }) : _relativePosition = initialRelativePosition,
       _scalingFactor = initialScalingFactor;

  bool get isVisible => _floatingMiniPlayer != null;

  bool get isHidden => !isVisible;

  Widget? get floatingMiniPlayer => _floatingMiniPlayer;

  Offset get relativeOffset => _relativePosition;

  double get scalingFactor => _scalingFactor;

  Size? get widgetDefaultSize => _widgetDefaultSize;

  Size? get scaledWidgetSize {
    if (_widgetDefaultSize == null) return null;
    return Size(
      _widgetDefaultSize!.width * _scalingFactor,
      _widgetDefaultSize!.height * _scalingFactor,
    );
  }

  /// Updates the relative position of the mini player.
  void updateRelativePosition({double? x, double? y}) {
    Offset newPosition = Offset(
      x ?? _relativePosition.dx,
      y ?? _relativePosition.dy,
    );
    if (newPosition != _relativePosition) {
      _relativePosition = newPosition;
      notifyListeners();
    }
  }

  /// Updates the position of the mini player by a relative delta, e.g the change in position
  void updatePositionByRelativeDelta({double dx = 0, double dy = 0}) {
    Offset newPosition = Offset(
      (_relativePosition.dx + dx),
      (_relativePosition.dy + dy),
    );
    if (newPosition != _relativePosition) {
      _relativePosition = newPosition;
      notifyListeners();
    }
  }

  void show(Widget miniPlayer, {required Size defaultSize}) {
    if (_floatingMiniPlayer != miniPlayer ||
        _widgetDefaultSize != defaultSize) {
      _floatingMiniPlayer = miniPlayer;
      _widgetDefaultSize = defaultSize;
      notifyListeners();
    }
  }

  void hide() {
    if (_floatingMiniPlayer != null || _widgetDefaultSize != null) {
      _floatingMiniPlayer = null;
      _widgetDefaultSize = null;
      notifyListeners();
    }
  }

  void updateScalingFactor(double factor) {
    if (_scalingFactor != factor) {
      _scalingFactor = factor;
      print('SCALE: $_scalingFactor');
      notifyListeners();
    }
  }
}
