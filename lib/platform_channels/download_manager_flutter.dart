import 'dart:async';
import 'dart:io';

import 'package:countly_flutter/countly_flutter.dart';
import 'package:drift/drift.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_ws/drift_database/app_database.dart';
import 'package:flutter_ws/global_state/app_state.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/platform_channels/flutter_downloader_isolate_connection.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiver/collection.dart';

import '../util/device_information.dart';

typedef OnFailed = void Function(String? videoId);
typedef OnComplete = void Function(String? videoId);
typedef OnCanceled = void Function(String? videoId);
typedef OnStateChanged = void Function(
    String? videoId, DownloadTaskStatus? status, double progress);

class DownloadManager {
  final Logger logger = Logger('DownloadManagerFlutter');
  static const String PERMISSION_DENIED_ID = "-1";
  static const SQL_GET_SINGLE_TASK = "SELECT * FROM task WHERE task_id =";
  static String SQL_GET_ALL_RUNNING_TASKS =
      "SELECT * FROM task WHERE status = ${DownloadTaskStatus.enqueued.index} OR status = ${DownloadTaskStatus.running.index} OR status = ${DownloadTaskStatus.paused.index}";
  static String SQL_GET_ALL_COMPLETED_TASKS =
      "SELECT * FROM task WHERE status = ${DownloadTaskStatus.complete.index}";
  static String SQL_GET_ALL_FAILED_TASKS =
      "SELECT * FROM task WHERE status = ${DownloadTaskStatus.failed.index}";

  //Listeners
  final Multimap<String?, MapEntry<int, OnFailed>> onFailedListeners =
      Multimap<String?, MapEntry<int, OnFailed>>();
  final Multimap<String?, MapEntry<int, OnComplete>> onCompleteListeners =
      Multimap<String?, MapEntry<int, OnComplete>>();
  final Multimap<String?, MapEntry<int, OnCanceled>> onCanceledListeners =
      Multimap<String?, MapEntry<int, OnCanceled>>();
  final Multimap<String?, MapEntry<int, OnStateChanged>>
      onStateChangedListeners =
      Multimap<String?, MapEntry<int, OnStateChanged>>();

  // VideoId -> VideoEntity
  final Map<String?, VideoEntity?> cache = {};

  // TaskID -> VideoId
  final Map<String?, String?> cacheTask = {};

  final AppDatabase appDatabase;
  final Directory localDirectory;
  final AppPlatform targetPlatform;

  late final FlutterDownloaderIsolateConnection backgroundIsolateConnection;

  //special case Android: remember Video to be able to resume download after grant of file system permission
  late Video rememberedFailedVideoDownload;

  DownloadManager(
      {required this.appDatabase,
      required this.localDirectory,
      required this.targetPlatform});

  Future<void> initialize() async {
    backgroundIsolateConnection =
        FlutterDownloaderIsolateConnection(handleDownloadProgress);
    await FlutterDownloader.initialize(debug: true);
    backgroundIsolateConnection.startListening();
    FlutterDownloader.loadTasks().then((list) => list?.forEach(print));
  }

  void handleDownloadProgress(
      String? taskId, DownloadTaskStatus? status, int? progress) async {
    print(
        "Received download update with status $status and progress $progress");
    logger.fine(
        "Received download update with status $status and progress $progress");
    String? videoId = cacheTask[taskId];
    VideoEntity? entity = cache[videoId];
    if (entity != null) {
      logger.fine("Cache hit for TaskID -> Entity");
      _notify(taskId, status, progress, entity);
    } else {
      VideoEntity? entity = await appDatabase.getVideoEntityForTaskId(taskId);
      if (entity == null) {
        logger.severe(
            "Received update for task that we do not know of - Ignoring");
        return;
      }
      _notify(taskId, status, progress, entity);
    }
  }

  void _notify(String? taskId, DownloadTaskStatus? status, int? progress,
      VideoEntity entity) {
    if (status == DownloadTaskStatus.failed) {
      //delete from schema first in case we want to try downloading video again
      handleFailedDownload(entity);
    } else if (status == DownloadTaskStatus.canceled) {
      handleCanceledDownload(entity);
    } else if (status == DownloadTaskStatus.complete) {
      //status now includes data that we want to add to the entity
      handleCompletedDownload(taskId, entity);
    } else if (status == DownloadTaskStatus.enqueued ||
        status == DownloadTaskStatus.running ||
        status == DownloadTaskStatus.paused &&
            onStateChangedListeners.isNotEmpty) {
      handleRunningDownload(entity, progress, status);
    }
  }

  void handleRunningDownload(
      VideoEntity entity, int? progress, DownloadTaskStatus? status) {
    Iterable<MapEntry<int?, OnStateChanged>> entries =
        onStateChangedListeners[entity.id];
    if (entries.isEmpty) {
      logger.info(
          "No subscriber found for progress update. Video: ${entity.title} id: ${entity.id}");
    }
    logger.info("Progress $progress");

    for (var entry in entries) {
      {
        entry.value(entity.id, status, progress!.toDouble());
      }
    }
  }

  void handleCompletedDownload(String? taskId, VideoEntity entity) async {
    Countly.instance.events.recordEvent("DOWNLOAD_COMPLETED", null, 1);

    List<DownloadTask>? list = await FlutterDownloader.loadTasksWithRawQuery(
            query: "$SQL_GET_SINGLE_TASK'$taskId'") ??
        [];

    if (list.isEmpty) {
      return;
    }

    DownloadTask task = list.first;
    assert(task.taskId == entity.taskId,
        "TaskId from DownloadManager does not match TaskId from FlutterDownloader");

    await _updateDbAndCacheDownloadingVideo(
      entity,
      filePath: Value(task.savedDir),
      fileName: Value(task.filename),
      timestampVideoSaved: Value(DateTime.now()),
    );

    // then notify listeners
    Iterable<MapEntry<int?, OnComplete>> entries =
        onCompleteListeners[entity.id];
    for (var entry in entries) {
      entry.value(entity.id);
    }
  }

  Future<void> _updateDbAndCacheDownloadingVideo(
    VideoEntity entity, {
    Value<String> filePath = const Value.absent(),
    Value<String?> fileName = const Value.absent(),
    Value<DateTime> timestampVideoSaved = const Value.absent(),
  }) async {
    // for ios, saving the directory is useless as the base directory gets mounted to a unique id every restart
    int rowsUpdated = await appDatabase.updateDownloadingVideoEntity(
        oldTaskId: entity.taskId,
        filePath: filePath,
        fileName: fileName,
        timestampVideoSaved: timestampVideoSaved);

    cache[entity.id] = entity.copyWith(
      filePath: filePath,
      fileName: fileName,
      timestampVideoSaved: timestampVideoSaved,
    );

    logger.fine("Updated $rowsUpdated relations.");
  }

  void handleCanceledDownload(VideoEntity entity) {
    deleteVideo(entity.id);
    Iterable<MapEntry<int?, OnCanceled>> entries =
        onCanceledListeners[entity.id];
    for (var entry in entries) {
      entry.value(entity.id);
    }
  }

  void handleFailedDownload(VideoEntity entity) {
    _deleteVideo(entity);

    Countly.instance.events.recordEvent("DOWNLOAD_FAILED", null, 1);

    //notify listeners
    Iterable<MapEntry<int?, OnCanceled>> entries = onFailedListeners[entity.id];
    for (var entry in entries) {
      entry.value(entity.id);
    }
  }

  // Check & request filesystem permissions
  void checkAndRequestFilesystemPermissions(
      AppState appWideState, Video video) async {
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

  // Check first if a entity with that id exists on the db or cache. If yes & task id is set, check Task schema for running, queued or paused status
  Future<DownloadTask?> isCurrentlyDownloading(String? videoId) async {
    if (videoId == null || videoId.isEmpty) {
      logger.warning(
          "Cannot check if video is currently downloading. VideoId is null or empty");
      return null;
    }
    return getEntityForId(videoId).then((entity) {
      if (entity == null || entity.taskId == '') {
        return null;
      }
      // if already has a filename, then it is already downloaded!
      if (entity.fileName != null && entity.fileName != '') {
        return null;
      }

      //check for right task status
      return FlutterDownloader.loadTasksWithRawQuery(
              query: "$SQL_GET_SINGLE_TASK'${entity.taskId}'")
          .then((List<DownloadTask>? list) {
        if (list!.isEmpty) {
          return null;
        }
        var task = list.first;

        if (task.status == DownloadTaskStatus.running ||
            task.status == DownloadTaskStatus.enqueued ||
            task.status == DownloadTaskStatus.paused) {
          return task;
        }
        return null;
      });
    });
  }

  //Checks if the video is downloaded already.
  // downloaded videos have a filePath set
  Future<VideoEntity?> isAlreadyDownloaded(String? videoId) async {
    if (videoId == null || videoId.isEmpty) {
      logger.warning(
          "Cannot check if video is downloaded. VideoId is null or empty");
      return null;
    }
    return getEntityForId(videoId).then((entity) {
      if (entity == null || entity.taskId == '') {
        return null;
      }
      // if it has a filename, then it is already downloaded!
      if (entity.fileName != null && entity.fileName != '') {
        return entity;
      }
      return null;
    });
  }

  Future<VideoEntity?> getEntityForId(String videoId) async {
    VideoEntity? entity = cache[videoId];
    if (entity != null) {
      logger.fine("Cache hit for VideoId -> Entity");
      return entity;
    } else {
      return appDatabase.getVideoEntity(videoId);
    }
  }

  //Delete all in one: as task & file & from VideoEntity schema
  Future<bool> deleteVideo(String videoId) async {
    cache[videoId] = null;
    return getEntityForId(videoId).then((entity) {
      if (entity == null) {
        logger.severe(
            "Video with id $videoId does not exist. Cannot fetch taskID to remove it via Downloader from tasks db and local file storage");
        return false;
      }
      logger.info(
          "Deleting video with id ${entity.id} and taskId ${entity.taskId} from VideoEntity schema and filesystem");

      // notify listeners about cancellation
      _notify(entity.taskId, DownloadTaskStatus.canceled, 0, entity);

      return _cancelDownload(entity.taskId)
          .then((dummy) => _deleteVideo(entity));
    });
  }

  Future<bool> _deleteVideo(VideoEntity entity) async {
    return _deleteFromVideoSchema(entity.id).then((deleted) {
      return _deleteFromFilesystem(entity);
    });
  }

  Future<bool> _deleteFromFilesystem(VideoEntity entity) async {
    if (entity.filePath == null || entity.filePath == '') {
      return true;
    }

    Uri filepath;
    if (targetPlatform == AppPlatform.iOS) {
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

  Future<int> _deleteFromVideoSchema(String videoId) {
    return appDatabase.deleteVideoEntity(videoId).then((int rowsAffected) {
      cache.remove(videoId);
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
        FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: false));
  }

  void subscribe(
      String? videoId,
      OnStateChanged onDownloadStateChanged,
      OnComplete onDownloadComplete,
      OnFailed onDownloadFailed,
      OnCanceled onDownloadCanceled,
      // used to differentiate between download section & list view section as both need to listen for updates!
      int identifier) {
    logger.fine("Subscribing on updates for video with id $videoId");
    onFailedListeners.add(videoId, MapEntry(identifier, onDownloadFailed));
    onCompleteListeners.add(videoId, MapEntry(identifier, onDownloadComplete));
    onStateChangedListeners.add(
        videoId, MapEntry(identifier, onDownloadStateChanged));
    onCanceledListeners.add(videoId, MapEntry(identifier, onDownloadCanceled));
  }

  void unsubscribe(String? videoId, int? identifier) {
    logger.fine("Cancel subscribtion on updates for video with id: $videoId");
    _removeValueFromMultimap(onFailedListeners, videoId, identifier);
    _removeValueFromMultimap(onCompleteListeners, videoId, identifier);
    _removeValueFromMultimap(onCanceledListeners, videoId, identifier);
    _removeValueFromMultimap(onStateChangedListeners, videoId, identifier);
  }

  void _removeValueFromMultimap(
      Multimap multimap, String? videoId, int? identifier) {
    String? keyToRemove;
    MapEntry? valueToRemove;
    // cannot break out of for each
    multimap.forEach((id, value) {
      if (videoId == id && value.key == identifier) {
        keyToRemove = id;
        valueToRemove = value;
      }
    });
    if (keyToRemove != null && keyToRemove!.isNotEmpty) {
      multimap.remove(keyToRemove, valueToRemove);
    }
  }

  Future<List<VideoEntity>> getCurrentDownloads() async {
    return _getCurrentDownloadTasks().then((tasks) async {
      if (tasks.isEmpty) {
        return <VideoEntity>[];
      }
      return appDatabase.getVideoEntitiesForTaskIds(
          tasks.map((task) => task.taskId).toList());
    });
  }

  Future<List<DownloadTask>> _getCurrentDownloadTasks() async {
    return _getTasksWithRawQuery(SQL_GET_ALL_RUNNING_TASKS);
  }

  Future<List<DownloadTask>> _getFailedTasks() async {
    return _getTasksWithRawQuery(SQL_GET_ALL_FAILED_TASKS);
  }

  Future<List<DownloadTask>> _getCompletedTasks() async {
    return _getTasksWithRawQuery(SQL_GET_ALL_COMPLETED_TASKS);
  }

  Future<List<DownloadTask>> _getTasksWithRawQuery(String query) async {
    return FlutterDownloader.loadTasksWithRawQuery(query: query)
        .then((List<DownloadTask>? list) {
      if (list == null) {
        return [];
      }
      return list;
    });
  }

  //sync completed DownloadTasks from DownloadManager with VideoEntity - filename and storage location
  void syncCompletedDownloads() async {
    List<DownloadTask> tasks = await _getCompletedTasks();
    for (DownloadTask task in tasks) {
      VideoEntity? entity =
          await appDatabase.getVideoEntityForTaskId(task.taskId);
      if (entity == null) {
        logger.fine(
            "Startup sync for completed downloads: task that we do not know of - Ignoring. URL: : ${task.url}");
        continue;
      }
      if (entity.filePath == null || entity.fileName == null) {
        logger.info(
            "Found download tasks that was completed while flutter app was not running. Syncing with VideoEntity Schema. Title: ${entity.title}");
        await _updateDbAndCacheDownloadingVideo(entity,
            filePath: Value(task.savedDir), fileName: Value(task.filename));
      }
      //also update cache
      cache.putIfAbsent(entity.id, () => entity);
    }
  }

  void retryFailedDownloads() async {
    List<DownloadTask> taskList = await _getFailedTasks();
    for (DownloadTask task in taskList) {
      VideoEntity? entity =
          await appDatabase.getVideoEntityForTaskId(task.taskId);
      if (entity == null) {
        logger.severe(
            "Startup sync for failed downloads: task that we do not know of - Ignoring. URL: : ${task.url}");
        continue;
      }

      //only retry for downloads we know about
      logger.info("Retrying failed download with url ${task.url}");
      FlutterDownloader.retry(taskId: task.taskId);
    }
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

    print("generated taskId: $taskId");

    logger.info(
        "Requested download of video with id ${video.id} and url ${video.url_video}");
    print(
        "Requested download of video with id ${video.id} and url ${video.url_video}");

    Countly.instance.events.recordEvent("DOWNLOAD_VIDEO", null, 1);

    /*
    First check if there is already a VideoEntity.
    Once finished downloading, the filepath and filename will be updated.
     */
    VideoEntity? alreadyExistingEntity = await getEntityForId(video.id!);
    print(" Already existing entity: $alreadyExistingEntity");
    if (alreadyExistingEntity != null) {
      //perform update
      logger.info(
          "Video to download already exist in db (possibly due to previous rating). Upadting entity with download information");
      alreadyExistingEntity = alreadyExistingEntity.copyWith(taskId: taskId);
      bool rowsUpdated =
          await appDatabase.updateVideoEntity(alreadyExistingEntity);
      logger.info(
          "Updated $rowsUpdated rows when starting download for already existing entity");
      cache[video.id] = alreadyExistingEntity;
    } else {
      VideoEntity entity = video.toVideoEntity(taskId: taskId!);
      print(" Inserting new video entity: ${entity.taskId}");
      //set TaskId to associate with running download
      await appDatabase.insertVideo(entity);
      print(
          "Inserted new video with id ${video.id} and taskId $taskId to database");
      logger.fine("Inserted new currently downloading video to Database");
      cache[video.id] = entity;
    }

    cacheTask.putIfAbsent(taskId, () {
      return video.id;
    });
    return video;
  }
}
