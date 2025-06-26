import 'package:flutter_downloader/flutter_downloader.dart';

import '../drift_database/app_database.dart';

class DownloadInfo {
  final VideoEntity videoEntity;
  final DownloadTaskStatus downloadStatus;
  final int? downloadProgress;

  DownloadInfo(
      {required this.videoEntity,
      this.downloadStatus = DownloadTaskStatus.undefined,
      this.downloadProgress});

  DownloadInfo copyWith({
    VideoEntity? videoEntity,
    DownloadTaskStatus? downloadStatus,
    int? downloadProgress,
  }) {
    return DownloadInfo(
      videoEntity: videoEntity ?? this.videoEntity,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }

  bool get isDownloading => downloadStatus == DownloadTaskStatus.running;

  bool get isPaused => downloadStatus == DownloadTaskStatus.paused;

  bool get isEnqueued => downloadStatus == DownloadTaskStatus.enqueued;

  bool get isComplete => downloadStatus == DownloadTaskStatus.complete;

  bool get isFailed => downloadStatus == DownloadTaskStatus.failed;

  bool isCurrentlyDownloading() {
    return isDownloading || isPaused || isEnqueued;
  }

  bool isDownloadedAlready() {
    return downloadStatus == DownloadTaskStatus.complete ||
        (videoEntity.filePath != null && videoEntity.filePath!.isNotEmpty);
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DownloadInfo &&
        other.videoEntity == videoEntity &&
        other.downloadStatus == downloadStatus &&
        other.downloadProgress == downloadProgress;
  }

  @override
  int get hashCode =>
      Object.hash(videoEntity, downloadStatus, downloadProgress);

  int compareTo(DownloadInfo other) {
    DateTime now = DateTime.now();
    DateTime thisTimestamp = videoEntity.timestampVideoSaved ?? now;
    DateTime otherTimestamp = other.videoEntity.timestampVideoSaved ?? now;
    int result = thisTimestamp.compareTo(otherTimestamp);
    if (result != 0) {
      return result;
    }
    result = (downloadProgress ?? -1).compareTo(other.downloadProgress ?? -1);
    if (result != 0) {
      return result;
    }
    return videoEntity.id.compareTo(other.videoEntity.id);
  }
}
