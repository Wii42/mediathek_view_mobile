import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_ws/database/channel_favorite_entity.dart';
import 'package:flutter_ws/database/database_manager.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/platform_channels/download_manager_flutter.dart';
import 'package:flutter_ws/platform_channels/filesystem_permission_manager.dart';
import 'package:flutter_ws/platform_channels/samsung_tv_cast_manager.dart';
import 'package:flutter_ws/platform_channels/video_preview_manager.dart';
import 'package:flutter_ws/util/device_information.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoListState extends ChangeNotifier {
  final Logger logger = Logger('VideoListState');
  final Set<String> _extendedListTiles;
  final Map<String, Image> _previewImages;

  VideoListState(
      {Set<String> extendedListTiles = const {},
      Map<String, Image> previewImages = const {}})
      : _extendedListTiles = extendedListTiles,
        _previewImages = previewImages;

  Set<String> get extendedListTiles => Set.unmodifiable(_extendedListTiles);

  Map<String, Image> get previewImages => Map.unmodifiable(_previewImages);

  void addImagePreview(String videoId, Image preview) {
    logger.fine("Adding preview image to state for video with id $videoId");
    _previewImages.putIfAbsent(videoId, () => preview);
    notifyListeners();
  }

  void updateExtendedListTile(String videoId) {
    _extendedListTiles.contains(videoId)
        ? _extendedListTiles.remove(videoId)
        : _extendedListTiles.add(videoId);
    notifyListeners();
  }
}

class AppState extends ChangeNotifier {
  final Logger logger = Logger('AppState');

  AppState({
    this.isCurrentlyPlayingOnTV = false,
    this.tvCurrentlyPlayingVideo,
    this.availableTvs = const [],
    this.favoriteChannels = const {},
  });

  TargetPlatform? _targetPlatform;
  late final Directory? localDirectory;
  final DownloadManager downloadManager = DownloadManager();
  final DatabaseManager databaseManager = DatabaseManager();
  final VideoPreviewManager videoPreviewManager = VideoPreviewManager();
  final FilesystemPermissionManager filesystemPermissionManager =
      FilesystemPermissionManager();
  late final SharedPreferences sharedPreferences;
  bool _initialized = false;

  // only relevant on Android, always true on other platforms
  bool _hasFilesystemPermission = false;
  Map<String?, ChannelFavoriteEntity> favoriteChannels;

  // Samsung TV cast
  final SamsungTVCastManager samsungTVCastManager = SamsungTVCastManager();
  bool isCurrentlyPlayingOnTV;
  Video? tvCurrentlyPlayingVideo;
  List<String> availableTvs;

  bool get hasFilesystemPermission => _hasFilesystemPermission;

  set hasFilesystemPermission(bool permission) {
    _hasFilesystemPermission = permission;
    notifyListeners();
  }

  TargetPlatform? get targetPlatform => _targetPlatform;

  set targetPlatform(TargetPlatform? platform) {
    _targetPlatform = platform;
    notifyListeners();
  }

  void setSharedPreferences(SharedPreferences preferences) {
    sharedPreferences = preferences;
  }

  Future<void> ensureInitialized() async {
    if (_initialized) {
      return;
    }
    print("Initializing AppState");
    FlutterDownloader.initialize();

    videoPreviewManager.appWideState = this;
    logger.info("Initializing Filesystem Permission Manager");
    // async execution to concurrently open database
    await Future.wait(
        [getPlatformAndSetDirectory(), initDBAndDownloadManager()]);

    _initialized = true;
  }

  Future<void> initDBAndDownloadManager() async {
    await initializeDatabase().then((_) => print("Database initialized: ${databaseManager.db != null}"));
    //start subscription to Flutter Download Manager
    downloadManager.startListeningToDownloads(this);

    //check for downloads that have been completed while flutter app was not running
    downloadManager.syncCompletedDownloads();

    //check for failed DownloadTasks and retry them
    downloadManager.retryFailedDownloads();

    prefillFavoritedChannels();
    print("initialized DB and DownloadManager");
  }

  Future<void> getPlatformAndSetDirectory() async {
    print("Getting target platform and local directory");
    targetPlatform = await DeviceInformation.getTargetPlatform();
    print("Target platform set to: $targetPlatform");

    bool hasPermission = true;
    if (targetPlatform == TargetPlatform.android) {
      hasPermission =
          await filesystemPermissionManager.hasFilesystemPermission();
    }
    print("Has filesystem permission: $hasPermission");

    hasFilesystemPermission = hasPermission;

    Directory? directory;
    if (targetPlatform == TargetPlatform.iOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }
    localDirectory = directory;
    print("Local directory set to: ${localDirectory!.path}");
    if (directory == null) {
      logger.severe("Failed to get local directory");
      return;
    }
    print("Local directory initialized: ${directory.path}");

    // create thumbnail directory
    final Directory thumbnailDirectory =
        Directory('${directory.path}/MediathekView/thumbnails/');

    if (!await thumbnailDirectory.exists()) {
      //if folder already exists return path
      await thumbnailDirectory.create(recursive: true).catchError((error) =>
          logger.info("Failed to create thumbnail directory $error"));
    }
    print("Local directory and thumbnail directory initialized");
  }

  void prefillFavoritedChannels() async {
    Set<ChannelFavoriteEntity> channels =
        await databaseManager.getAllChannelFavorites();
    logger.fine(
        "There are ${channels.length} favorited channels in the database");
    for (var entity in channels) {
      favoriteChannels.putIfAbsent(entity.name, () => entity);
    }
  }

  Future<void> initializeDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print("DB dir: ${documentsDirectory.path}");
    String path = join(documentsDirectory.path, "demo.db");
    //Uncomment when having made changes to the DB Schema
    //appState.databaseManager.deleteDb(path);
    //appState.databaseManager.deleteDb(join(documentsDirectory.path, "task.db"));
    return await databaseManager.open(path).then(
          (dynamic) => logger.info("Successfully opened database"),
          onError: (e) => logger.severe("Error when opening database"),
        );
  }
}

//class _InheritedWidget extends InheritedWidget {
//  final AppSharedState data;
//
//  const _InheritedWidget({
//    Key? key,
//    required this.data,
//    required Widget child,
//  }) : super(key: key, child: child);
//
//  @override
//  bool updateShouldNotify(_InheritedWidget old) {
//    return true;
//  }
//}
//
//class AppSharedStateContainer extends StatefulWidget {
//  final Widget child;
//  final VideoListState? videoListState;
//  final AppState? appState;
//
//  const AppSharedStateContainer(
//      {required this.child, this.videoListState, this.appState});
//
//  static AppSharedState of(BuildContext context) {
//    return context.dependOnInheritedWidgetOfExactType<_InheritedWidget>()!.data;
//  }
//
//  @override
//  AppSharedState createState() => AppSharedState();
//}
//
//class AppSharedState extends State<AppSharedStateContainer> {
//  final Logger logger = Logger('VideoWidget');
//
//  VideoListState? videoListState;
//  AppState? appState;
//
//  @override
//  Widget build(BuildContext context) {
//    logger.fine("Rendering StateContainerState");
//    return _InheritedWidget(
//      data: this,
//      child: widget.child,
//    );
//  }
//
//  void initializeState(BuildContext context) async {
//    videoListState ??= VideoListState();
//
//    if (appState != null) {
//      return;
//    }
//
//    DownloadManager downloadManager = DownloadManager(context);
//    WidgetsFlutterBinding.ensureInitialized();
//    FlutterDownloader.initialize();
//
//    DatabaseManager databaseManager = DatabaseManager();
//    var filesystemPermissionManager = FilesystemPermissionManager(context);
//
//    appState = AppState(
//        downloadManager,
//        databaseManager,
//        VideoPreviewManager(context),
//        filesystemPermissionManager,
//        SamsungTVCastManager(context),
//        false,
//        Video(""), [], {});
//
//    // async execution to concurrently open database
//    DeviceInformation.getTargetPlatform().then((platform) async {
//      appState!.targetPlatform = platform;
//
//      bool hasPermission = true;
//      if (platform == TargetPlatform.android) {
//        hasPermission =
//            await filesystemPermissionManager.hasFilesystemPermission();
//      }
//
//      appState!.hasFilesystemPermission = hasPermission;
//
//      Directory? directory;
//      if (platform == TargetPlatform.iOS) {
//        directory = await getApplicationDocumentsDirectory();
//      } else {
//        directory = await getExternalStorageDirectory();
//      }
//      appState!.setDirectory(directory);
//
//      // create thumbnail directory
//      final Directory thumbnailDirectory =
//          Directory('${directory!.path}/MediathekView/thumbnails/');
//
//      if (!await thumbnailDirectory.exists()) {
//        //if folder already exists return path
//        await thumbnailDirectory.create(recursive: true).catchError((error) =>
//            logger.info("Failed to create thumbnail directory $error"));
//      }
//    });
//
//    initializeDatabase().then((init) {
//      //start subscription to Flutter Download Manager
//      downloadManager.startListeningToDownloads();
//
//      //check for downloads that have been completed while flutter app was not running
//      downloadManager.syncCompletedDownloads();
//
//      //check for failed DownloadTasks and retry them
//      downloadManager.retryFailedDownloads();
//
//      prefillFavoritedChannels();
//    });
//  }
//
//  void prefillFavoritedChannels() async {
//    Set<ChannelFavoriteEntity> channels =
//        await appState!.databaseManager.getAllChannelFavorites();
//    logger.fine(
//        "There are ${channels.length} favorited channels in the database");
//    for (var entity in channels) {
//      appState!.favoriteChannels.putIfAbsent(entity.name, () => entity);
//    }
//  }
//
//  Future initializeDatabase() async {
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentsDirectory.path, "demo.db");
//    //Uncomment when having made changes to the DB Schema
//    //appState.databaseManager.deleteDb(path);
//    //appState.databaseManager.deleteDb(join(documentsDirectory.path, "task.db"));
//    return appState!.databaseManager.open(path).then(
//          (dynamic) => logger.info("Successfully opened database"),
//          onError: (e) => logger.severe("Error when opening database"),
//        );
//  }
//
//
//}
//
