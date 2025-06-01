import 'dart:async';

import 'package:flutter_ws/database/channel_favorite_entity.dart';
import 'package:flutter_ws/database/video_entity.dart';
import 'package:flutter_ws/database/video_progress_entity.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqflite.dart';

const String columnId = "_id";
const String columnTitle = "title";
const String columnDone = "done";

class DatabaseManager {
  final Logger logger = Logger('DatabaseManager');
  Database? db;

  Future<void> open(String path) async {
    db = await openDatabase(path,
        version: 1,
        onConfigure: (db) => logger.info("DB onConfigure: $db"),
        onCreate: (Database db, int version) {
          logger.info("DB init: $db");
          String createVideoTableSQL = getVideoTableSQL();
          String createFavoriteLiveTVChannelsTable = getChannelFavoriteSQL();
          String videoProgressCreateTableSQL = getProgressTableSQL();

          logger.fine("DB MANAGER: Executing $createVideoTableSQL");
          db.execute(createVideoTableSQL);
          logger
              .fine("DB MANAGER: Executing $createFavoriteLiveTVChannelsTable");
          db.execute(createFavoriteLiveTVChannelsTable);
          logger.fine("DB MANAGER: Executing $videoProgressCreateTableSQL");
          db.execute(videoProgressCreateTableSQL);
          logger.info("DB init: $db");
        });
  }

  Future close() async => db!.close();
  Future deleteDb(String path) async => deleteDatabase(path);

  String getVideoTableSQL() {
    var sql = '''create table ${VideoEntity.TABLE_NAME} ( 
       ${VideoEntity.idColumn} text primary key, 
         ${VideoEntity.task_idColumn} VARCHAR ( 256 ) not null,
       ${VideoEntity.channelColumn} text not null,
       ${VideoEntity.topicColumn} text not null,
       ${VideoEntity.descriptionColumn} text,
       ${VideoEntity.titleColumn} text not null,
       ${VideoEntity.timestampColumn} integer,
       ${VideoEntity.timestamp_video_savedColumn} integer,
       ${VideoEntity.durationColumn} text,
       ${VideoEntity.sizeColumn} integer,
       ${VideoEntity.url_websiteColumn} text,
       ${VideoEntity.url_video_lowColumn} text,
       ${VideoEntity.url_video_hdColumn} text,
       ${VideoEntity.filmlisteTimestampColumn} text,
       ${VideoEntity.url_videoColumn} text not null,
       ${VideoEntity.url_subtitleColumn} text,
       ${VideoEntity.filePathColumn} text DEFAULT '',
       ${VideoEntity.fileNameColumn} text DEFAULT '',
       ${VideoEntity.mimeTypeColumn} text,
       ${VideoEntity.ratingColumn} REAL)
     ''';
    return sql;
  }

  Future insert(VideoEntity video) async {
    Map<String, dynamic> map = video.toMap();
    map.update("timestamp_video_saved",
        (old) => DateTime.now().millisecondsSinceEpoch);

    await db!.insert(VideoEntity.TABLE_NAME, map);
  }

  Future<int> deleteVideoEntity(String? id) async {
    return db!.delete(VideoEntity.TABLE_NAME,
        where: "${VideoEntity.idColumn} = ?", whereArgs: [id]);
  }

  Future<Set<VideoEntity>> getAllDownloadedVideos() async {
    //Downloaded videos have a filename set when the download finished, otherwise they are current downloads
    List<Map>? result = await db?.query(
      VideoEntity.TABLE_NAME,
      columns: getColums(),
      where: "${VideoEntity.fileNameColumn} != ?",
      orderBy: "${VideoEntity.timestamp_video_savedColumn} DESC",
      whereArgs: [''],
    );
    if (result != null && result.isNotEmpty) {
      return result
          .map((raw) => VideoEntity.fromMap(raw as Map<String, dynamic>))
          .toSet();
    }
    return {};
  }

  /*
  Needs to have a task id assigned
   */
  Future<int> updateDownloadingVideoEntity(VideoEntity entity) async {
    return await db!.update(VideoEntity.TABLE_NAME, entity.toMap(),
        where: "${VideoEntity.task_idColumn} = ?", whereArgs: [entity.task_id]);
  }

  /*
  General Update on entity. eg to insert or update rating
   */
  Future<int> updateVideoEntity(VideoEntity entity) async {
    return await db!.update(VideoEntity.TABLE_NAME, entity.toMap(),
        where: "${VideoEntity.idColumn} = ?", whereArgs: [entity.id]);
  }

  Future<VideoEntity?> getVideoEntity(String? id) async {
    if (db == null || !db!.isOpen) {
      return null;
    }

    List<Map> maps = await db!.query(VideoEntity.TABLE_NAME,
        columns: getColums(),
        where: "${VideoEntity.idColumn} = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return VideoEntity.fromMap(maps.first as Map<String, dynamic>);
    }
    return null;
  }

  Future<VideoEntity?> getVideoEntityForTaskId(String? taskId) async {
    List<Map> maps = await db!.query(VideoEntity.TABLE_NAME,
        columns: getColums(),
        where: "${VideoEntity.task_idColumn} = ?",
        whereArgs: [taskId]);
    if (maps.isNotEmpty) {
      return VideoEntity.fromMap(maps.first as Map<String, dynamic>);
    }
    return null;
  }

  Future<Set<VideoEntity>> getVideoEntitiesForTaskIds(List<String> list) async {
    String whereClause = _getConcatinatedWhereClause(list);
    logger.fine("Build WHERE CLAUSE: $whereClause");
    List<Map> resultList = await db!.query(VideoEntity.TABLE_NAME,
        columns: getColums(), where: whereClause, whereArgs: list);
    if (list.length != resultList.length) {
      logger
          .severe("Download running that we do not have in the Video database");
    }
    if (resultList.isEmpty) {
      return {};
    }

    return resultList
        .map((result) => VideoEntity.fromMap(result as Map<String, dynamic>))
        .toSet();
  }

  String _getConcatinatedWhereClause(List<String> list) {
    String where = "";

    if (list.isEmpty) {
      return where;
    } else if (list.length == 1) {
      return "${VideoEntity.task_idColumn} = ? ";
    }

    for (int i = 0; i < list.length; i++) {
      if (i == list.length - 1) {
        where = "$where${VideoEntity.task_idColumn} = ?";
        break;
      }
      where = "$where${VideoEntity.task_idColumn} = ? OR ";
    }

    return where;
  }

  Future<VideoEntity?> getDownloadedVideo(String? id) async {
    if (db == null || !db!.isOpen) {
      return null;
    }

    List<Map> maps = await db!.query(VideoEntity.TABLE_NAME,
        columns: getColums(),
        where:
            "${VideoEntity.idColumn} = ? AND ${VideoEntity.fileNameColumn} != '' ",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return VideoEntity.fromMap(maps.first as Map<String, dynamic>);
    }
    return null;
  }

  List<String> getColums() {
    return [
      VideoEntity.idColumn,
      VideoEntity.task_idColumn,
      VideoEntity.channelColumn,
      VideoEntity.topicColumn,
      VideoEntity.descriptionColumn,
      VideoEntity.titleColumn,
      VideoEntity.timestampColumn,
      VideoEntity.timestamp_video_savedColumn,
      VideoEntity.durationColumn,
      VideoEntity.sizeColumn,
      VideoEntity.url_websiteColumn,
      VideoEntity.url_video_lowColumn,
      VideoEntity.url_video_hdColumn,
      VideoEntity.filmlisteTimestampColumn,
      VideoEntity.url_videoColumn,
      VideoEntity.filePathColumn,
      VideoEntity.fileNameColumn,
      VideoEntity.mimeTypeColumn,
      VideoEntity.ratingColumn
    ];
  }

  //&&&&&&&&&&&&&Favorite Channels &&&&&&&&&&&&&&&&&&&

  Future<Set<ChannelFavoriteEntity>> getAllChannelFavorites() async {
    List<Map> result =
        await db!.query(ChannelFavoriteEntity.TABLE_NAME, columns: [
      ChannelFavoriteEntity.nameColumn,
      ChannelFavoriteEntity.groupnameColumn,
      ChannelFavoriteEntity.logoColumn,
      ChannelFavoriteEntity.urlColumn
    ]);
    return result
        .map(
            (raw) => ChannelFavoriteEntity.fromMap(raw as Map<String, dynamic>))
        .toSet();
  }

  String getChannelFavoriteSQL() {
    var sql = '''create table ${ChannelFavoriteEntity.TABLE_NAME} ( 
       ${ChannelFavoriteEntity.nameColumn} text primary key, 
       ${ChannelFavoriteEntity.groupnameColumn} text not null,
       ${ChannelFavoriteEntity.logoColumn} text not null,
       ${ChannelFavoriteEntity.urlColumn} text not null)
     ''';
    return sql;
  }

  Future deleteChannelFavorite(String id) async {
    return await db!.delete(ChannelFavoriteEntity.TABLE_NAME,
        where: "${ChannelFavoriteEntity.nameColumn} = ?", whereArgs: [id]);
  }

  Future insertChannelFavorite(ChannelFavoriteEntity entity) async {
    await db!.insert(ChannelFavoriteEntity.TABLE_NAME, entity.toMap());
  }

  // &&&&&&&&&&&&&&&&&&&&   VIDEO PROGRESS  &&&&&&&&&&&&&&&&&&&&&&&
  String getProgressTableSQL() {
    var sql = '''        create table ${VideoProgressEntity.TABLE_NAME} ( 
       ${VideoProgressEntity.idColumn} text primary key, 
         ${VideoProgressEntity.progressColumn} integer,
       ${VideoProgressEntity.channelColumn} text not null,
       ${VideoProgressEntity.topicColumn} text not null,
       ${VideoProgressEntity.descriptionColumn} text,
       ${VideoProgressEntity.titleColumn} text not null,
       ${VideoProgressEntity.timestampColumn} integer,
       ${VideoProgressEntity.timestampLastViewedColumn} integer,
       ${VideoProgressEntity.durationColumn} text,
       ${VideoProgressEntity.sizeColumn} integer,
       ${VideoProgressEntity.url_websiteColumn} text,
       ${VideoProgressEntity.url_video_lowColumn} text,
       ${VideoProgressEntity.url_video_hdColumn} text,
       ${VideoProgressEntity.filmlisteTimestampColumn} text,
       ${VideoProgressEntity.url_videoColumn} text not null,
       ${VideoProgressEntity.url_subtitleColumn} text)
     ''';
    return sql;
  }

  Future<int> insertVideoProgress(VideoProgressEntity entity) async {
    entity.timestampLastViewed = DateTime.now().millisecondsSinceEpoch;
    Map<String, dynamic> map = entity.toMap();
    assert(db != null);
    return await db!.insert(VideoProgressEntity.TABLE_NAME, map);
  }

  Future<int> deleteVideoProgressEntity(String id) async {
    return db!.delete(VideoProgressEntity.TABLE_NAME,
        where: "${VideoProgressEntity.idColumn} = ?", whereArgs: [id]);
  }

  Future<int> updateVideoProgressEntity(VideoProgressEntity entity) async {
    entity.timestampLastViewed = DateTime.now().millisecondsSinceEpoch;
    return await db!.update(
        VideoProgressEntity.TABLE_NAME,
        {
          'progress': entity.progress,
          'timestampLastViewed': entity.timestampLastViewed
        },
        where: "${VideoProgressEntity.idColumn} = ?",
        whereArgs: [entity.id]);
  }

  Future<VideoProgressEntity?> getVideoProgressEntity(String? id) async {
    if (db == null || !db!.isOpen) {
      return null;
    }

    List<Map> maps = await db!.query(VideoProgressEntity.TABLE_NAME,
        columns: getVideoProgressColumns(),
        where: "${VideoProgressEntity.idColumn} = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return VideoProgressEntity.fromMap(maps.first as Map<String, dynamic>);
    }
    return null;
  }

  List<String> getVideoProgressColumns() {
    return [
      VideoProgressEntity.idColumn,
      VideoProgressEntity.progressColumn,
      VideoProgressEntity.channelColumn,
      VideoProgressEntity.topicColumn,
      VideoProgressEntity.descriptionColumn,
      VideoProgressEntity.titleColumn,
      VideoProgressEntity.timestampColumn,
      VideoProgressEntity.timestampLastViewedColumn,
      VideoProgressEntity.durationColumn,
      VideoProgressEntity.sizeColumn,
      VideoProgressEntity.url_websiteColumn,
      VideoProgressEntity.url_video_lowColumn,
      VideoProgressEntity.url_video_hdColumn,
      VideoProgressEntity.filmlisteTimestampColumn,
      VideoProgressEntity.url_videoColumn,
    ];
  }

  Future<Set<VideoProgressEntity>?> getLastViewedVideos(int amount) async {
    if (db == null || !db!.isOpen) {
      return null;
    }
    List<Map> result = await db!.query(VideoProgressEntity.TABLE_NAME,
        orderBy: "${VideoProgressEntity.timestampLastViewedColumn} DESC",
        columns: getVideoProgressColumns(),
        limit: amount);
    return result
        .map((raw) => VideoProgressEntity.fromMap(raw as Map<String, dynamic>))
        .toSet();
  }

  Future<Set<VideoProgressEntity>?> getAllLastViewedVideos() async {
    if (db == null || !db!.isOpen) {
      return null;
    }
    List<Map> result = await db!.query(VideoProgressEntity.TABLE_NAME,
        orderBy: "${VideoProgressEntity.timestampLastViewedColumn} DESC",
        columns: getVideoProgressColumns());
    return result
        .map((raw) => VideoProgressEntity.fromMap(raw as Map<String, dynamic>))
        .toSet();
  }

  void updatePlaybackPosition(Video video, int position) {
    getVideoProgressEntity(video.id).then((entity) {
      if (entity == null) {
        // initial insert into database
        _insertPlaybackPosition(video, position);
      } else {
        _updateProgress(video.id, position);
      }
    });
  }

  // initial insert into database containing all the video information
  void _insertPlaybackPosition(Video video, int position) {
    // get entity from video
    VideoProgressEntity videoProgress =
        VideoProgressEntity.fromMap(video.toMap());

    videoProgress.progress = position;
    insertVideoProgress(videoProgress).then((value) {
      logger
          .info("Successfully inserted progress entity for video ${video.id}");
    }, onError: (err, stackTrace) {
      logger.warning("Could not insert video progress $stackTrace");
    });
  }

  void _updateProgress(String? videoId, int position) {
    updateVideoProgressEntity(VideoProgressEntity(videoId, position)).then(
        (rowsUpdated) {
      if (rowsUpdated < 1) {
        logger.warning("Could not update video progress. Rows Updated < 1");
      }
    }, onError: (err, stackTrace) {
      logger.warning("Could not update video progress $stackTrace");
    });
  }
}
