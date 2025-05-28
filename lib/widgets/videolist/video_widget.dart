import 'package:flutter/material.dart';
import 'package:flutter_ws/database/video_entity.dart';
import 'package:flutter_ws/database/video_progress_entity.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/widgets/bars/playback_progress_bar.dart';
import 'package:flutter_ws/widgets/videolist/download/download_progress_bar.dart';
import 'package:flutter_ws/widgets/videolist/util/util.dart';
import 'package:flutter_ws/widgets/videolist/video_detail_screen.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

import 'meta_info_list_tile.dart';

class VideoWidget extends StatefulWidget {
  final Logger logger = Logger('VideoWidget');
  final AppState appWideState;
  final Video video;
  final String? mimeType;
  final String? defaultImageAssetPath;
  final Image? previewImage;
  final Size? size;
  final double? presetAspectRatio;

  final bool isDownloading;
  final bool openDetailPage;

  VideoWidget(
    this.appWideState,
    this.video,
    this.isDownloading,
    this.openDetailPage, {
    super.key,
    this.previewImage,
    this.mimeType,
    this.defaultImageAssetPath,
    this.size,
    this.presetAspectRatio,
  });

  @override
  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  String? heroUuid;
  VideoProgressEntity? videoProgressEntity;
  VideoEntity? entity;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    heroUuid = Uuid().v1().toString();
    checkPlaybackProgress();
    checkIfAlreadyDownloaded();
  }

  @override
  Widget build(BuildContext context) {
    widget.logger.fine("Rendering Image for ${widget.video.id!}");

    //Always fill full width & calc height accordingly
    double totalWidth =
        widget.size!.width - 36.0; //Intendation: 28 left, 8 right
    double height = calculateImageHeight(
        widget.previewImage, totalWidth, widget.presetAspectRatio);

    Widget downloadProgressBar = DownloadProgressBar(
      videoId: widget.video.id,
      videoTitle: widget.video.title,
      downloadManager: widget.appWideState.downloadManager,
      isOnDetailScreen: false,
      triggerParentStateReload: checkIfAlreadyDownloaded,
    );

    Image placeholderImage = Image.asset(
        'assets/img/${widget.defaultImageAssetPath!}',
        width: totalWidth,
        height: height,
        alignment: Alignment.center,
        gaplessPlayback: true);

    Hero previewImage;
    if (widget.previewImage != null) {
      widget.logger.fine("Showing preview image for ${widget.video.title!}");
      previewImage = Hero(tag: heroUuid!, child: widget.previewImage!);
    } else {
      widget.logger.fine("Showing placeholder for ${widget.video.title!}");
      previewImage = Hero(tag: heroUuid!, child: placeholderImage);
    }

    return GestureDetector(
      child: AspectRatio(
        aspectRatio:
            totalWidth > height ? totalWidth / height : height / totalWidth,
        child: SizedBox(
          width: totalWidth,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: <Widget>[
              AnimatedOpacity(
                opacity: widget.previewImage == null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 750),
                curve: Curves.easeInOut,
                child: previewImage,
              ),
              AnimatedOpacity(
                opacity: widget.previewImage != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 750),
                curve: Curves.easeInOut,
                child: widget.previewImage,
              ),
              //Overlay Banner
              Positioned(
                bottom: 0,
                left: 0.0,
                right: 0.0,
                child: Opacity(
                  opacity: 0.7,
                  child: getBottomBar(
                      context,
                      videoProgressEntity,
                      widget.video.id,
                      widget.video.duration.toString(),
                      widget.video.title!,
                      widget.video.timestamp,
                      widget.defaultImageAssetPath!),
                ),
              ),
              Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: downloadProgressBar)
            ],
          ),
        ),
      ),
      onTap: () async {
        if (widget.openDetailPage) {
          widget.logger.info("Open detail page");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) {
                    return VideoDetailScreen(
                      widget.previewImage ?? placeholderImage,
                      widget.video,
                      entity,
                      widget.isDownloading,
                      entity != null,
                      heroUuid,
                      widget.defaultImageAssetPath,
                    );
                  },
                  fullscreenDialog: true));
        } else {
          // play video
          if (mounted) {
            Util.playVideoHandler(context, widget.appWideState, entity,
                    widget.video, videoProgressEntity)
                .then((value) {
              // setting state after the video player popped the Navigator context
              // this reloads the video progress entity to show the playback progress
              checkPlaybackProgress();
              // also check if video is downloaded in the meantime
              checkIfAlreadyDownloaded();
            });
          }
        }
      },
    );
  }

  static double calculateImageHeight(
      Image? image, double totalWidth, double? presetAspectRatio) {
    if (image != null && presetAspectRatio != null) {
      return totalWidth / presetAspectRatio;
    } else if (image == null && presetAspectRatio != null) {
      return totalWidth / presetAspectRatio;
    } else if (image != null) {
      double originalWidth = image.width!;
      double originalHeight = image.height!;
      double aspectRatioVideo = originalWidth / originalHeight;

      //calc height
      double shrinkFactor = totalWidth / originalWidth;
      double height = originalHeight * shrinkFactor;
      return height;
    } else {
      return totalWidth / 16 * 9; //divide by aspect ratio
    }
  }

  Container getBottomBar(
      BuildContext context,
      VideoProgressEntity? playbackProgress,
      String? id,
      String duration,
      String title,
      int? timestamp,
      String assetPath) {
    return Container(
      color: Colors.grey[800],
      child: Column(
        children: <Widget>[
          playbackProgress != null
              ? PlaybackProgressBar(
                  playbackProgress.progress, int.tryParse(duration), false)
              : Container(),
          MetaInfoListTile.getVideoMetaInformationListTile(
              context, duration, title, timestamp, assetPath, entity != null),
        ],
      ),
    );
  }

  void checkPlaybackProgress() async {
    widget.appWideState.databaseManager
        .getVideoProgressEntity(widget.video.id)
        .then((entity) {
      widget.logger.info("Video has playback progress: ${widget.video.title!}");
      if (videoProgressEntity == null && mounted) {
        videoProgressEntity = entity;
        setState(() {});
      }
    });
  }

  void checkIfAlreadyDownloaded() async {
    widget.appWideState.downloadManager
        .isAlreadyDownloaded(widget.video.id)
        .then((entity) {
      if (this.entity == null && mounted) {
        this.entity = entity;
        setState(() {});
      }
    });
  }
}
