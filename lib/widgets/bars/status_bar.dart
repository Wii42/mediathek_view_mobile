import 'package:flutter/material.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/widgets/videolist/circular_progress_with_text.dart';
import 'package:logging/logging.dart';

class StatusBar extends StatelessWidget {
  final Logger logger = Logger('VideoWidget');
  final bool videoListIsEmpty;
  final bool? apiError;
  final bool firstAppStartup;
  final int? lastAmountOfVideosRetrieved;

  StatusBar(
      {super.key,
      required this.apiError,
      required this.firstAppStartup,
      required this.videoListIsEmpty,
      required this.lastAmountOfVideosRetrieved});

  @override
  Widget build(BuildContext context) {
    logger.fine("Rendering Status bar. videoListIsEmpty: $videoListIsEmpty api error: $apiError firstAppStartup: $firstAppStartup lastAmountOfVideosRetrieved: $lastAmountOfVideosRetrieved");

    if (apiError!) {
      return CircularProgressWithText(
        Text("Keine Verbindung", style: connectionLostTextStyle),
        Color(0xffffbf00),
        Color(0xffffbf00),
        height: 30.0,
      );
    }

    return Container();
  }
}
