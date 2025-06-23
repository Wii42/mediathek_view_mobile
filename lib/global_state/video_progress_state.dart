import 'dart:collection';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../drift_database/app_database.dart';

class VideoProgressState extends ChangeNotifier {
  final AppDatabase _db;
  bool _loadedAllFromDb = false;
  int _lastViewedVideosAmount = 0;

  /// Set to keep track of which video ids have already been checked in the database,
  /// to avoid unnecessary database queries if null is returned.
  final Set<String> _alreadyCheckedInDb = {};

  /// Map to keep track of the last thime the playback position was written to the database.
  /// Used to avoid writing too often to the db.
  final Map<String, DateTime> _playbackPositionWrittenToDb = {};
  static const Duration _playbackPositionWriteCooldown = Duration(seconds: 5);

  /// Map to keep track of the last time the playback position was notified to listeners.
  /// Used to avoid notifying too often.
  final Map<String, DateTime> _playbackPositionNotified = {};

  static const Duration _playbackPositionNotifyCooldown =
      Duration(milliseconds: 500);

  final Map<String, VideoProgressEntity> _videoProgressMap = {};
  final SplayTreeSet<VideoProgressEntity> _videoProgressSortedSet =
      SplayTreeSet<VideoProgressEntity>(
          _sortEntriesByLastWatched, _acceptEntryInSet);

  VideoProgressState(this._db);

  List<VideoProgressEntity> getLastViewedVideos(int amount) {
    if (amount > _lastViewedVideosAmount || !_loadedAllFromDb) {
      _loadLastViewedFromDb(amount);
    }
    return _videoProgressSortedSet.take(amount).toList();
  }

  Future<void> _loadLastViewedFromDb(int amount) async {
    List<VideoProgressEntity> loadedEntities =
        await _db.getLastViewedVideos(amount);
    for (VideoProgressEntity entity in loadedEntities) {
      _putIfAbsent(entity.id, entity);
    }
    _lastViewedVideosAmount = amount;
    notifyListeners();
  }

  void updatePlaybackPosition(VideoProgressEntity video, Duration position) {
    DateTime lastViewed = DateTime.now();
    _updateVideoProgress(video, position, lastViewed);
    if (!_playbackPositionNotified.containsKey(video.id) ||
        DateTime.now().difference(_playbackPositionNotified[video.id]!) >=
            _playbackPositionNotifyCooldown) {
      notifyListeners();
      _playbackPositionNotified[video.id] = DateTime.now();
    }
    if (!_playbackPositionWrittenToDb.containsKey(video.id) ||
        DateTime.now().difference(_playbackPositionWrittenToDb[video.id]!) >=
            _playbackPositionWriteCooldown) {
      _db.updatePlaybackPosition(video, position, lastViewed: lastViewed);
      _playbackPositionWrittenToDb[video.id] = DateTime.now();
    }
  }

  VideoProgressEntity? getVideoProgressEntity(String id) {
    VideoProgressEntity? entity = _videoProgressMap[id];
    if (entity == null &&
        !_loadedAllFromDb &&
        !_alreadyCheckedInDb.contains(id)) {
      _loadFromDb(id);
    }
    return entity;
  }

  List<VideoProgressEntity> getAllLastViewedVideos() {
    if (!_loadedAllFromDb) {
      _loadAllLastViewedFromDb();
    }
    return _videoProgressSortedSet.toList();
  }

  Future<void> _loadAllLastViewedFromDb() async {
    List<VideoProgressEntity> loadedEntities =
        await _db.getAllLastViewedVideos();
    for (VideoProgressEntity entity in loadedEntities) {
      _putIfAbsent(entity.id, entity);
    }
    _loadedAllFromDb = true;
    notifyListeners();
  }

  /// Compare fuction for SplayTreeSet to sort VideoProgressEntity by timestampLastViewed.
  /// Sorts in descending order, so the most recently watched video is first.
  static int _sortEntriesByLastWatched(
      VideoProgressEntity a, VideoProgressEntity b) {
    return b.timestampLastViewed!.compareTo(a.timestampLastViewed!);
  }

  /// Makes sure that only VideoProgressEntity with a non-null
  /// timestampLastViewed are compared and added to the set.
  static bool _acceptEntryInSet(dynamic key) {
    return key is VideoProgressEntity && key.timestampLastViewed != null;
  }

  void _putIfAbsent(String videoId, VideoProgressEntity entity) {
    if (!_videoProgressMap.containsKey(videoId)) {
      _videoProgressMap[videoId] = entity;
      _videoProgressSortedSet.add(entity);
    }
  }

  void _updateVideoProgress(
      VideoProgressEntity entity, Duration progress, DateTime lastViewed) {
    VideoProgressEntity newEntity = entity.copyWith(
      timestampLastViewed: Value(lastViewed),
      progress: Value(progress),
    );
    _videoProgressMap[newEntity.id] = newEntity;
    _videoProgressSortedSet.removeWhere((obj) => obj.id == newEntity.id);
    _videoProgressSortedSet.add(newEntity);
  }

  Future<void> _loadFromDb(String id) async {
    VideoProgressEntity? loadedEntity = await _db.getVideoProgressEntity(id);
    if (loadedEntity != null) {
      _putIfAbsent(loadedEntity.id, loadedEntity);
      notifyListeners();
    } else {
      _alreadyCheckedInDb.add(id);
    }
  }
}
