import 'package:flutter/material.dart';
import 'package:flutter_ws/widgets/filterMenu/search_filter.dart';

class VideoLengthSlider extends StatefulWidget {
  final void Function(SearchFilter) onFilterUpdated;
  final SearchFilter<(double, double)> initialSearchFilter;
  late final double initialStart;
  late final double initialEnd;

  static const double MAXIMUM_FILTER_LENGTH = 60;

  VideoLengthSlider(this.onFilterUpdated, this.initialSearchFilter,
      {super.key}) {
    if (initialSearchFilter.filterValue == (-1.0, -1.0)) {
      initialStart = 0.0;
      initialEnd = MAXIMUM_FILTER_LENGTH;
    } else {
      double start, end;
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
  late SearchFilter searchFilter;

  _RangeSliderState();

  @override
  void initState() {
    searchFilter = widget.initialSearchFilter;
    _values = RangeValues(widget.initialStart, widget.initialEnd);
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
          _values.end < VideoLengthSlider.MAXIMUM_FILTER_LENGTH
              ? "${_values.end.round()} min"
              : "max"),
      max: VideoLengthSlider.MAXIMUM_FILTER_LENGTH,
      min: 0.0,
      divisions: 10,
      onChangeEnd: (values) {
        searchFilter = searchFilter.copyWith((_values.start, _values.end));
        widget.onFilterUpdated(searchFilter);
      },
    );
  }
}
