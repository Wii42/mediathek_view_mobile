import 'dart:io';

import 'package:collection/collection.dart';
import 'package:countly_flutter/countly_flutter.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_ws/util/device_information.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../drift_database/app_database.dart';
import '../model/video.dart';
import '../platform_channels/flutter_downloader_isolate_connection.dart';
import '../util/value_sorted_map.dart';

class VideoDownloadState extends ChangeNotifier {
  final Logger logger = Logger('VideoDownloadState');
  static const _SQL_GET_SINGLE_TASK = "SELECT * FROM task WHERE task_id =";

  final AppDatabase appDatabase;
  final Directory localDirectory;
  final AppPlatform appPlatform;

  late final FlutterDownloaderIsolateConnection backgroundIsolateConnection;

  // taskId -> videoId
  final Map<String, String> _taskIdToVideoId = {};

  // videoId -> DownloadInfo
  final ValueSortedMap<String, DownloadInfo> _downloads =
      ValueSortedMap<String, DownloadInfo>(
    compare: (a, b) => b.compareTo(a),
  );

  // This is used to check if the initial load from the database has been done
  bool _initialLoadDone = false;

  //special case Android: remember Video to be able to resume download after grant of file system permission
  late Video rememberedFailedVideoDownload;

  VideoDownloadState(this.appDatabase, this.localDirectory, this.appPlatform) {
    backgroundIsolateConnection =
        FlutterDownloaderIsolateConnection(_handleDownloadProgress);
  }

  Future<void> initialize() async {
    await FlutterDownloader.initialize(debug: true);
    backgroundIsolateConnection.startListening();
    await initialLoadFromDbs();

    //check for failed DownloadTasks and retry them
    await retryFailedDownloads();
  }

  void _handleDownloadProgress(
      String? taskId, DownloadTaskStatus? status, int? progress) async {
    logger.fine(
        "Received download update with status $status and progress $progress");
    String? videoId = _taskIdToVideoId[taskId];
    DownloadInfo? entity = _downloads.getByKey(videoId);
    if (entity != null) {
      logger.fine("Cache hit for TaskID -> DownloadInfo");
      DownloadInfo newDownloadInfo = entity.copyWith(
        downloadStatus: status,
        downloadProgress: progress,
      );
      _downloads.put(videoId!, newDownloadInfo);
      switch (status) {
        case null:
        case DownloadTaskStatus.undefined:
        case DownloadTaskStatus.enqueued:
        case DownloadTaskStatus.paused:
        case DownloadTaskStatus.running:
          notifyListeners();
          break;
        case DownloadTaskStatus.complete:
          _handleCompletedDownload(newDownloadInfo);
        case DownloadTaskStatus.failed:
          _handleFailedDownload(newDownloadInfo.videoEntity);
        case DownloadTaskStatus.canceled:
          _handleCanceledDownload(newDownloadInfo.videoEntity);
      }
    } else {
      logger.severe(
          "Received update for task that we do not know of - Ignoring (taskId: $taskId, videoId: $videoId)");
      return;
    }
  }

  Future<void> initialLoadFromDbs() async {
    logger.fine("Loading downloads from database");
    final List<VideoEntity> videoEntities =
        await appDatabase.getAllVideoEntities();
    final List<DownloadTask> downloadTasks =
        await FlutterDownloader.loadTasks() ?? [];
    for (var entity in videoEntities) {
      String taskId = entity.taskId;
      DownloadTask? task =
          downloadTasks.firstWhereOrNull((task) => task.taskId == taskId);
      DownloadTaskStatus? status = task?.status;
      int? progress = task?.progress;
      _downloads.put(
          entity.id,
          DownloadInfo(
              videoEntity: entity,
              downloadStatus: status ?? DownloadTaskStatus.undefined,
              downloadProgress: progress));
      _taskIdToVideoId[taskId] = entity.id;
    }
    _initialLoadDone = true;
    notifyListeners();
  }

  void _handleCompletedDownload(DownloadInfo downloadInfo) async {
    logger.info(
        "Download completed for video: ${downloadInfo.videoEntity.title}");
    Countly.instance.events.recordEvent("DOWNLOAD_COMPLETED", null, 1);
    VideoEntity entity = downloadInfo.videoEntity;
    String taskId = entity.taskId;
    List<DownloadTask>? list = await FlutterDownloader.loadTasksWithRawQuery(
            query: "$_SQL_GET_SINGLE_TASK'$taskId'") ??
        [];

    if (list.isEmpty) {
      logger.severe(
          "No DownloadTask found for taskId $taskId. This should not happen.");
      return;
    }

    DownloadTask task = list.first;
    assert(task.taskId == entity.taskId,
        "TaskId from DownloadManager does not match TaskId from FlutterDownloader");

    logger.info("point1");

    await _updateDbAndCacheDownloadingVideo(
      downloadInfo,
      filePath: Value(task.savedDir),
      fileName: Value(task.filename),
      timestampVideoSaved: Value(DateTime.now()),
    );
  }

  Future<void> _updateDbAndCacheDownloadingVideo(
    DownloadInfo downloadInfo, {
    Value<String> filePath = const Value.absent(),
    Value<String?> fileName = const Value.absent(),
    Value<DateTime> timestampVideoSaved = const Value.absent(),
    Value<String> taskId = const Value.absent(),
  }) async {
    VideoEntity entity = downloadInfo.videoEntity;

    logger.info("point2");

    _downloads.put(
      entity.id,
      downloadInfo.copyWith(
        videoEntity: entity.copyWith(
          filePath: filePath,
          fileName: fileName,
          timestampVideoSaved: timestampVideoSaved,
          taskId: taskId.present ? taskId.value : null,
        ),
      ),
    );
    notifyListeners();
    logger.info("Done downloading: ${_downloads.getByKey(entity.id)}");
    // for ios, saving the directory is useless as the base directory gets mounted to a unique id every restart
    int rowsUpdated = await appDatabase.updateDownloadingVideoEntity(
        oldTaskId: entity.taskId,
        filePath: filePath,
        fileName: fileName,
        timestampVideoSaved: timestampVideoSaved,
        newTaskId: taskId);

    logger.fine("Updated $rowsUpdated relations.");
  }

  void _handleCanceledDownload(VideoEntity entity) {
    deleteVideo(entity.id);
  }

  void _handleFailedDownload(VideoEntity entity) {
    _deleteVideo(entity);

    Countly.instance.events.recordEvent("DOWNLOAD_FAILED", null, 1);
  }

  DownloadInfo? getEntityForId(String videoId) {
    return _downloads.getByKey(videoId);
  }

  Future<bool> deleteVideo(String videoId) async {
    DownloadInfo? downloadInfo = _downloads.getByKey(videoId);
    if (downloadInfo == null) {
      logger.warning(
          "Tried to delete video with id $videoId, but it does not exist in the cache.");
      return false;
    }
    VideoEntity entity = downloadInfo.videoEntity;

    return _cancelDownload(entity.taskId).then((_) => _deleteVideo(entity));
  }

  Future<bool> _deleteVideo(VideoEntity entity) async {
    await _deleteFromVideoSchema(entity.id);
    _taskIdToVideoId.remove(entity.taskId);
    notifyListeners();
    return _deleteFromFilesystem(entity);
  }

  Future<bool> _deleteFromFilesystem(VideoEntity entity) async {
    if (entity.filePath == null || entity.filePath == '') {
      return true;
    }

    Uri filepath;
    if (appPlatform == AppPlatform.iOS) {
      filepath =
          Uri.file("${localDirectory.path}/MediathekView/${entity.fileName}");
    } else {
      filepath = Uri.file("${entity.filePath}/${entity.fileName}");
    }

    logger.fine("file to be deleted uri: $filepath");
    File fileToBeDeleted = File.fromUri(filepath);

    if (!await fileToBeDeleted.exists()) {
      logger.severe(
          "Trying to delete video from filepath that does not exist: ${fileToBeDeleted.uri}");
    }

    return fileToBeDeleted.delete().then((FileSystemEntity file) {
      logger.info(
          "Successfully deleted file${file.path} exists: ${file.existsSync()}");
      return true;
    }, onError: (e) {
      logger.severe(
          "Error when deleting file from disk: ${fileToBeDeleted.uri} Error: $e");
      return false;
    });
  }

  Future<int> _deleteFromVideoSchema(String videoId) async {
    _downloads.remove(videoId);
    return appDatabase.deleteVideoEntity(videoId).then((int rowsAffected) {
      return rowsAffected;
    }, onError: (e) {
      logger.severe("Error when deleting video from 'VideoEntity' schema");
      return 0;
    });
  }

  // Remove from task schema and cancel download if running
  Future _cancelDownload(String taskId) {
    logger.fine("Deleting Task with id $taskId");
    Countly.instance.events.recordEvent("CANCEL_DOWNLOAD", null, 1);

    return FlutterDownloader.cancel(taskId: taskId).then((_) =>
        FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: true));
  }

  Future<void> retryFailedDownloads() async {
    Iterable<DownloadInfo> failedDownloads = _downloads.getAllSorted().where(
        (download) => download.downloadStatus == DownloadTaskStatus.failed);

    for (DownloadInfo task in failedDownloads) {
      logger.info("Retrying failed download with of ${task.videoEntity.title}");
      String? newTaskId =
          await FlutterDownloader.retry(taskId: task.videoEntity.taskId);
      if (newTaskId != null) {
        logger
            .info("Successfully retried download with new taskId: $newTaskId");
        _taskIdToVideoId[newTaskId] = task.videoEntity.id;
        await _updateDbAndCacheDownloadingVideo(task, taskId: Value(newTaskId));
      }
    }
    return;
  }

  List<DownloadInfo> getAllDownloads() {
    return _downloads
        .getAllSorted()
        .where((info) =>
            info.videoEntity.fileName != null &&
            info.videoEntity.fileName!.isNotEmpty)
        .toList();
  }

  List<DownloadInfo> getCurrentDownloads() {
    return _downloads
        .getAllSorted()
        .where((info) => info.isDownloading || info.isPaused || info.isEnqueued)
        .toList();
  }

  // Check & request filesystem permissions
  void checkAndRequestFilesystemPermissions(Video video) async {
    logger.info("Requesting Filesystem Permissions");
    rememberedFailedVideoDownload = video;
    //ask for user permission
    bool successfullyAsked = await (Permission.videos.request()).isGranted;

    await Permission.notification.request().isGranted;

    if (!successfullyAsked) {
      logger.severe("Failed to ask user for Filesystem Permissions");
    }

    downloadFile(rememberedFailedVideoDownload);
  }

  Future<Video> downloadFile(Video video) async {
    Uri videoUrl = video.url_video!;

    Directory directory = localDirectory;

    logger.info("External Storage: ${directory.path}");
    Directory storageDirectory = Directory("${directory.path}/MediathekView");
    await storageDirectory.create();

    // same as video id if provided
    String? taskId = await FlutterDownloader.enqueue(
      url: videoUrl.toString(),
      savedDir: storageDirectory.path,
      //  getFileNameForVideo(video.id, video.url_video, video.title)
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification: true,
      // click on notification to open downloaded file (for Android)
      saveInPublicStorage: false,
    );

    logger.fine("generated taskId: $taskId");

    logger.info(
        "Requested download of video with id ${video.id} and url ${video.url_video}");
    logger.fine(
        "Requested download of video with id ${video.id} and url ${video.url_video}");

    Countly.instance.events.recordEvent("DOWNLOAD_VIDEO", null, 1);

    /*
    First check if there is already a VideoEntity.
    Once finished downloading, the filepath and filename will be updated.
     */
    VideoEntity? alreadyExistingEntity = getEntityForId(video.id!)?.videoEntity;
    logger.fine(" Already existing entity: $alreadyExistingEntity");
    if (alreadyExistingEntity != null) {
      //perform update
      logger.info(
          "Video to download already exist in db (possibly due to previous rating). Upadting entity with download information");
      alreadyExistingEntity = alreadyExistingEntity.copyWith(taskId: taskId);
      bool rowsUpdated =
          await appDatabase.updateVideoEntity(alreadyExistingEntity);
      logger.info(
          "Updated $rowsUpdated rows when starting download for already existing entity");
    } else {
      VideoEntity entity = video.toVideoEntity(taskId: taskId!);
      logger.fine(" Inserting new video entity: ${entity.taskId}");
      //set TaskId to associate with running download
      _downloads.put(video.id!, DownloadInfo(videoEntity: entity));
      notifyListeners();
      await appDatabase.insertVideo(entity);
      logger.fine(
          "Inserted new video with id ${video.id} and taskId $taskId to database");
      logger.fine("Inserted new currently downloading video to Database");
    }
    _taskIdToVideoId[taskId!] = video.id!;
    return video;
  }

  void setStatusForDownloadInfo(String videoId, DownloadTaskStatus status,
      {int? progress}) {
    DownloadInfo? downloadInfo = _downloads.getByKey(videoId);
    if (downloadInfo != null) {
      _downloads.put(
        videoId,
        downloadInfo.copyWith(
          downloadStatus: status,
          downloadProgress: progress,
        ),
      );
      notifyListeners();
    } else {
      logger.warning(
          "Tried to set status for non-existing video with id $videoId");
    }
  }
}

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
