import 'dart:io';

import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_ws/drift_database/app_database.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/platform_channels/download_manager_flutter.dart';
import 'package:flutter_ws/platform_channels/samsung_tv_cast_manager.dart';
import 'package:flutter_ws/util/device_information.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/countly.dart';

class AppState extends ChangeNotifier {
  final Logger logger = Logger('AppState');

  AppState({
    bool isCurrentlyPlayingOnTV = false,
    this.tvCurrentlyPlayingVideo,
    this.availableTvs = const [],
    this.favoriteChannels = const {},
  }) : _isCurrentlyPlayingOnTV = isCurrentlyPlayingOnTV;

  AppPlatform? _targetPlatform;
  late final Directory? localDirectory;
  final DownloadManager downloadManager = DownloadManager();
  late final AppDatabase appDatabase;
  late final SharedPreferences sharedPreferences;
  late final bool isPipAvailable;
  bool _initialized = false;

  // only relevant on Android, always true on other platforms
  bool _hasFilesystemPermission = false;
  Map<String, ChannelFavorite> favoriteChannels;

  // Samsung TV cast
  final SamsungTVCastManager samsungTVCastManager = SamsungTVCastManager();
  bool _isCurrentlyPlayingOnTV;
  Video? tvCurrentlyPlayingVideo;
  List<String> availableTvs;

  bool get hasFilesystemPermission => _hasFilesystemPermission;

  set hasFilesystemPermission(bool permission) {
    _hasFilesystemPermission = permission;
    notifyListeners();
  }

  AppPlatform? get targetPlatform => _targetPlatform;

  set targetPlatform(AppPlatform? platform) {
    _targetPlatform = platform;
    notifyListeners();
  }

  bool get isCurrentlyPlayingOnTV => _isCurrentlyPlayingOnTV;

  set isCurrentlyPlayingOnTV(bool isPlaying) {
    _isCurrentlyPlayingOnTV = isPlaying;
    notifyListeners();
  }

  bool get hasCountlyPermission =>
      sharedPreferences
          .getBool(CountlyUtil.SHARED_PREFERENCE_KEY_COUNTLY_CONSENT) ??
      false;

  set hasCountlyPermission(bool permission) {
    sharedPreferences.setBool(
        CountlyUtil.SHARED_PREFERENCE_KEY_COUNTLY_CONSENT, permission);
    notifyListeners();
  }

  void setSharedPreferences(SharedPreferences preferences) {
    sharedPreferences = preferences;
  }

  Future<void> ensureInitialized() async {
    if (_initialized) {
      return;
    }
    logger.info("Initializing AppState");
    FlutterDownloader.initialize(debug: true);

    logger.info("Initializing Filesystem Permission Manager");
    // async execution to concurrently open database
    await getPlatformAndSetDirectory();
    await initDBAndDownloadManager();
    if (targetPlatform == AppPlatform.android) {
      isPipAvailable = await Floating().isPipAvailable.then((value) {
        logger.info("PIP is available: $value");
        return value;
      }, onError: (error, stacktrace) => logger.severe("$error:\n$stacktrace"));
    } else {
      isPipAvailable = false;
      logger.info("PIP is not available on this platform");
    }

    _initialized = true;
  }

  Future<void> initDBAndDownloadManager() async {
    logger.info("Initializing AppDatabase and DownloadManager");
    appDatabase = AppDatabase();
    //await initializeDatabase().then((_) =>
    //    logger.info("Database initialized: ${databaseManager.db != null}"));
    //start subscription to Flutter Download Manager
    downloadManager.initialize(this);

    //check for downloads that have been completed while flutter app was not running
    downloadManager.syncCompletedDownloads();

    //check for failed DownloadTasks and retry them
    downloadManager.retryFailedDownloads();

    prefillFavoritedChannels();
    logger.info("initialized DB and DownloadManager");
  }

  Future<void> getPlatformAndSetDirectory() async {
    logger.info("Getting target platform and local directory");
    targetPlatform = await DeviceInformation.getTargetPlatform();
    logger.info("Target platform set to: $targetPlatform");

    bool hasPermission = true;
    //if (targetPlatform == TargetPlatform.android) {
    //  hasPermission =
    //      await filesystemPermissionManager.hasFilesystemPermission();
    //}
    //print("Has filesystem permission: $hasPermission");

    hasFilesystemPermission = hasPermission;

    Directory? directory;
    if (targetPlatform == AppPlatform.web) {
      logger.warning("Web platform detected, no local directory available");
      localDirectory = null;
      return;
    }
    if (targetPlatform == null) {
      logger.severe("Target platform is null, cannot set local directory");
      return;
    }
    if (targetPlatform == AppPlatform.android) {
      directory = await getExternalStorageDirectory().then((dir) => dir,
          onError: (error, stacktrace) =>
              logger.severe("$error:\n$stacktrace"));
    } else {
      directory = await getApplicationDocumentsDirectory().then((dir) => dir,
          onError: (error, stacktrace) =>
              logger.severe("$error:\n$stacktrace"));
    }
    localDirectory = directory;
    logger.info("Local directory set to: ${localDirectory!.path}");
    if (directory == null) {
      logger.severe("Failed to get local directory");
      return;
    }
    logger.info("Local directory initialized: ${directory.path}");

    // create thumbnail directory
    final Directory thumbnailDirectory =
        Directory('${directory.path}/MediathekView/thumbnails/');

    if (!await thumbnailDirectory.exists()) {
      //if folder already exists return path
      await thumbnailDirectory.create(recursive: true).then((dir) => dir,
          onError: (error, stacktrace) => logger.info(
              "Failed to create thumbnail directory $error.\nStacktrace: $stacktrace"));
    }
    logger.fine("Local directory and thumbnail directory initialized");
  }

  void prefillFavoritedChannels() async {
    List<ChannelFavorite> channels = await appDatabase.getAllChannelFavorites();
    logger.fine(
        "There are ${channels.length} favorited channels in the database");
    for (var entity in channels) {
      favoriteChannels.putIfAbsent(entity.channelName, () => entity);
    }
  }
}
