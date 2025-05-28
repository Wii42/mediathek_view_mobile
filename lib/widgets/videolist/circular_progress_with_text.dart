import 'package:flutter/material.dart';

class CircularProgressWithText extends StatelessWidget {
  final Text text;
  final Color? containerColor;
  final Color indicatorColor;
  final double? height;

  const CircularProgressWithText(this.text, this.containerColor, this.indicatorColor,
      {super.key, this.height});

  @override
  Widget build(BuildContext context) {
    if (height != null) {
      return getWithFixedHeight();
    }
    return getExpandable();
  }

  Widget getWithFixedHeight() {
    return Center(
      child: Container(
        height: height,
        color: containerColor,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              text,
              Container(width: 8.0),
              Container(
                constraints: BoxConstraints.tight(Size.square(13.0)),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                  strokeWidth: 2.0,
                  backgroundColor: Colors.white,
                ),
              ),
            ]),
      ),
    );
  }

  Widget getExpandable() {
    return Container(
      color: containerColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                constraints: BoxConstraints.tight(Size.square(13.0)),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                  strokeWidth: 2.0,
                  backgroundColor: Colors.white,
                ),
              ),
              Container(
                width: 10,
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[text],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
