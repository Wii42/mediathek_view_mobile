import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class PlaybackProgressBar extends StatelessWidget {
  final Logger logger = Logger('PlaybackProgressBar');

  final Duration? playbackProgress;
  final Duration? totalVideoLength;
  final bool backgroundIsTransparent;

  PlaybackProgressBar(this.playbackProgress, this.totalVideoLength,
      this.backgroundIsTransparent,
      {super.key});

  @override
  Widget build(BuildContext context) {
    if (totalVideoLength == null || playbackProgress == null) {
      return Container();
    }

    return Container(
        constraints: BoxConstraints.expand(height: 4.0),
        child: LinearProgressIndicator(
            value: calculateProgress(playbackProgress!, totalVideoLength!),
            color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            backgroundColor:
                backgroundIsTransparent ? Colors.transparent : Colors.white));
  }

  double calculateProgress(Duration playbackProgressInMilliseconds,
      Duration totalVideoLengthInSeconds) {
    return 1 /
        ((totalVideoLengthInSeconds.inSeconds * 1000) /
            playbackProgressInMilliseconds.inMilliseconds);
  }
}
