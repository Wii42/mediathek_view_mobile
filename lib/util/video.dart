import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ws/model/video.dart';

import '../drift_database/app_database.dart' show VideoEntity;

class VideoUtil {
  static String? getVideoPath(
      {required VideoEntity? videoEntity,
      required Video video,
      required Directory? localDirectory,
      required TargetPlatform? targetPlatform}) {
    if (videoEntity != null && videoEntity.filePath != null) {
      if (targetPlatform == TargetPlatform.android) {
        return "${videoEntity.filePath!}/${videoEntity.fileName!}";
      } else {
        return "${localDirectory!.path}/MediathekView/${videoEntity.fileName!}";
      }
    } else {
      return video.url_video?.toString();
    }
  }

  static bool isLivestreamVideo(Video video) {
    return video.url_video?.pathSegments.last.endsWith(".m3u8") ?? false;
  }
}
