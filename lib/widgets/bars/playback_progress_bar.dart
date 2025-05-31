import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class PlaybackProgressBar extends StatelessWidget {
  final Logger logger = Logger('PlaybackProgressBar');

  final Duration? playbackProgressInMilliseconds;
  final Duration? totalVideoLengthInSeconds;
  final bool backgroundIsTransparent;

  PlaybackProgressBar(this.playbackProgressInMilliseconds,
      this.totalVideoLengthInSeconds, this.backgroundIsTransparent,
      {super.key});

  @override
  Widget build(BuildContext context) {
    if (totalVideoLengthInSeconds == null ||
        playbackProgressInMilliseconds == null) {
      return Container();
    }

    return Container(
        constraints: BoxConstraints.expand(height: 5.0),
        child: LinearProgressIndicator(
            value: calculateProgress(
                playbackProgressInMilliseconds!, totalVideoLengthInSeconds!),
            valueColor: AlwaysStoppedAnimation<Color?>(Colors.red[900]),
            backgroundColor: backgroundIsTransparent
                ? Colors.transparent
                : Colors.red[100]));
  }

  double calculateProgress(Duration playbackProgressInMilliseconds,
      Duration totalVideoLengthInSeconds) {
    return 1 /
        ((totalVideoLengthInSeconds.inSeconds * 1000) /
            playbackProgressInMilliseconds.inMilliseconds);
  }
}
