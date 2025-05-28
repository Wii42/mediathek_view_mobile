import 'package:flutter/material.dart';
import 'package:flutter_ws/widgets/filterMenu/search_filter.dart';

class VideoLengthSlider extends StatefulWidget {
  final void Function(SearchFilter) onFilterUpdated;
  final SearchFilter searchFilter;
  late final double initialStart;
  late final double initialEnd;

  static const double MAXIMUM_FILTER_LENGTH = 60;

  VideoLengthSlider(this.onFilterUpdated, this.searchFilter, {super.key}) {
    if (searchFilter.filterValue.isEmpty) {
      initialStart = 0.0;
      initialEnd = MAXIMUM_FILTER_LENGTH;
    } else {
      List<String> split = searchFilter.filterValue.split("-");
      initialStart = double.parse(split.elementAt(0));
      initialEnd = double.parse(split.elementAt(1));
    }
  }

  @override
  State<VideoLengthSlider> createState() =>
      _RangeSliderState(RangeValues(initialStart, initialEnd));
}

class _RangeSliderState extends State<VideoLengthSlider> {
  late RangeValues _values;

  _RangeSliderState(RangeValues rangeValues) {
    _values = rangeValues;
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
          _values.end < VideoLengthSlider.MAXIMUM_FILTER_LENGTH
              ? "${_values.end.round()} min"
              : "max"),
      max: VideoLengthSlider.MAXIMUM_FILTER_LENGTH,
      min: 0.0,
      divisions: 10,
      onChangeEnd: (values) {
        widget.searchFilter.filterValue = "${_values.start.round()}-${_values.end.round()}";
        widget.onFilterUpdated(widget.searchFilter);
      },
    );
  }
}
