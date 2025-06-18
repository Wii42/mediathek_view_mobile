import 'package:flutter/material.dart';
import 'package:flutter_ws/widgets/filterMenu/search_filter.dart';

class VideoLengthSlider extends StatefulWidget {
  final void Function(SearchFilter) onFilterUpdated;
  final SearchFilter<(Duration, Duration)> initialSearchFilter;

  static const Duration MAXIMUM_FILTER_LENGTH = Duration(minutes: 60);
  static const Duration _UNDEFINED_FILTER_LENGTH = Duration(seconds: -1);
  static const (Duration, Duration) UNDEFINED_FILTER =
      (_UNDEFINED_FILTER_LENGTH, _UNDEFINED_FILTER_LENGTH);

  const VideoLengthSlider(this.onFilterUpdated, this.initialSearchFilter,
      {super.key});

  @override
  State<VideoLengthSlider> createState() => _RangeSliderState();
}

class _RangeSliderState extends State<VideoLengthSlider> {
  late RangeValues _values;
  late SearchFilter<(Duration, Duration)> searchFilter;

  _RangeSliderState();

  @override
  void initState() {
    final originalCallback = widget.initialSearchFilter.handleTabCallback;
    searchFilter =
        widget.initialSearchFilter.copyWith(handleTabCallback: (filter) {
      originalCallback(filter);
      if (mounted) {
        setState(() {
          _values = RangeValues(defaultStart, defaultEnd);
        });
      }
    });
    _setInitialRangeValues();
    super.initState();
  }

  void _setInitialRangeValues() {
    double initialStart, initialEnd;
    if (searchFilter.filterValue == VideoLengthSlider.UNDEFINED_FILTER) {
      initialStart = defaultStart;
      initialEnd = defaultEnd;
    } else {
      Duration start, end;
      (start, end) = searchFilter.filterValue;
      initialStart = _durationToMinutes(start);
      initialEnd = _durationToMinutes(end);
    }

    _values = RangeValues(initialStart, initialEnd);
  }

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: _values,
      onChanged: (RangeValues values) {
        setState(() {
          _values = values;
        });
      },
      activeColor: Colors.black,
      inactiveColor: Colors.grey,
      labels: RangeLabels(
          "${_values.start.round()} min",
          _values.end <
                  _durationToMinutes(VideoLengthSlider.MAXIMUM_FILTER_LENGTH)
              ? "${_values.end.round()} min"
              : "max"),
      max: _durationToMinutes(VideoLengthSlider.MAXIMUM_FILTER_LENGTH),
      min: 0.0,
      divisions: 10,
      onChangeEnd: (values) {
        searchFilter = searchFilter.copyWith(filterValue: (
          _minutesToDuration(_values.start),
          _minutesToDuration(_values.end)
        ));
        widget.onFilterUpdated(searchFilter);
      },
    );
  }

  double _durationToMinutes(Duration duration) =>
      duration.inMilliseconds / Duration.millisecondsPerMinute;

  Duration _minutesToDuration(double minutes) => Duration(
      milliseconds: (minutes * Duration.millisecondsPerMinute).round());

  double get defaultStart => 0;
  double get defaultEnd =>
      _durationToMinutes(VideoLengthSlider.MAXIMUM_FILTER_LENGTH);
}
