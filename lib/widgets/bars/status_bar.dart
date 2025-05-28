import 'package:flutter/material.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/widgets/videolist/circular_progress_with_text.dart';
import 'package:logging/logging.dart';

class StatusBar extends StatelessWidget {
  final Logger logger = new Logger('VideoWidget');
  final bool videoListIsEmpty;
  final bool? apiError;
  final bool firstAppStartup;
  final int? lastAmountOfVideosRetrieved;

  StatusBar(
      {Key? key,
      required this.apiError,
      required this.firstAppStartup,
      required this.videoListIsEmpty,
      required this.lastAmountOfVideosRetrieved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.fine("Rendering Status bar. videoListIsEmpty: " +
        videoListIsEmpty.toString() +
        " api error: " +
        apiError.toString() +
        " firstAppStartup: " +
        firstAppStartup.toString() +
        " lastAmountOfVideosRetrieved: " +
        lastAmountOfVideosRetrieved.toString());

    if (apiError!) {
      return new CircularProgressWithText(
        new Text("Keine Verbindung", style: connectionLostTextStyle),
        new Color(0xffffbf00),
        new Color(0xffffbf00),
        height: 30.0,
      );
    }

    return new Container();
  }
}
