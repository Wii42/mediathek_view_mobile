import 'package:flutter/material.dart';
import 'package:flutter_ws/global_state/app_state.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/widgets/videolist/video_widget.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../drift_database/app_database.dart';
import '../../global_state/video_preview_state.dart';

class VideoPreviewAdapter extends StatefulWidget {
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

  @override
  State<VideoPreviewAdapter> createState() => _VideoPreviewAdapterState();
}

class _VideoPreviewAdapterState extends State<VideoPreviewAdapter> {
  VideoEntity? videoEntity;
  VideoProgressEntity? videoProgressEntity;
  bool isCurrentlyDownloading = false;

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

    return Consumer<AppState>(builder: (context, appState, _) {
      return Selector<VideoPreviewState, Image?>(
          selector: (_, previewImageState) {
        return previewImageState.getPreviewImage(widget.video.id!,
            createIfNotExists: appState.canCreateThumbnail,
            video: widget.video,
            entity: videoEntity);
      }, builder: (context, previewImage, child) {
        // check if video is currently downloading
        //appState.downloadManager
        //    .isCurrentlyDownloading(widget.video.id)
        //    .then((value) {
        //  if (value != null) {
        //    if (isCurrentlyDownloading) {
        //      widget.logger
        //          .info("Video is downloading:  ${widget.video.title!}");
        //      isCurrentlyDownloading = true;
        //      if (mounted) {
        //        setState(() {});
        //      }
        //    }
        //  }
        //});

        return Column(
          key: Key(uuid.v1()),
          children: <Widget>[
            Container(
              key: Key(uuid.v1()),
              child: VideoWidget(
                appState,
                widget.video,
                widget.openDetailPage,
                previewImage: previewImage,
                defaultImageAssetPath: widget.defaultImageAssetPath,
                width: widget.width ?? size.width,
                presetAspectRatio: widget.presetAspectRatio,
                overlayWidgets: widget.overlayWidgets,
              ),
            ),
          ],
        );
      });
    });
  }
}
