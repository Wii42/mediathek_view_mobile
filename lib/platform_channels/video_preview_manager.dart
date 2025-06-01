import 'dart:async';
import 'dart:io' as io;
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

typedef TriggerStateReloadOnPreviewReceived = void Function(String? trigger);

class VideoPreviewManager {
  final Logger logger = Logger('VideoPreviewManager');
  late final AppState _appWideState;

  //Map<String, bool> requestedVideoPreview = new Map();
  // Maps a video id to a function that reloads the state of the widget that requested the preview
  // THis is needed because, although a video id is unique, there can be multiple widgets requesting previews for the same video id
  // this is the case when the user just watched the video (visible in recently viewed) and also downloads it at the same time
  // the preview should not be requested twice & when the preview is received, both widget should be updated with the preview
  Map<String?, List<TriggerStateReloadOnPreviewReceived>>
      videoIdToPreviewReceived = {};

  VideoPreviewManager();

  set appWideState(AppState appWideState) {
    _appWideState = appWideState;
  }

  Future<Image?> getImagePreview(
      String videoId, VideoListState videoListState) async {
    String thumbnailPath =
        getThumbnailPath(_appWideState.localDirectory!, videoId);

    var file = io.File(thumbnailPath);
    if (!await file.exists()) {
      return null;
    }

    var image = Image.file(file, fit: BoxFit.cover);
    videoListState.addImagePreview(videoId, image);

    return image;
  }

  void startPreviewGeneration(
      VideoListState videoListState,
      String? videoId,
      String? title,
      String url,
      TriggerStateReloadOnPreviewReceived triggerStateReload) async {
    if (videoListState.previewImages.containsKey(videoId)) {
      return null;
    }

    if (videoIdToPreviewReceived.containsKey(videoId)) {
      logger.info("Preview requested again for ${title!}");
      videoIdToPreviewReceived.update(videoId, (value) {
        List<TriggerStateReloadOnPreviewReceived> list =
            videoIdToPreviewReceived[videoId]!;
        list.add(triggerStateReload);
        return list;
      });
      return;
    }

    videoIdToPreviewReceived.putIfAbsent(videoId, () {
      List<TriggerStateReloadOnPreviewReceived> list = [];
      list.add(triggerStateReload);
      return list;
    });

    logger.info("Request preview for: ${title!}");
    _createAndPersistThumbnail(videoId!, url, videoListState).then((filepath) {
      // update each widget that waited for the preview
      for (var triggerReload in videoIdToPreviewReceived[videoId]!) {
        triggerReload(filepath);
      }
      videoIdToPreviewReceived.remove(videoId);
    });
  }

  Future<String?> _createAndPersistThumbnail(
      String videoId, String url, VideoListState videoListState) async {
    Uint8List? uint8list;

    io.Directory? directory = _appWideState.localDirectory;

    String? thumbnailPath;
    if (directory != null) {
      thumbnailPath = getThumbnailPath(directory, videoId);

      if (await io.File(thumbnailPath).exists()) {
        return thumbnailPath;
      }
    } else {
      logger.severe(
          "No local directory set. Cannot create thumbnail for $videoId");
    }

    if (url.endsWith(".m3u8")) {
      Uri m3u8Url = Uri.parse(url);
      Uri? tsUrl = await _getPreviewUrlFromM3U8Video(m3u8Url);
      if (tsUrl != null) {
        url = tsUrl.toString();
      } else {
        return null;
      }
    }

    try {
      uint8list = await VideoThumbnail.thumbnailData(
        video: url,
        imageFormat: ImageFormat.JPEG,
        quality: 10,
      );
    } on PlatformException catch (e) {
      logger.severe("Create preview failed. Reason $e");
      return null;
    } on MissingPluginException catch (e) {
      logger.severe(
          "Creating preview failed faile for: $url. Missing Plugin: $e");
      return null;
    }

    if (uint8list == null) {
      logger.severe("Create preview failed. No preview data returned");
      return null;
    }

    logger.info("Received image for $url with size: ${uint8list.length}");
    if (thumbnailPath != null) {
      io.File(thumbnailPath)
          .writeAsBytes(uint8list)
          .catchError((error) =>
              logger.warning("Failed to persist preview file $error"))
          .then((file) => logger.info("Wrote preview file to ${file.path}"));
    }

    Image image = await _createImage(uint8list);
    videoListState.addImagePreview(videoId, image);
    return thumbnailPath;
  }

  String getThumbnailPath(io.Directory directory, String videoId) {
    String thumbnailPath =
        "${directory.path}/MediathekView/thumbnails/${sanitizeVideoId(videoId)}.jpeg";
    return thumbnailPath;
  }

  String sanitizeVideoId(String videoId) {
    return videoId.replaceAll('/', '');
  }

  Future<Image> _createImage(Uint8List pictureRaw) async {
    final Codec codec = await instantiateImageCodec(pictureRaw);
    final FrameInfo frameInfo = await codec.getNextFrame();
    int height = frameInfo.image.height;
    int width = frameInfo.image.width;

    return Image.memory(pictureRaw,
        fit: BoxFit.cover, height: height.toDouble(), width: width.toDouble());
  }

  Uri _buildTsUrl(Uri m3u8Url, String tsFragment) {
    List<String> pathSegments = List.from(m3u8Url.pathSegments);
    pathSegments.removeLast();
    pathSegments.add(tsFragment);
    return m3u8Url.replace(pathSegments: pathSegments);
  }

  Future<Uri?> _getPreviewUrlFromM3U8Video(Uri m3u8Url) async {
    final response = await http.get(m3u8Url);
    if (response.statusCode != 200) {
      logger.severe(
          "Failed to fetch M3U8 file from $m3u8Url. Status code: ${response.statusCode}, body: ${response.body}");
      return null;
    }
    String? tsFragment = response.body
        .split("\n")
        .map((line) => line.trim())
        .firstWhereOrNull((line) => line.endsWith(".ts"));
    if (tsFragment != null) {
      Uri tsUrl = _buildTsUrl(m3u8Url, tsFragment);
      return tsUrl;
    } else {
      return _tryGetThumbnailFromM3u8MasterPlaylist(response, m3u8Url);
    }
  }

  Future<Uri?>? _tryGetThumbnailFromM3u8MasterPlaylist(
      http.Response response, Uri m3u8Url) {
    // find #EXT-X-STREAM-INF tag, and extract associated attributes and url
    RegExp r = RegExp(r'#EXT-X-STREAM-INF:(.*)\n(.*)\n', multiLine: true);
    Iterable<RegExpMatch> matches = r.allMatches(response.body);
    if (matches.isEmpty) {
      logger.severe(
          "No .ts fragment found and in M3U8 file (and file is not master playlist) at $m3u8Url. Cannot create thumbnail.");
      return null;
    }
    String? urlFragment =
        matches.map((match) => match.group(2)).firstWhereOrNull((url) {
      return (url != null && url.endsWith(".m3u8"));
    });
    if (urlFragment != null) {
      Uri playlistUrl = _buildTsUrl(m3u8Url, urlFragment);
      return _getPreviewUrlFromM3U8Video(playlistUrl);
    } else {
      logger.severe(
          "No playlist found in M3U8 master playlist at $m3u8Url. Cannot create thumbnail.");
      return null;
    }
  }
}
