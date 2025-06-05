import 'package:flutter/cupertino.dart';
import 'package:flutter_ws/database/video_entity.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
import 'package:flutter_ws/model/video.dart';

class VideoUtil {
  static String? getVideoPath(
      AppState appWideState, VideoEntity? videoEntity, Video video) {
    if (videoEntity != null) {
      if (appWideState.targetPlatform == TargetPlatform.android) {
        return "${videoEntity.filePath!}/${videoEntity.fileName!}";
      } else {
        return "${appWideState.localDirectory!.path}/MediathekView/${videoEntity.fileName!}";
      }
    } else {
      return video.url_video?.toString();
    }
  }

  static bool isLivestreamVideo(Video video) {
    return video.url_video?.pathSegments.last.endsWith(".m3u8") ?? false;
  }
}
