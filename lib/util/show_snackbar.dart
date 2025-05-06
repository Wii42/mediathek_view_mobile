import 'package:flutter/material.dart';

class SnackbarActions {
  static void showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        backgroundColor: Colors.red,
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new Text(msg)],
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        backgroundColor: Colors.green,
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new Text(msg)],
        ),
      ),
    );
  }

  static void showInfo(BuildContext context, String msg, {Duration duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        duration: duration != null ? duration : null,
        backgroundColor: Colors.grey,
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new Text(msg)],
        ),
      ),
    );
  }

  static void showErrorWithTryAgain(BuildContext context, String errorMsg,
      String tryAgainMsg, dynamic onTryAgainPressed, String videoId) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        backgroundColor: Colors.red,
        content: new Text(errorMsg),
        action: new SnackBarAction(
          label: tryAgainMsg,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            onTryAgainPressed(videoId);
          },
        ),
      ),
    );
  }
}
