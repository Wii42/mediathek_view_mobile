import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
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

  Future<Image?> getImagePreview(String videoId, VideoListState videoListState) async {
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
      String? url,
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
      videoIdToPreviewReceived[videoId]!.forEach((triggerReload) {
        triggerReload(filepath);
      });
      videoIdToPreviewReceived.remove(videoId);
    });
  }

  Future<String?> _createAndPersistThumbnail(String videoId, String? url, VideoListState videoListState) async {
    Uint8List? uint8list;

    io.Directory? directory = _appWideState.localDirectory;

    String? thumbnailPath;
    if (directory != null){
      thumbnailPath = getThumbnailPath(directory, videoId);

      if (await io.File(thumbnailPath).exists()) {
        return thumbnailPath;
      }
    }else {
      logger.severe("No local directory set. Cannot create thumbnail for $videoId");
    }

    try {
      uint8list = await VideoThumbnail.thumbnailData(
        video: url!,
        imageFormat: ImageFormat.JPEG,
        quality: 10,
      );
    } on PlatformException catch (e) {
      logger.severe("Create preview failed. Reason $e");
      return null;
    } on MissingPluginException catch (e) {
      logger.severe("Creating preview failed faile for: ${url!}. Missing Plugin: $e");
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
          logger
              .warning("Failed to persist preview file $error"))
          .then((file) => logger.info("Wrote preview file to ${file.path}"));
    }

    Image image = await _createImage(uint8list);
    videoListState.addImagePreview(videoId, image);
    return thumbnailPath;
  }

  String getThumbnailPath(io.Directory directory, String videoId) {
    String thumbnailPath = "${directory.path}/MediathekView/thumbnails/${sanitizeVideoId(videoId)}.jpeg";
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
}
