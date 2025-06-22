import 'dart:async';
import 'dart:io' as io;
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

typedef TriggerStateReloadOnPreviewReceived = void Function(String? trigger);

class VideoPreviewManager {
  final Logger logger = Logger('VideoPreviewManager');
  final io.Directory? localDirectory;

  //Map<String, bool> requestedVideoPreview = new Map();
  // Maps a video id to a function that reloads the state of the widget that requested the preview
  // THis is needed because, although a video id is unique, there can be multiple widgets requesting previews for the same video id
  // this is the case when the user just watched the video (visible in recently viewed) and also downloads it at the same time
  // the preview should not be requested twice & when the preview is received, both widget should be updated with the preview
  //Map<String?, List<TriggerStateReloadOnPreviewReceived>>
  //videoIdToPreviewReceived = {};

  /// Set of video ids for which a preview is currently being generated.
  ///
  /// Needed so that we can avoid generating the same preview multiple times.
  Set<String> videosWaitingForPreview = {};

  VideoPreviewManager(this.localDirectory);

  Future<Image?> getImagePreview(String videoId) async {
    if (localDirectory == null) {
      logger.severe("No local directory set. Cannot get preview for $videoId");
      return null;
    }
    String thumbnailPath = getThumbnailPath(localDirectory!, videoId);

    var file = io.File(thumbnailPath);
    if (!await file.exists()) {
      return null;
    }

    return Image.file(file, fit: BoxFit.cover);
  }

  Future<Image?> generatePreview(String videoId, Uri url,
      {String? title}) async {
    if (videosWaitingForPreview.contains(videoId)) {
      logger.info("Preview requested again for $videoId. Ignored.");
      return null;
    }

    videosWaitingForPreview.add(videoId);
    logger.info("Request preview for: $title");
    Image? img = await _generatePreview(videoId, url, title: title);
    videosWaitingForPreview.remove(videoId);
    return img;
  }

  Future<Image?> _generatePreview(String videoId, Uri url,
      {String? title}) async {
    io.Directory? directory = localDirectory;

    String? thumbnailPath;
    if (directory != null) {
      thumbnailPath = getThumbnailPath(directory, videoId);

      if (await io.File(thumbnailPath).exists()) {
        return getImagePreview(videoId);
      }
    } else {
      logger.severe("No local directory set. Cannot save thumbnail for $title");
    }

    if (url.toString().endsWith(".m3u8")) {
      Uri? tsUrl = await _getPreviewUrlFromM3U8Video(url);
      if (tsUrl != null) {
        url = tsUrl;
      } else {
        return null;
      }
    }

    Uint8List? rawImageData;

    try {
      rawImageData = await VideoThumbnail.thumbnailData(
        video: url.toString(),
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

    if (rawImageData == null) {
      logger.severe("Create preview failed. No preview data returned");
      return null;
    }

    logger.info("Received image for $url with size: ${rawImageData.length}");
    if (thumbnailPath != null) {
      io.File(thumbnailPath).writeAsBytes(rawImageData).then(
          (file) => logger.info("Wrote preview file to ${file.path}"),
          onError: (error, stacktrace) => logger.warning(
              "Failed to persist preview file $error.\nStacktrace: $stacktrace"));
    }

    return await _createImage(rawImageData);
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
