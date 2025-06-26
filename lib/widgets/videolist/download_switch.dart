import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_ws/global_state/app_state.dart';
import 'package:flutter_ws/global_state/video_download_state.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/util/show_snackbar.dart';
import 'package:flutter_ws/util/video.dart';
import 'package:flutter_ws/widgets/videolist/util/util.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../model/download_info.dart';

const ERROR_MSG = "Löschen fehlgeschlagen";

class DownloadSwitch extends StatelessWidget {
  final Logger logger = Logger('DownloadSwitch');

  final Video video;

  final String? filesize;

  final bool permissionDenied = false;

  DownloadSwitch(this.video, this.filesize, {super.key});

  bool get isLivestreamVideo => VideoUtil.isLivestreamVideo(video);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<VideoDownloadState?>(context) == null) {
      logger.fine("VideoDownloadState is null, not rendering DownloadSwitch");
      return SizedBox();
    }

    DownloadInfo? downloadInfo =
        context.select<VideoDownloadState?, DownloadInfo?>(
            (downloadState) => downloadState?.getEntityForId(video.id!));
    Widget download = Container();
    if (!isLivestreamVideo) {
      ActionChip downloadChip = ActionChip(
        avatar: getAvatar(downloadInfo),
        label: Text(
          getVideoDownloadText(downloadInfo),
          style: TextStyle(fontSize: 20.0),
        ),
        labelStyle: TextStyle(color: Colors.white),
        onPressed: () => downloadButtonPressed(downloadInfo, context),
        backgroundColor: getChipBackgroundColor(
            downloadInfo?.isDownloadedAlready() ?? false),
        elevation: 20,
        padding: EdgeInsets.all(10),
      );
      download = downloadChip;

      if (downloadInfo?.isCurrentlyDownloading() ?? false) {
        ActionChip cancelDownloadChip = ActionChip(
          avatar: Icon(Icons.cancel, color: Colors.white),
          label: Text(
            "Cancel",
            style: TextStyle(fontSize: 20.0),
          ),
          labelStyle: TextStyle(color: Colors.white),
          onPressed: () => deleteVideo(context.read<VideoDownloadState?>()),
          backgroundColor: Colors.red,
          elevation: 20,
        );
        download = Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              cancelDownloadChip,
              Container(width: 25),
              downloadChip,
            ]);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          //padding: new EdgeInsets.only(left: 40.0, right: 12.0),
          child: download,
        ),
        downloadFailed(downloadInfo)
            ? Icon(Icons.warning, color: Colors.red)
            : Container(),
      ],
    );
  }

  void downloadButtonPressed(DownloadInfo? downloadInfo, BuildContext context) {
    VideoDownloadState? downloadState = context.read<VideoDownloadState?>();
    if (downloadInfo?.isCurrentlyDownloading() ?? false) {
      return;
    }

    if (downloadInfo?.isDownloadedAlready() ?? false) {
      deleteVideo(downloadState);
      return;
    }

    logger.info("Triggering download for video with id ${video.id!}");
    downloadVideo(context);
  }

  bool downloadFailed(DownloadInfo? downloadInfo) {
    return downloadInfo?.isFailed ?? false;
  }

  String getVideoDownloadText(DownloadInfo? downloadInfo) {
    if (downloadInfo == null ||
        downloadInfo.downloadStatus == DownloadTaskStatus.undefined ||
        downloadInfo.downloadStatus == DownloadTaskStatus.canceled) {
      return filesize != null && filesize!.isNotEmpty
          ? "Download ($filesize)"
          : "Download";
    }

    if (downloadInfo.isDownloadedAlready()) {
      return filesize != null && filesize!.isNotEmpty
          ? "Löschen ($filesize)"
          : "Löschen";
    } else if (downloadInfo.isDownloading &&
        downloadInfo.downloadProgress == null) {
      return "";
    } else if (downloadInfo.isDownloading) {
      return "${downloadInfo.downloadProgress}%";
    } else if (downloadInfo.isPaused) {
      return "${downloadInfo.downloadProgress}%";
    } else if (downloadInfo.isEnqueued) {
      return "Waiting...";
    } else if (downloadInfo.isFailed) {
      return "Download failed";
    }
    return "Unknown status";
  }

  Color getChipBackgroundColor(bool isDownloadedAlready) {
    if (isDownloadedAlready) {
      return Colors.green;
    } else {
      return Color(0xffffbf00);
    }
  }

  Widget getAvatar(DownloadInfo? downloadInfo) {
    if (permissionDenied == true) {
      return Icon(Icons.error, color: Colors.red);
    } else if (downloadInfo?.isCurrentlyDownloading() ?? false) {
      return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
    } else if (downloadInfo?.isDownloadedAlready() ?? false) {
      return Icon(Icons.cancel, color: Colors.red);
    } else {
      return Icon(Icons.file_download, color: Colors.green);
    }
  }

  void downloadVideo(BuildContext context) async {
    logger.info("Download video: ${video.title!}");
    VideoDownloadState? downloadState = context.read<VideoDownloadState?>();
    if (downloadState == null) {
      logger.severe("VideoDownloadState is null, cannot download video");
      return;
    }
    AppState appState = context.read<AppState>();
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      SnackbarActions.showError(scaffoldMessenger, ERROR_MSG_NO_INTERNET);
      downloadState.setStatusForDownloadInfo(
          video.id!, DownloadTaskStatus.failed);
      return;
    }

    // also check if video url is accessible
    final response = await http.head(video.url_video!);

    if (response.statusCode >= 300) {
      SnackbarActions.showError(scaffoldMessenger, ERROR_MSG_NOT_AVAILABLE);
      downloadState.setStatusForDownloadInfo(
          video.id!, DownloadTaskStatus.failed);
      return;
    }

    logger.fine("Video available, starting download...");

    // start download animation right away.
    downloadState.setStatusForDownloadInfo(
        video.id!, DownloadTaskStatus.enqueued);
    // check for filesystem permissions
    // if user grants permission, start downloading right away
    if (appState.hasFilesystemPermission) {
      logger.fine("Filesystem permission already granted, starting download");
      downloadState.checkAndRequestFilesystemPermissions(video);
      return;
    }

    downloadState.downloadFile(video).then(
        (video) => logger.info("Downloaded request successfull"), onError: (e) {
      logger.severe("Error starting download: ${video.title!}. Error:  $e");
    });
  }

  void deleteVideo(VideoDownloadState? downloadState) {
    if (downloadState == null) {
      logger.severe("VideoDownloadState is null, cannot delete video");
      return;
    }
    downloadState.deleteVideo(video.id!).then((bool deletedSuccessfully) {
      if (!deletedSuccessfully) {
        logger.severe("Failed to delete video with title ${video.title!}");
      }

      downloadState.setStatusForDownloadInfo(
          video.id!, DownloadTaskStatus.undefined,
          progress: null);
    });
  }
}
