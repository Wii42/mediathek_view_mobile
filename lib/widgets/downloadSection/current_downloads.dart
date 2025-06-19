import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/platform_channels/download_manager_flutter.dart';
import 'package:flutter_ws/section/download_section.dart';
import 'package:flutter_ws/util/cross_axis_count.dart';
import 'package:flutter_ws/util/show_snackbar.dart';
import 'package:flutter_ws/widgets/downloadSection/video_list_item_builder.dart';
import 'package:flutter_ws/widgets/videolist/download/download_controller.dart';
import 'package:flutter_ws/widgets/videolist/download/download_value.dart';
import 'package:logging/logging.dart';

import '../../drift_database/app_database.dart' show VideoEntity;

class CurrentDownloads extends StatefulWidget {
  final Logger logger = Logger('CurrentDownloads');
  final AppState appWideState;
  final void Function(List<Video>) setStateNecessary;
  final int downloadManagerIdentifier = 1;

  CurrentDownloads(this.appWideState, this.setStateNecessary, {super.key});

  @override
  State<CurrentDownloads> createState() => _CurrentDownloadsState();
}

class _CurrentDownloadsState extends State<CurrentDownloads> {
  List<Video> currentDownloads = [];
  Map<DownloadController, Function> downloadControllerToListener =
      <DownloadController, Function>{};

  @override
  void dispose() {
    downloadControllerToListener.forEach((controller, listener) {
      controller.removeListener(listener as void Function());
      controller.dispose();
    });
    super.dispose();
  }

  @override
  void initState() {
    updateCurrentDownloads().then((List<Video> videos) {
      for (var video in videos) {
        subscribeToDownloadUpdates(
            video.id, video.title, widget.appWideState.downloadManager);
      }

      if (videos.isNotEmpty && mounted) {
        widget.logger.fine("There are current downloads, setting state");
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (currentDownloads.isEmpty) {
      return SliverToBoxAdapter(child: Container());
    }

    VideoListItemBuilder videoListItemBuilder = VideoListItemBuilder.name(
        currentDownloads.toList(), true, true, true,
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
  }

  void subscribeToDownloadUpdates(
      String? videoId, String? videoTitle, DownloadManager downloadManager) {
    DownloadController downloadController =
        DownloadController(videoId, videoTitle, downloadManager);

    listener() async {
      DownloadValue value = downloadController.value;

      widget.logger.info(
          "Current download status for video: ${videoId!}${value.status}");

      if (value.status == DownloadTaskStatus.complete ||
          value.status == DownloadTaskStatus.failed ||
          value.status == DownloadTaskStatus.canceled) {
        updateCurrentDownloads();
      }
    }

    downloadController.addListener(listener);
    downloadController.initialize();
    downloadControllerToListener[downloadController] = listener;
  }

  Future<List<Video>> updateCurrentDownloads() async {
    List<VideoEntity> downloads =
        await widget.appWideState.downloadManager.getCurrentDownloads();

    List<Video> currentDownloads = [];
    for (VideoEntity entity in downloads) {
      Video video = Video.fromVideoEntity(entity);
      currentDownloads.add(video);
      widget.logger
          .info("Current download: ${video.id!}. Title: ${video.title!}");
    }

    widget.setStateNecessary(currentDownloads);
    this.currentDownloads = currentDownloads;

    return currentDownloads;
  }

  //Cancels active download (remove from task schema), removes the file from local storage & deletes the entry in VideoEntity schema
  void cancelCurrentDownload(BuildContext context, String? id) {
    widget.logger.info("Canceling download for: $id");
    if (id == null) {
      widget.logger.warning("Cannot cancel download, id is null");
      return;
    }
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    widget.appWideState.downloadManager
        .deleteVideo(id)
        .then((bool deletedSuccessfully) {
      if (deletedSuccessfully) {
        currentDownloads.removeWhere((video) {
          return video.id == id;
        });
        if (mounted) {
          SnackbarActions.showSuccess(scaffoldMessenger, "Löschen erfolgreich");
        }
        widget.setStateNecessary(currentDownloads);
        return;
      }
      SnackbarActions.showErrorWithTryAgain(scaffoldMessenger, ERROR_MSG,
          TRY_AGAIN_MSG, widget.appWideState.downloadManager.deleteVideo, id);
    });
  }
}
