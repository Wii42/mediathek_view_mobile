import 'package:flutter/material.dart';
import 'package:flutter_ws/global_state/video_download_state.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class DownloadProgressBar extends StatelessWidget {
  final Logger logger = Logger('DownloadProgressBar');
  final int downloadManagerIdentifier = 1;
  final String? videoId;
  final String? videoTitle;
  final bool isOnDetailScreen;

  DownloadProgressBar(
      {required this.videoId,
      required this.videoTitle,
      this.isOnDetailScreen = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<VideoDownloadState?, DownloadInfo?>(
      selector: (_, downloadState) => downloadState?.getEntityForId(videoId!),
      builder: (context, downloadInfo, _) {
        if (downloadInfo == null) {
          return Container();
        }

        if (downloadInfo.isCurrentlyDownloading()) {
          return getProgressIndicator(downloadInfo.downloadProgress);
        }

        return Container();
      },
    );
  }

  Widget getProgressIndicator(int? progress) {
    return Container(
        constraints: BoxConstraints.expand(height: 7.0),
        child: progress == null
            ? LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color?>(Colors.green[700]),
                backgroundColor: Colors.green[100])
            : LinearProgressIndicator(
                value: (progress / 100),
                valueColor: AlwaysStoppedAnimation<Color?>(Colors.green[700]),
                backgroundColor: Colors.green[100]));
  }
}
