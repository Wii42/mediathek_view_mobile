import 'package:flutter/material.dart';
import 'package:flutter_ws/platform_channels/download_manager_flutter.dart';
import 'package:logging/logging.dart';

import 'download_controller.dart';
import 'download_value.dart';

typedef TriggerParentStateReload = void Function();

class DownloadProgressBar extends StatefulWidget {
  final Logger logger = Logger('DownloadProgressBar');
  final int downloadManagerIdentifier = 1;
  final String? videoId;
  final String? videoTitle;
  final bool isOnDetailScreen;
  final DownloadManager downloadManager;

  // this is an optional function that is called by the progress bar
  // indicating that a download has complete. This is a workaround so that the parent
  // widget does not have to subscribe video downloads separately
  final TriggerParentStateReload? triggerParentStateReload;

  DownloadProgressBar(
      {required this.videoId,
      required this.videoTitle,
      required this.downloadManager,
      this.isOnDetailScreen = false,
      this.triggerParentStateReload,
      super.key});

  @override
  State<DownloadProgressBar> createState() => _DownloadProgressBarState();
}

class _DownloadProgressBarState extends State<DownloadProgressBar> {
  DownloadValue? _latestDownloadValue;
  DownloadController? downloadController;

  @override
  Future<void> dispose() async {
    super.dispose();
    if (downloadController != null) {
      downloadController!.removeListener(updateDownloadState);
      downloadController!.dispose();
    }
  }

  @override
  void initState() {
    subscribeToDownloadUpdates(
        widget.videoId, widget.videoTitle, widget.downloadManager);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_latestDownloadValue == null) {
      return Container();
    }

    if (_latestDownloadValue!.isDownloading ||
        _latestDownloadValue!.isPaused ||
        _latestDownloadValue!.isEnqueued) {
      return getProgressIndicator(_latestDownloadValue!.progress);
    }

    return Container();
  }

  Widget getProgressIndicator(double progress) {
    return Container(
        constraints: BoxConstraints.expand(height: 7.0),
        child: progress == -1
            ? LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color?>(Colors.green[700]),
                backgroundColor: Colors.green[100])
            : LinearProgressIndicator(
                value: (progress / 100),
                valueColor: AlwaysStoppedAnimation<Color?>(Colors.green[700]),
                backgroundColor: Colors.green[100]));
  }

  void updateIfCurrentlyDownloading() {
    widget.downloadManager
        .isCurrentlyDownloading(widget.videoId!)
        .then((status) {
      if (status != null) {
        if (mounted) {
          setState(() {
            _latestDownloadValue = DownloadValue(
                videoId: widget.videoId, progress: -1, status: status.status);
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          _latestDownloadValue = null;
        });
      }
    });
  }

  void subscribeToDownloadUpdates(
      String? videoId, String? videoTitle, DownloadManager downloadManager) {
    downloadController =
        DownloadController(videoId, videoTitle, downloadManager);
    _latestDownloadValue = downloadController!.value;
    downloadController!.addListener(updateDownloadState);
    downloadController!.initialize();
    updateIfCurrentlyDownloading();
  }

  void updateDownloadState() {
    _latestDownloadValue = downloadController!.value;
    widget.logger
        .info("DownloadProgressBar status ${_latestDownloadValue!.status}");

    if (widget.triggerParentStateReload != null &&
        _latestDownloadValue!.isComplete) {
      widget.logger.info("trigger parent state reload");
      widget.triggerParentStateReload!();
      return;
    }

    if (mounted) {
      setState(() {});
    }
  }
}
