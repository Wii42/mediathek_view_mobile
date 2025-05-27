import 'package:flutter/material.dart';
import 'package:flutter_ws/database/database_manager.dart';
import 'package:flutter_ws/database/video_entity.dart';
import 'package:flutter_ws/database/video_progress_entity.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/util/video.dart';
import 'package:flutter_ws/widgets/videolist/video_widget.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class VideoPreviewAdapter extends StatefulWidget {
  final Logger logger = Logger('VideoPreviewAdapter');
  final Video video;
  final String? defaultImageAssetPath;
  bool previewNotDownloadedVideos;
  bool isVisible;
  bool openDetailPage;

  // if width not set, set to full width
  Size? size;

  // force to this specific aspect ratio
  double? presetAspectRatio;
  Image? previewImage;

  VideoPreviewAdapter(
    // always hand over video. Download section needs to convert to video.
    // Needs to made uniform to be easier
    this.video,
    this.previewNotDownloadedVideos,
    this.isVisible,
    this.openDetailPage, {
    this.defaultImageAssetPath,
    this.size,
    this.presetAspectRatio,
  });

  @override
  State<VideoPreviewAdapter> createState() => _VideoPreviewAdapterState();
}

class _VideoPreviewAdapterState extends State<VideoPreviewAdapter> {
  VideoEntity? videoEntity;
  VideoProgressEntity? videoProgressEntity;
  bool isCurrentlyDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppState, VideoListState>(
      builder: (context, appState, videoListState, _) {
        Uuid uuid = Uuid();

        if (!widget.isVisible) {
          return Container();
        }

        if (videoListState.previewImages
                .containsKey(widget.video.id)) {
          widget.logger.info(
              "Getting preview image from memory for: ${widget.video.title!}");
          widget.previewImage =
              videoListState.previewImages[widget.video.id];
        }

        if (widget.previewImage != null) {
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

        if (widget.previewImage == null) {
          appState.videoPreviewManager
              .getImagePreview(widget.video.id!, videoListState)
              .then((image) {
            if (image != null) {
              widget.logger
                  .info("Thumbnail found  for video: ${widget.video.title!}");
              widget.previewImage = image;
              if (mounted) {
                setState(() {});
              }
              return;
            }
            // request preview
            requestPreview(context, appState, videoListState);
          });
        }

        if (widget.size == null) {
          widget.size = MediaQuery.of(context).size;
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
                previewImage: widget.previewImage,
                defaultImageAssetPath: widget.defaultImageAssetPath,
                size: widget.size,
                presetAspectRatio: widget.presetAspectRatio,
              ),
            )
          ],
        );
      },
    );
  }

  void requestPreview(BuildContext context, AppState appState, VideoListState videoListState) {
    appState.databaseManager
        .getDownloadedVideo(widget.video.id)
        .then((entity) {
      if (entity == null && !widget.previewNotDownloadedVideos) {
        return;
      }
      requestThumbnailPicture(context, entity, widget.video, appState, videoListState);
    });
  }

  void requestThumbnailPicture(
      BuildContext context, VideoEntity? entity, Video video, AppState appState, VideoListState videoListState) {
    String? url = VideoUtil.getVideoPath(appState, entity, video);

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
      widget.previewImage = image;
      if (mounted) {
        setState(() {});
      }
    });
  }
}
