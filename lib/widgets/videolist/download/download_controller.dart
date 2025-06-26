import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_ws/platform_channels/download_manager_flutter.dart';
import 'package:logging/logging.dart';

import 'download_value.dart';

class DownloadController extends ValueNotifier<DownloadValue> {
  final Logger logger = Logger('DownloadController');
  int? downloadManagerIdentifier;

  final String? videoTitle;
  DownloadManager downloadManager;

  DownloadController(String? videoId, this.videoTitle, this.downloadManager)
      : super(DownloadValue(videoId: videoId));

  void initialize() {
    logger.fine("DownloadController listening for video: ${videoTitle!}");
    subscribeToProgressChannel(value.videoId);
  }

  int getIdentifier() {
    Random random = Random();
    return random.nextInt(1000);
  }

  @override
  void dispose() async {
    logger.fine("Disposing DownloadController");
    unsubscribe();
    super.dispose();
  }

  void unsubscribe() async {
    logger.fine(
        "DownloadController unsubscribe from updates for video ${videoTitle!}");
    downloadManager.unsubscribe(value.videoId, downloadManagerIdentifier);
  }

  void subscribeToProgressChannel(String? videoId) {
    downloadManagerIdentifier = getIdentifier();
    downloadManager.subscribe(
        videoId,
        onDownloadStateChanged,
        onDownloaderComplete,
        onDownloaderFailed,
        onSubscriptionCanceled,
        downloadManagerIdentifier!);
  }

  void onDownloaderFailed(String? videoId) {
    logger.info("Download video: ${videoId!} received 'failed' signal");
    value = value.copyWith(status: DownloadTaskStatus.failed);
  }

  void onDownloaderComplete(String? videoId) {
    logger.info("Download video: ${videoId!} received 'complete' signal");
    value = value.copyWith(status: DownloadTaskStatus.complete);
  }

  void onSubscriptionCanceled(String? videoId) {
    logger.info("Download video: ${videoId!} received 'canceled' signal");
    value = value.copyWith(status: DownloadTaskStatus.canceled);
  }

  void onDownloadStateChanged(String? videoId,
      DownloadTaskStatus? updatedStatus, double updatedProgress) {
    logger.info(
        "Download: ${videoId!} status: $updatedStatus progress: $updatedProgress");

    value = value.copyWith(
        status: DownloadTaskStatus.running, progress: updatedProgress);
  }
}
