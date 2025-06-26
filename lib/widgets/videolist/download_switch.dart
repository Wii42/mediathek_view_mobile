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
import 'package:uuid/uuid.dart';

import '../../model/download_info.dart';

const ERROR_MSG = "Löschen fehlgeschlagen";

class DownloadSwitch extends StatefulWidget {
  final Logger logger = Logger('DownloadSwitch');

  final Video video;

  final String? filesize;

  DownloadSwitch(this.video, this.filesize, {super.key});

  @override
  State<DownloadSwitch> createState() => DownloadSwitchState();
}

class DownloadSwitchState extends State<DownloadSwitch> {
  bool permissionDenied = false;
  Uuid uuid = Uuid();

  DownloadSwitchState();

  bool get isLivestreamVideo => VideoUtil.isLivestreamVideo(widget.video);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<VideoDownloadState?>(context) == null) {
      widget.logger
          .fine("VideoDownloadState is null, not rendering DownloadSwitch");
      return SizedBox();
    }

    DownloadInfo? downloadInfo =
        context.select<VideoDownloadState?, DownloadInfo?>(
            (downloadState) => downloadState?.getEntityForId(widget.video.id!));
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
      key: Key(uuid.v1()),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          key: Key(uuid.v1()),
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

    widget.logger
        .info("Triggering download for video with id ${widget.video.id!}");
    downloadVideo();
  }

  bool downloadFailed(DownloadInfo? downloadInfo) {
    return downloadInfo?.isFailed ?? false;
  }

  String getVideoDownloadText(DownloadInfo? downloadInfo) {
    if (downloadInfo == null ||
        downloadInfo.downloadStatus == DownloadTaskStatus.undefined ||
        downloadInfo.downloadStatus == DownloadTaskStatus.canceled) {
      return widget.filesize != null && widget.filesize!.isNotEmpty
          ? "Download (${widget.filesize})"
          : "Download";
    }

    if (downloadInfo.isDownloadedAlready()) {
      return widget.filesize != null && widget.filesize!.isNotEmpty
          ? "Löschen (${widget.filesize})"
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

  void downloadVideo() async {
    widget.logger.info("Download video: ${widget.video.title!}");
    VideoDownloadState? downloadState = context.read<VideoDownloadState?>();
    if (downloadState == null) {
      widget.logger.severe("VideoDownloadState is null, cannot download video");
      return;
    }
    AppState appState = context.read<AppState>();
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      SnackbarActions.showError(scaffoldMessenger, ERROR_MSG_NO_INTERNET);
      downloadState.setStatusForDownloadInfo(
          widget.video.id!, DownloadTaskStatus.failed);
      return;
    }

    // also check if video url is accessible
    final response = await http.head(widget.video.url_video!);

    if (response.statusCode >= 300) {
      SnackbarActions.showError(scaffoldMessenger, ERROR_MSG_NOT_AVAILABLE);
      downloadState.setStatusForDownloadInfo(
          widget.video.id!, DownloadTaskStatus.failed);
      return;
    }

    widget.logger.fine("Video available, starting download...");

    // start download animation right away.
    downloadState.setStatusForDownloadInfo(
        widget.video.id!, DownloadTaskStatus.enqueued);
    // check for filesystem permissions
    // if user grants permission, start downloading right away
    if (appState.hasFilesystemPermission) {
      widget.logger
          .fine("Filesystem permission already granted, starting download");
      downloadState.checkAndRequestFilesystemPermissions(widget.video);
      return;
    }

    downloadState
        .downloadFile(widget.video)
        .then((video) => widget.logger.info("Downloaded request successfull"),
            onError: (e) {
      widget.logger.severe(
          "Error starting download: ${widget.video.title!}. Error:  $e");
    });
  }

  void deleteVideo(VideoDownloadState? downloadState) {
    if (downloadState == null) {
      widget.logger.severe("VideoDownloadState is null, cannot delete video");
      return;
    }
    downloadState
        .deleteVideo(widget.video.id!)
        .then((bool deletedSuccessfully) {
      if (!deletedSuccessfully) {
        widget.logger
            .severe("Failed to delete video with title ${widget.video.title!}");
      }

      downloadState.setStatusForDownloadInfo(
          widget.video.id!, DownloadTaskStatus.undefined,
          progress: null);
    });
  }
}
