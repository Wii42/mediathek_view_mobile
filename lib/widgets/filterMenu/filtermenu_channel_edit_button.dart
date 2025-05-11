import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class FilterMenuChannelEditButton extends StatelessWidget {
  //E.g Thema/Titel
  final Icon icon;
  var handleTabCallback;
  final String? displayText;

  FilterMenuChannelEditButton(
      {Key? key,
      required this.icon,
      required this.handleTabCallback,
      this.displayText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 35.0,
        child: new ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0))),elevation: MaterialStateProperty.all<double>(6.0)),
          onPressed: () {
            handleTabCallback(context);
          },
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(right: 5.0),
                child: new Icon(Icons.edit, size: 25.0, color: Colors.white),
              ),
              new Text(displayText!,
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.start,
                  maxLines: 1)
            ],
          ),
        ));
  }
}
