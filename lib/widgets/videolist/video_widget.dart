import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ws/global_state/app_state.dart';
import 'package:flutter_ws/global_state/video_download_state.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/widgets/bars/playback_progress_bar.dart';
import 'package:flutter_ws/widgets/videolist/download_progress_bar.dart';
import 'package:flutter_ws/widgets/videolist/util/util.dart';
import 'package:flutter_ws/widgets/videolist/video_detail_screen.dart';
import 'package:flutter_ws/widgets/videolist/video_preview_layout.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../drift_database/app_database.dart';
import '../../global_state/video_progress_state.dart';
import '../../model/download_info.dart';
import 'meta_info_list_tile.dart';

class VideoWidget extends StatefulWidget {
  static const Color bottomBarBackgroundColor =
      Color(0xFF424242); // Colors.grey[800]

  final Logger logger = Logger('VideoWidget');
  final AppState appWideState;
  final Video video;
  final String? mimeType;
  final String? defaultImageAssetPath;
  final Image? previewImage;
  final double width;
  final double? presetAspectRatio;
  final List<Widget> overlayWidgets;

  final bool openDetailPage;

  VideoWidget(
    this.appWideState,
    this.video,
    this.openDetailPage, {
    super.key,
    this.previewImage,
    this.mimeType,
    this.defaultImageAssetPath,
    required this.width,
    this.presetAspectRatio,
    this.overlayWidgets = const [],
  });

  @override
  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  late final String heroUuid;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    heroUuid = Uuid().v1();
  }

  @override
  Widget build(BuildContext context) {
    widget.logger.fine("Rendering Image for ${widget.video.id!}");

    //Always fill full width & calc height accordingly
    double totalWidth = widget.width - 36.0; //Intendation: 28 left, 8 right
    double height = calculateImageHeight(
        widget.previewImage, totalWidth, widget.presetAspectRatio);

    Widget downloadProgressBar = DownloadProgressBar(
      videoId: widget.video.id,
      videoTitle: widget.video.title,
      isOnDetailScreen: false,
    );

    String assetName;
    if (widget.defaultImageAssetPath != null &&
        widget.defaultImageAssetPath!.isNotEmpty) {
      assetName = widget.defaultImageAssetPath!;
    } else {
      assetName = "MediathekViewLoading.png";
    }

    Image placeholderImage = Image.asset('assets/img/$assetName',
        width: totalWidth,
        height: height,
        alignment: Alignment.center,
        gaplessPlayback: true);

    Duration? progress = context.select<VideoProgressState, Duration?>(
        (progressState) =>
            progressState.getVideoProgressEntity(widget.video.id!)?.progress);
    DownloadInfo? downloadInfo =
        context.select<VideoDownloadState?, DownloadInfo?>(
            (downloadState) => downloadState?.getEntityForId(widget.video.id!));
    VideoEntity? entity = downloadInfo?.videoEntity;

    return VideoPreviewLayout(
      width: widget.width,
      thumbnailImage: Hero(
        tag: heroUuid,
        child: AnimatedCrossFade(
          firstChild: placeholderImage,
          secondChild: widget.previewImage ?? placeholderImage,
          crossFadeState: widget.previewImage == null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 750),
        ),
      ),
      videoInfoBottomBar: getBottomBar(
          Theme.of(context).textTheme,
          progress,
          widget.video.id,
          widget.video.duration,
          widget.video.title ?? "",
          widget.video.topic,
          widget.video.timestamp,
          widget.defaultImageAssetPath!,
          downloadInfo?.isDownloadedAlready() ?? false),
      aspectRatio:
          totalWidth > height ? totalWidth / height : height / totalWidth,
      overlayWidgets: [
        ...widget.overlayWidgets,
        Positioned(
            bottom: 0.0, left: 0.0, right: 0.0, child: downloadProgressBar)
      ],
      gestureDetector: (child) => GestureDetector(
        child: child,
        onTap: () {
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
                        heroUuid,
                        widget.defaultImageAssetPath,
                      );
                    },
                    fullscreenDialog: true));
          } else {
            // play video
            if (mounted) {
              Util.playVideoHandler(
                  context, widget.appWideState, entity, widget.video);
            }
          }
        },
      ),
    );
  }

  static double calculateImageHeight(
      Image? image, double totalWidth, double? presetAspectRatio) {
    if (presetAspectRatio != null) {
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

  Widget getBottomBar(
      TextTheme textTheme,
      Duration? playbackProgress,
      String? id,
      Duration? duration,
      String title,
      String? topic,
      DateTime? timestamp,
      String assetPath,
      bool isDownloaded) {
    return Column(
      children: <Widget>[
        PlaybackProgressBar(playbackProgress ?? Duration.zero, duration, true),
        ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: VideoPreviewLayout.cornerClipping,
              bottomRight: VideoPreviewLayout.cornerClipping),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: VideoWidget.bottomBarBackgroundColor.withAlpha(177),
              child: MetaInfoListTile(
                  textTheme: textTheme,
                  duration: duration,
                  title: title,
                  topic: topic,
                  timestamp: timestamp,
                  assetPath: assetPath,
                  isDownloaded: isDownloaded,
                  titleMaxLines: 2),
            ),
          ),
        ),
      ],
    );
  }
}
