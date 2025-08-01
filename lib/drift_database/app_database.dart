import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:logging/logging.dart';

import 'converters.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Videos, VideoProgress, ChannelFavorites])
class AppDatabase extends _$AppDatabase {
  AppDatabase({Future<Object> Function()? databaseDir, QueryExecutor? executor})
      : super(executor ?? _openConnection(databaseDir));

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection(Future<Object> Function()? databaseDir) {
    return driftDatabase(
      name: 'mv_database',
      native: DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: databaseDir,
      ),
    );
  }

  final Logger logger = Logger('AppDatabase');

  Future<List<ChannelFavorite>> getAllChannelFavorites() =>
      managers.channelFavorites.get();

  Future<VideoEntity?> getVideoEntityForTaskId(String? taskId) async {
    List<VideoEntity> entities =
        await managers.videos.filter((f) => f.taskId(taskId)).get(limit: 1);
    return entities.firstOrNull;
  }

  Future<int> updateDownloadingVideoEntity(
      {required String oldTaskId,
      Value<String?> filePath = const Value.absent(),
      Value<String?> fileName = const Value.absent(),
      Value<DateTime?> timestampVideoSaved = const Value.absent(),
      Value<String> newTaskId = const Value.absent()}) async {
    return managers.videos.filter((f) => f.taskId(oldTaskId)).update((o) => o(
        filePath: filePath,
        fileName: fileName,
        timestampVideoSaved: timestampVideoSaved,
        taskId: newTaskId));
  }

  Future<VideoEntity?> getVideoEntity(String id) async {
    return managers.videos.filter((f) => f.id(id)).getSingleOrNull();
  }

  Future<int> deleteVideoEntity(String id) async {
    return managers.videos.filter((f) => f.id(id)).delete();
  }

  Future<List<VideoEntity>> getVideoEntitiesForTaskIds(
      List<String> taskIds) async {
    List<VideoEntity> resultList =
        await managers.videos.filter((f) => f.taskId.isIn(taskIds)).get();
    if (taskIds.length != resultList.length) {
      logger
          .severe("Download running that we do not have in the Video database");
    }
    return resultList;
  }

  Future<bool> updateVideoEntity(VideoEntity entity) async {
    return managers.videos.replace(entity);
  }

  Future<int> insertVideo(VideoEntity video) async {
    return into(videos)
        .insert(video.copyWith(timestampVideoSaved: Value(DateTime.now())));
  }

  Future<List<VideoEntity>> getAllDownloadedVideos() async {
    //Downloaded videos have a filename set when the download finished, otherwise they are current downloads
    return managers.videos
        .filter((f) => f.fileName.isNotNull() & f.fileName("").not())
        .orderBy((o) => o.timestampVideoSaved.desc())
        .get();
  }

  Future<List<VideoEntity>> getAllVideoEntities() async {
    return managers.videos.orderBy((o) => o.timestampVideoSaved.desc()).get();
  }

  ProgressEntityListQuery _lastViewedVideos(int amount) {
    return managers.videoProgress
        .orderBy((o) => o.timestampLastViewed.desc())
        .limit(amount);
  }

  Future<List<VideoProgressEntity>> getLastViewedVideos(int amount) {
    return _lastViewedVideos(amount).get();
  }

  Stream<List<VideoProgressEntity>> getLastViewedVideosStream(int amount) {
    return _lastViewedVideos(amount).watch();
  }

  void updatePlaybackPosition(VideoProgressEntity video, Duration position,
      {DateTime? lastViewed}) {
    getVideoProgressEntity(video.id).then((entity) {
      if (entity == null) {
        // initial insert into database
        _insertPlaybackPosition(video, position, lastViewed: lastViewed);
      } else {
        _updateProgress(video.id, position, lastViewed: lastViewed);
      }
    });
  }

  Future<VideoProgressEntity?> getVideoProgressEntity(String id) async {
    return managers.videoProgress.filter((f) => f.id(id)).getSingleOrNull();
  }

  Future<int> insertVideoProgress(VideoProgressEntity entity) async {
    return into(videoProgress).insert(entity);
  }

  // initial insert into database containing all the video information
  void _insertPlaybackPosition(VideoProgressEntity video, Duration position,
      {DateTime? lastViewed}) {
    // get entity from video;

    insertVideoProgress(video.copyWith(
            progress: Value(position),
            timestampLastViewed: Value(lastViewed ?? DateTime.now())))
        .then((value) {
      logger
          .info("Successfully inserted progress entity for video ${video.id}");
    }, onError: (err, stackTrace) {
      logger.warning("Could not insert video progress $stackTrace");
    });
  }

  void _updateProgress(String videoId, Duration position,
      {DateTime? lastViewed}) {
    updateVideoProgressEntity(videoId, position, lastViewed: lastViewed).then(
        (rowsUpdated) {
      if (rowsUpdated < 1) {
        logger.warning("Could not update video progress. Rows Updated < 1");
      }
    }, onError: (err, stackTrace) {
      logger.warning("Could not update video progress $stackTrace");
    });
  }

  Future<int> updateVideoProgressEntity(String videoId, Duration position,
      {DateTime? lastViewed}) async {
    return managers.videoProgress.filter((f) => f.id(videoId)).update((o) => o(
        progress: Value(position),
        timestampLastViewed: Value(lastViewed ?? DateTime.now())));
  }

  Future<VideoEntity?> getDownloadedVideo(String? id) async {
    return managers.videos
        .filter((f) => f.id(id) & f.fileName.isNotNull() & f.fileName("").not())
        .limit(1)
        .getSingleOrNull();
  }

  Future<List<VideoProgressEntity>> getAllLastViewedVideos() async {
    return managers.videoProgress
        .orderBy((o) => o.timestampLastViewed.desc())
        .get();
  }
}

typedef ProgressEntityListQuery = ProcessedTableManager<
    _$AppDatabase,
    $VideoProgressTable,
    VideoProgressEntity,
    $$VideoProgressTableFilterComposer,
    $$VideoProgressTableOrderingComposer,
    $$VideoProgressTableAnnotationComposer,
    $$VideoProgressTableCreateCompanionBuilder,
    $$VideoProgressTableUpdateCompanionBuilder,
    (
      VideoProgressEntity,
      BaseReferences<_$AppDatabase, $VideoProgressTable, VideoProgressEntity>
    ),
    VideoProgressEntity,
    PrefetchHooks Function()>;
