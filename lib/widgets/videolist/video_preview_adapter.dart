import 'package:flutter/material.dart';
import 'package:flutter_ws/global_state/app_state.dart';
import 'package:flutter_ws/global_state/video_download_state.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/widgets/videolist/video_widget.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../drift_database/app_database.dart';
import '../../global_state/video_preview_state.dart';

class VideoPreviewAdapter extends StatelessWidget {
  final Logger logger = Logger('VideoPreviewAdapter');
  final Video video;
  final String? defaultImageAssetPath;
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
    required this.isVisible,
    required this.openDetailPage,
    super.key,
    this.defaultImageAssetPath,
    this.size,
    this.presetAspectRatio,
    this.width,
    this.overlayWidgets = const [],
  });

  Size getSize(BuildContext context) {
    if (size != null) {
      return size!;
    }
    return MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return Container();
    }

    bool canCreateThumbnail = context
        .select<AppState, bool>((appState) => appState.canCreateThumbnail);
    VideoEntity? videoEntity =
        context.select<VideoDownloadState?, VideoEntity?>((downloadState) =>
            downloadState?.getEntityForId(video.id!)?.videoEntity);

    return Selector<VideoPreviewState, Image?>(
        selector: (_, previewImageState) {
      return previewImageState.getPreviewImage(video.id!,
          createIfNotExists: canCreateThumbnail,
          video: video,
          entity: videoEntity);
    }, builder: (context, previewImage, child) {
      return Column(
        children: <Widget>[
          VideoWidget(
            video,
            openDetailPage,
            previewImage: previewImage,
            defaultImageAssetPath: defaultImageAssetPath,
            width: width ?? getSize(context).width,
            presetAspectRatio: presetAspectRatio,
            overlayWidgets: overlayWidgets,
          ),
        ],
      );
    });
  }
}
