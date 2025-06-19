import 'package:flutter/material.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/util/video.dart';
import 'package:flutter_ws/widgets/videolist/video_widget.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../drift_database/app_database.dart';

class VideoPreviewAdapter extends StatefulWidget {
  final Logger logger = Logger('VideoPreviewAdapter');
  final Video video;
  final String? defaultImageAssetPath;
  final bool previewNotDownloadedVideos;
  final bool isVisible;
  final bool openDetailPage;
  final List<Widget> overlayWidgets;
  final double? width;

  // if width not set, set to full width
  final Size? size;

  // force to this specific aspect ratio
  final double? presetAspectRatio;

  VideoPreviewAdapter(
    // always hand over video. Download section needs to convert to video.
    // Needs to made uniform to be easier
    this.video, {
    required this.previewNotDownloadedVideos,
    required this.isVisible,
    required this.openDetailPage,
    super.key,
    this.defaultImageAssetPath,
    this.size,
    this.presetAspectRatio,
    this.width,
    this.overlayWidgets = const [],
  });

  @override
  State<VideoPreviewAdapter> createState() => _VideoPreviewAdapterState();
}

class _VideoPreviewAdapterState extends State<VideoPreviewAdapter> {
  VideoEntity? videoEntity;
  VideoProgressEntity? videoProgressEntity;
  bool isCurrentlyDownloading = false;
  Image? previewImage;

  Size get size {
    if (widget.size != null) {
      return widget.size!;
    }
    return MediaQuery.of(context).size;
  }

  final Uuid uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return Container();
    }

    return Consumer2<AppState, VideoListState>(
      builder: (context, appState, videoListState, _) {
        if (videoListState.previewImages.containsKey(widget.video.id)) {
          widget.logger.info(
              "Getting preview image from memory for: ${widget.video.title!}");
          previewImage = videoListState.previewImages[widget.video.id];
        }

        if (previewImage != null) {
          widget.logger
              .info("Preview for video is set: ${widget.video.title!}");
        } else {
          widget.logger
              .info("Preview for video is NOT set: ${widget.video.title!}");
        }

        // check if video is currently downloading
        appState.downloadManager
            .isCurrentlyDownloading(widget.video.id)
            .then((value) {
          if (value != null) {
            if (isCurrentlyDownloading) {
              widget.logger
                  .info("Video is downloading:  ${widget.video.title!}");
              isCurrentlyDownloading = true;
              if (mounted) {
                setState(() {});
              }
            }
          }
        });

        if (previewImage == null) {
          appState.videoPreviewManager
              .getImagePreview(widget.video.id!, videoListState)
              .then((image) {
            if (image != null) {
              widget.logger
                  .info("Thumbnail found  for video: ${widget.video.title!}");
              previewImage = image;
              if (mounted) {
                setState(() {});
              }
              return;
            }
            // request preview
            requestPreview(appState, videoListState);
          });
        }

        return Column(
          key: Key(uuid.v1()),
          children: <Widget>[
            Container(
              key: Key(uuid.v1()),
              child: VideoWidget(
                appState,
                widget.video,
                isCurrentlyDownloading,
                widget.openDetailPage,
                previewImage: previewImage,
                defaultImageAssetPath: widget.defaultImageAssetPath,
                size: size,
                presetAspectRatio: widget.presetAspectRatio,
                overlayWidgets: widget.overlayWidgets,
              ),
            ),
          ],
        );
      },
    );
  }

  void requestPreview(AppState appState, VideoListState videoListState) {
    appState.databaseManager.getDownloadedVideo(widget.video.id).then((entity) {
      if (entity == null && !widget.previewNotDownloadedVideos) {
        return;
      }
      requestThumbnailPicture(entity, widget.video, appState, videoListState);
    });
  }

  void requestThumbnailPicture(VideoEntity? entity, Video video,
      AppState appState, VideoListState videoListState) {
    String? url = VideoUtil.getVideoPath(appState, entity, video);
    if (url == null) {
      widget.logger.warning(
          "No URL found for video: ${video.title!}. Cannot request preview.");
      return;
    }
    appState.videoPreviewManager.startPreviewGeneration(
        videoListState,
        widget.video.id,
        widget.video.title,
        url,
        triggerStateReloadOnPreviewReceived);
  }

  void triggerStateReloadOnPreviewReceived(String? filepath) {
    if (filepath == null) {
      return;
    }
    AppState appState = Provider.of<AppState>(context, listen: false);
    VideoListState videoListState =
        Provider.of<VideoListState>(context, listen: false);
    widget.logger.info("Preview received for video: ${widget.video.title!}");
    // get preview from file
    appState.videoPreviewManager
        .getImagePreview(widget.video.id!, videoListState)
        .then((image) {
      previewImage = image;
      if (mounted) {
        setState(() {});
      }
    });
  }
}
