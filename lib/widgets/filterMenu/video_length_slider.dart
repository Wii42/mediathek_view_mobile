import 'package:flutter/material.dart';
import 'package:flutter_ws/widgets/filterMenu/search_filter.dart';

class VideoLengthSlider extends StatefulWidget {
  final void Function(SearchFilter) onFilterUpdated;
  final SearchFilter<(Duration, Duration)> initialSearchFilter;
  late final Duration initialStart;
  late final Duration initialEnd;

  static const Duration MAXIMUM_FILTER_LENGTH = Duration(minutes: 60);
  static const Duration _UNDEFINED_FILTER_LENGTH = Duration(seconds: -1);
  static const (Duration, Duration) UNDEFINED_FILTER =
      (_UNDEFINED_FILTER_LENGTH, _UNDEFINED_FILTER_LENGTH);

  VideoLengthSlider(this.onFilterUpdated, this.initialSearchFilter,
      {super.key}) {
    if (initialSearchFilter.filterValue == UNDEFINED_FILTER) {
      initialStart = Duration.zero;
      initialEnd = MAXIMUM_FILTER_LENGTH;
    } else {
      Duration start, end;
      (start, end) = initialSearchFilter.filterValue;
      initialStart = start;
      initialEnd = end;
    }
  }

  @override
  State<VideoLengthSlider> createState() => _RangeSliderState();
}

class _RangeSliderState extends State<VideoLengthSlider> {
  late RangeValues _values;
  late SearchFilter<(Duration, Duration)> searchFilter;

  _RangeSliderState();

  @override
  void initState() {
    searchFilter = widget.initialSearchFilter;
    _values = RangeValues(
      _durationToMinutes(widget.initialStart),
      _durationToMinutes(widget.initialEnd),
    );
    super.initState();
  }

  // TODO: reset the slider to its initial state when the filter is cleared
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
        searchFilter = searchFilter.copyWith((
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
}
