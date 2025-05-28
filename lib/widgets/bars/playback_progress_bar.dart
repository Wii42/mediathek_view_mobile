import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class PlaybackProgressBar extends StatelessWidget {
  final Logger logger = Logger('PlaybackProgressBar');

  final int? playbackProgressInMilliseconds;
  final int? totalVideoLengthInSeconds;
  final bool backgroundIsTransparent;

  PlaybackProgressBar(this.playbackProgressInMilliseconds,
      this.totalVideoLengthInSeconds, this.backgroundIsTransparent, {super.key});

  @override
  Widget build(BuildContext context) {
    if (totalVideoLengthInSeconds == null) {
      return Container();
    }

    return Container(
        constraints: BoxConstraints.expand(height: 10.0),
        child: LinearProgressIndicator(
            value: calculateProgress(
                playbackProgressInMilliseconds!, totalVideoLengthInSeconds!),
            valueColor: AlwaysStoppedAnimation<Color?>(Colors.red[900]),
            backgroundColor: backgroundIsTransparent
                ? Colors.transparent
                : Colors.red[100]));
  }

  double calculateProgress(
      int playbackProgressInMilliseconds, int totalVideoLengthInSeconds) {
    return 1 /
        ((totalVideoLengthInSeconds * 1000) / playbackProgressInMilliseconds);
  }
}
