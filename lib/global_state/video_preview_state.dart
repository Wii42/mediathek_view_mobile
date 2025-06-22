import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class VideoPreviewState extends ChangeNotifier {
  final Logger logger = Logger('VideoListState');

  final Map<String, Image> _previewImages;

  VideoPreviewState({Map<String, Image> previewImages = const {}})
      : _previewImages = {...previewImages};

  Map<String, Image> get previewImages => Map.unmodifiable(_previewImages);

  void addImagePreview(String videoId, Image preview) {
    logger.fine("Adding preview image to state for video with id $videoId");
    _previewImages.putIfAbsent(videoId, () => preview);
    notifyListeners();
  }
}
