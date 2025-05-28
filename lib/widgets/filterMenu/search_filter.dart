import 'package:flutter/material.dart';

class SearchFilter extends StatelessWidget {
  //E.g Thema/Titel
  final String filterId;

  //Der Wert nachdem gefiltert wird
  final String filterValue;
  final void Function(String) handleTabCallback;
  final String? displayText;

  const SearchFilter(
      {super.key,
      required this.filterId,
      required this.filterValue,
      required this.handleTabCallback,
      this.displayText});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, top: 2.0),
        child: GestureDetector(
          onTap: () {
            handleTabCallback(filterId);
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
                Text(
                    displayText == null || displayText!.isEmpty
                        ? filterId
                        : displayText!,
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

  SearchFilter copyWith(String newFilterValue){
    return SearchFilter(
      filterId: filterId,
      filterValue: newFilterValue,
      handleTabCallback: handleTabCallback,
      displayText: displayText,
    );
  }
}
