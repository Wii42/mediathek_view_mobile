import 'package:flutter/material.dart';

class SnackbarActions {
  static void showError(ScaffoldMessengerState scaffoldMessenger, String msg) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(msg)],
        ),
      ),
    );
  }

  static void showSuccess(ScaffoldMessengerState scaffoldMessenger, String msg) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(msg)],
        ),
      ),
    );
  }

  static void showInfo(ScaffoldMessengerState scaffoldMessenger, String msg, {Duration? duration}) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        duration: duration ?? Duration(seconds: 4),
        backgroundColor: Colors.grey,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(msg)],
        ),
      ),
    );
  }

  static void showErrorWithTryAgain(ScaffoldMessengerState scaffoldMessenger, String errorMsg,
      String tryAgainMsg, dynamic onTryAgainPressed, String videoId) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(errorMsg),
        action: SnackBarAction(
          label: tryAgainMsg,
          onPressed: () {
            scaffoldMessenger.hideCurrentSnackBar();
            onTryAgainPressed(videoId);
          },
        ),
      ),
    );
  }
}
