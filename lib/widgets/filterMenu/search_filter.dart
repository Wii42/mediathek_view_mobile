import 'package:flutter/material.dart';

class SearchFilter<T extends Object> extends StatelessWidget {
  //Der Wert nachdem gefiltert wird
  final T filterValue;
  final void Function(SearchFilterType) handleTabCallback;
  final String displayText;

  /// Used to identify the filter
  final SearchFilterType filterType;

  const SearchFilter(
      {super.key,
      required this.filterValue,
      required this.handleTabCallback,
      required this.filterType,
      required this.displayText});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, top: 2.0),
        child: GestureDetector(
          onTap: () {
            handleTabCallback(filterType);
          },
          child: Container(
            height: 25.0,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.only(right: 5.0, left: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Icon(Icons.clear, size: 22.0, color: Colors.red),
                ),
                Text(displayText.isEmpty ? filterType.name : displayText,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.start,
                    maxLines: 1)
              ],
            ),
          ),
        ));
  }

  SearchFilter<T> copyWith(T newFilterValue) {
    return SearchFilter<T>(
      filterValue: newFilterValue,
      handleTabCallback: handleTabCallback,
      displayText: displayText,
      filterType: filterType,
    );
  }
}

enum SearchFilterType {
  topic,
  title,
  channels,
  videoLength,
  includeFutureVideos;
}
