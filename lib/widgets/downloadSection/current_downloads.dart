import 'package:flutter/material.dart';
import 'package:flutter_ws/global_state/video_download_state.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/section/download_section.dart';
import 'package:flutter_ws/util/cross_axis_count.dart';
import 'package:flutter_ws/util/show_snackbar.dart';
import 'package:flutter_ws/widgets/downloadSection/video_list_item_builder.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../drift_database/app_database.dart' show VideoEntity;

class CurrentDownloads extends StatelessWidget {
  final Logger logger = Logger('CurrentDownloads');
  final int downloadManagerIdentifier = 1;

  CurrentDownloads({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<VideoDownloadState?, List<VideoEntity>>(
      selector: (_, downloadState) =>
          downloadState
              ?.getCurrentDownloads()
              .map((info) => info.videoEntity)
              .toList() ??
          [],
      builder: (BuildContext context, List<VideoEntity> currentDownloadEntities,
          Widget? child) {
        List<Video> currentDownloads = currentDownloadEntities
            .map((entity) => Video.fromVideoEntity(entity))
            .toList();

        if (currentDownloads.isEmpty) {
          return SliverToBoxAdapter(child: Container());
        }

        VideoListItemBuilder videoListItemBuilder = VideoListItemBuilder(
            currentDownloads.toList(),
            showDeleteButton: true,
            openDetailPage: true,
            onRemoveVideo: cancelCurrentDownload);

        int crossAxisCount = CrossAxisCount.getCrossAxisCount(context);

        SliverGrid downloadList = SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 16 / 9,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 5.0,
          ),
          delegate: SliverChildBuilderDelegate(videoListItemBuilder.itemBuilder,
              childCount: currentDownloads.length),
        );

        return downloadList;
      },
    );
  }

  //Cancels active download (remove from task schema), removes the file from local storage & deletes the entry in VideoEntity schema
  void cancelCurrentDownload(BuildContext context, String? id) {
    VideoDownloadState? videoDownloadState =
        context.read<VideoDownloadState?>();
    logger.info("Canceling download for: $id");
    if (id == null) {
      logger.warning("Cannot cancel download, id is null");
      return;
    }
    if (videoDownloadState == null) {
      logger.warning("Cannot cancel download, videoDownloadState is null");
      return;
    }
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    videoDownloadState.deleteVideo(id).then((bool deletedSuccessfully) {
      if (deletedSuccessfully) {
        SnackbarActions.showSuccess(scaffoldMessenger, "Löschen erfolgreich");
        return;
      }
      SnackbarActions.showErrorWithTryAgain(scaffoldMessenger, ERROR_MSG,
          TRY_AGAIN_MSG, videoDownloadState.deleteVideo, id);
    });
  }
}
