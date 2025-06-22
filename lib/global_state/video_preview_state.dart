import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../drift_database/app_database.dart';
import '../model/video.dart';
import '../platform_channels/video_preview_manager.dart';
import '../util/video.dart';

class VideoPreviewState extends ChangeNotifier {
  final Logger logger = Logger('VideoListState');
  final VideoPreviewManager _videoPreviewManager;
  final TargetPlatform? targetPlatform;

  final Map<String, Image> _previewImages;

  /// Map to keep track of the last request time for each video.
  /// Key is the hash of the Video and VideoEntity used to request the thumbnail.
  final Map<int, DateTime> _lastPreviewRequest = {};

  /// Duration to wait before allowing another thumbnail-generation request for the same video.
  static const Duration cooldownDuration = Duration(minutes: 5);

  VideoPreviewState(
      {Map<String, Image> previewImages = const {},
      required Directory? localDirectory,
      required this.targetPlatform})
      : _previewImages = {...previewImages},
        _videoPreviewManager = VideoPreviewManager(localDirectory);

  void addImagePreview(String videoId, Image preview) {
    logger.fine("Adding preview image to state for video with id $videoId");
    _previewImages[videoId] = preview;
    notifyListeners();
  }

  /// Retrieves the preview image for a video by its ID.
  ///
  /// If [createIfNotExists] is true, it will attempt to create the preview image.
  /// Then [video] and [entity] are used to request the thumbnail.
  /// [video] must not be null in this case.
  Image? getPreviewImage(String videoId,
      {bool createIfNotExists = false, Video? video, VideoEntity? entity}) {
    Image? cachedImage = _previewImages[videoId];
    if (cachedImage != null) {
      return cachedImage;
    } else {
      _loadImagePreviewAsync(videoId,
          createIfNotExists: createIfNotExists, video: video, entity: entity);
      return null;
    }
  }

  Future<void> _loadImagePreviewAsync(String videoId,
      {bool createIfNotExists = true,
      Video? video,
      VideoEntity? entity}) async {
    Image? image = await _videoPreviewManager.getImagePreview(videoId);
    if (image != null) {
      logger.info("Thumbnail found  for video: ${video?.title ?? videoId}");
      addImagePreview(videoId, image);
    }
    // request preview
    if (createIfNotExists) {
      assert(video != null,
          "Video must not be null when requesting thumbnail picture.");
      int hash = _hashVideoAndEntity(video, entity);
      if (_lastPreviewRequest.containsKey(hash)) {
        DateTime lastRequest = _lastPreviewRequest[hash]!;
        if (DateTime.now().difference(lastRequest) < cooldownDuration) {
          logger.info(
              "Thumbnail request for video: ${video?.title ?? videoId} is too recent. Skipping request.");
          return;
        }
      }
      _lastPreviewRequest[hash] = DateTime.now();
      Image? generatedImage = await requestThumbnailPicture(entity, video!);
      if (generatedImage != null) {
        logger.info("Thumbnail generated for video: ${video.title ?? videoId}");
        addImagePreview(videoId, generatedImage);
      } else {
        logger.warning(
            "No thumbnail generated for video: ${video.title ?? videoId}. No image available.");
      }
    }
  }

  Future<Image?> requestThumbnailPicture(VideoEntity? entity, Video video) {
    String? url = VideoUtil.getVideoPath(
        videoEntity: entity,
        video: video,
        localDirectory: _videoPreviewManager.localDirectory,
        targetPlatform: targetPlatform);
    if (url == null) {
      logger.warning(
          "No URL found for video: ${video.title}. Cannot request preview.");
      return Future.value(null);
    }
    if (video.id == null) {
      logger.warning(
          "No video ID found for video: ${video.title}. Cannot request preview.");
      return Future.value(null);
    }
    return _videoPreviewManager.generatePreview(video.id!, Uri.parse(url),
        title: video.title);
  }

  int _hashVideoAndEntity(Video? video, VideoEntity? entity) {
    return Object.hash(video, entity);
  }
}
