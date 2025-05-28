import 'package:flutter/material.dart';

class FilterMenuChannelEditButton extends StatelessWidget {
  //E.g Thema/Titel
  final Icon icon;
  final void Function(BuildContext) handleTabCallback;
  final String? displayText;

  const FilterMenuChannelEditButton(
      {super.key,
      required this.icon,
      required this.handleTabCallback,
      this.displayText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 35.0,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))),elevation: WidgetStateProperty.all<double>(6.0)),
          onPressed: () {
            handleTabCallback(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Icon(Icons.edit, size: 25.0, color: Colors.white),
              ),
              Text(displayText!,
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.start,
                  maxLines: 1)
            ],
          ),
        ));
  }
}
