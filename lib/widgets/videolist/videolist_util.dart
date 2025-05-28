import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/widgets/filterMenu/search_filter.dart';
import 'package:flutter_ws/widgets/filterMenu/video_length_slider.dart';
import 'package:logging/logging.dart';

class VideoListUtil {
  static final Logger logger = Logger('VideoListUtil');

  /*
  Sanitizes:
  - Checks for duplicates in the current video list to not add the same video twice.
    Duplicate is defined either by Video_ID identity or if the title and the duration is the same.
    This prevents the same video being uploaded by multiple vendors to appear twice. -> client side filtering
  - Some CDN'S need https instead of http
   */
  static List<Video> sanitizeVideos(
      List<Video> newVideos, List<Video> currentVideos) {
    if (currentVideos.isEmpty) {
      List<Video> videos =
          newVideos.map((video) => httpUrlToHttps(video)).toList();
      return videos;
    }

    for (int i = 0; i < newVideos.length; i++) {
      Video currentVideo = newVideos[i];

      logger.info("Video ID : ${currentVideo.id!} URL: ${currentVideo.url_video!} Duration: ${currentVideo.duration} Size: ${currentVideo.size}");
      bool hasDuplicate =
          _hasDuplicate(i, newVideos, currentVideos, currentVideo);
      if (hasDuplicate == false) {
        currentVideos.add(httpUrlToHttps(currentVideo));
      }
    }
    return currentVideos;
  }

  static bool _hasDuplicate(int i, List<Video> newVideos,
      List<Video> currentVideos, Video currentVideo) {
    bool hasDuplicate = false;
    for (int b = i + 1; b < newVideos.length + currentVideos.length; b++) {
      Video video;

      if (b > newVideos.length - 1) {
        int index = b - newVideos.length;
        video = currentVideos[index];
      } else {
        video = newVideos[b];
      }
      if (video.id == currentVideo.id ||
          video.title == currentVideo.title &&
              video.duration == currentVideo.duration) {
        hasDuplicate = true;
        break;
      }
    }
    return hasDuplicate;
  }

  static Video httpUrlToHttps(Video video) {
    if (video.url_video!.startsWith('http://srfvodhd-vh.akamaihd.net') ||
        video.url_video!.startsWith('http://hdvodsrforigin-f.akamaihd.net')) {
      video.url_video = 'https${video.url_video!.substring(4)}';
    }
    return video;
  }

  static List<Video> applyLengthFilter(
      List<Video> videos, SearchFilter searchFilter) {
    List<String> split = searchFilter.filterValue.split("-");
    double minLength = double.parse(split.elementAt(0));
    double maxLength = double.parse(split.elementAt(1));

    bool discardMaxLength = false;
    if (maxLength == VideoLengthSlider.MAXIMUM_FILTER_LENGTH) {
      discardMaxLength = true;
    }

    int videoLengthBeforeRemoval = videos.length;
    videos.removeWhere((video) {
      if (video.duration == null || video.duration.toString().isEmpty) {
        return false;
      }
      int sekunden = int.parse(video.duration.toString());
      int videoLengthInMinutes = (sekunden / 60).floor();

      if (discardMaxLength) {
        return videoLengthInMinutes < minLength;
      }

      return videoLengthInMinutes < minLength ||
          videoLengthInMinutes > maxLength;
    });
    int diff = videoLengthBeforeRemoval - videos.length;
    logger.info(
        "Removed $diff videos due to length constraints");
    return videos;
  }
}
