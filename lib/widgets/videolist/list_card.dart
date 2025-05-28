import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_ws/database/video_entity.dart';
import 'package:flutter_ws/database/video_progress_entity.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/platform_channels/download_manager_flutter.dart';
import 'package:flutter_ws/util/device_information.dart';
import 'package:flutter_ws/util/show_snackbar.dart';
import 'package:flutter_ws/widgets/bars/playback_progress_bar.dart';
import 'package:flutter_ws/widgets/videolist/channel_thumbnail.dart';
import 'package:flutter_ws/widgets/videolist/util/util.dart';
import 'package:flutter_ws/widgets/videolist/video_description.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'download_switch.dart';

class ListCard extends StatefulWidget {
  final Logger logger = Logger('VideoWidget');
  final String channelPictureImagePath;
  final Video video;

  ListCard(
      {Key? key, required this.channelPictureImagePath, required this.video})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListCardState();
  }
}

class _ListCardState extends State<ListCard> {
  static const downloadManagerIdentifier = 0;
  bool modalBottomScreenIsShown = false;
  bool isDownloadedAlready = false;
  VideoEntity? entity;
  bool isCurrentlyDownloading = false;
  DownloadTaskStatus? currentStatus;
  double? progress;
  GlobalKey? _keyListRow;
  VideoProgressEntity? videoProgressEntity;

  @override
  void dispose() {
    super.dispose();
    widget.logger.fine(
        "Disposing list-card for video with title ${widget.video.title!} and id ${widget.video.id!}");
    AppState? appState = context.read<AppState?>();
    appState?.downloadManager
        .unsubscribe(widget.video.id, downloadManagerIdentifier);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppState, VideoListState>(
      builder: (context, appState, videoListState, child) {
        Orientation orientation = MediaQuery.of(context).orientation;

        subscribeToProgressChannel();
        loadCurrentStatusFromDatabase(widget.video.id, appState);

        bool isExtendet = false;
        Set<String?> extendetTiles = videoListState.extendedListTiles;
        isExtendet = extendetTiles.contains(widget.video.id);

        Uuid uuid = Uuid();

        final cardContent = Column(
          key: Key(uuid.v1()),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(key: Key(uuid.v1()), height: 4.0),
            Flexible(
              key: Key(uuid.v1()),
              child: Container(
                key: Key(uuid.v1()),
                margin: EdgeInsets.only(left: 40.0, right: 12.0),
                child: Text(
                  widget.video.topic!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.black),
                ),
              ),
            ),
            Container(key: Key(uuid.v1()), height: 10.0),
            Flexible(
              key: Key(uuid.v1()),
              child: Container(
                key: Key(uuid.v1()),
                margin: EdgeInsets.only(left: 40.0, right: 12.0),
                child: Text(
                  widget.video.title!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black),
                ),
              ),
            ),
            isExtendet == true
                ? Container(
                    key: Key(uuid.v1()),
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 40.0),
                    height: 2.0,
                    color: Colors.grey)
                : Container(
                    key: Key(uuid.v1()),
                    padding: EdgeInsets.only(left: 40.0, right: 12.0),
                  ),
            Column(
              key: Key(uuid.v1()),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                  child: Stack(
                    children: <Widget>[
                      /*new VideoPreviewAdapter(widget.video, true, true,
                      defaultImageAssetPath: widget.channelPictureImagePath),
                 */
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Opacity(
                          opacity: 0.8,
                          child: Column(
                            children: <Widget>[
                              // Playback Progress
                              videoProgressEntity != null
                                  ? PlaybackProgressBar(
                                      videoProgressEntity!.progress,
                                      int.tryParse(
                                          widget.video.duration.toString()),
                                      true)
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                DownloadSwitch(
                    widget.video,
                    isCurrentlyDownloading,
                    isDownloadedAlready,
                    appState.downloadManager,
                    widget.video.size != null
                        ? filesize(widget.video.size)
                        : "",
                    DeviceInformation.isTablet(context)),
              ],
            ),
          ],
        );

        final card = ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Container(
            child: cardContent,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
            ),
          ),
        );

        //used to determine position on screen to place description popup correctly
        _keyListRow = GlobalKey();

        return Container(
          key: _keyListRow,
          margin: const EdgeInsets.symmetric(
            horizontal: 4.0,
          ),
          child: Stack(
            children: <Widget>[
              GestureDetector(onTap: _handleTap, child: card),
              isExtendet
                  ? Container()
                  : Positioned.fill(
                      left: 20.0,
                      child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: _handleTap, onLongPress: showDescription)),
                    ),
              widget.channelPictureImagePath.isNotEmpty
                  ? Positioned(
                      left: 5.0,
                      bottom: 5.0,
                      child: ChannelThumbnail(
                          widget.channelPictureImagePath, isDownloadedAlready),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  void _handleTap() {
    widget.logger.info("handle tab on tile");
    if (widget.video.id != null) {
      context.read<VideoListState>().updateExtendedListTile(widget.video.id!);
    }
    //only rerender this tile, not the whole app state!
    setState(() {});
  }

  void showDescription() {
    double distanceOfRowToStart = determineDistanceOfRowToStart();
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return VideoDescription(
            widget.video, widget.channelPictureImagePath, distanceOfRowToStart);
      },
    );
  }

  double determineDistanceOfRowToStart() {
    final RenderBox renderBox =
        _keyListRow!.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    return position.distance;
  }

  void onDownloadStateChanged(String? videoId,
      DownloadTaskStatus? updatedStatus, double updatedProgress) {
    widget.logger.info(
        "Download: ${widget.video.title!} status: $updatedStatus progress: $updatedProgress");

    progress = updatedProgress;

    updateStatus(updatedStatus, videoId);
  }

  void updateStatus(DownloadTaskStatus? updatedStatus, String? videoId) {
    if (mounted) {
      setState(() {
        currentStatus = updatedStatus;
      });
    } else {
      widget.logger.fine(
          "Not updating status for Video  ${videoId!} - downloadCardBody not mounted");
    }
  }

  void subscribeToProgressChannel() {
    DownloadManager downloadManager = context.read<AppState>().downloadManager;
    downloadManager.subscribe(
        widget.video.id,
        onDownloadStateChanged,
        onDownloaderComplete,
        onDownloaderFailed,
        onSubscriptionCanceled,
        downloadManagerIdentifier);
  }

  void onDownloaderFailed(String? videoId) {
    widget.logger.info("Download video: ${videoId!} received 'failed' signal");
    // SnackbarActions.showError(context, ERROR_MSG_DOWNLOAD_FAILED);
    updateStatus(DownloadTaskStatus.failed, videoId);
  }

  void onDownloaderComplete(String? videoId) {
    widget.logger
        .info("Download video: ${videoId!} received 'complete' signal");
    updateStatus(DownloadTaskStatus.complete, videoId);
  }

  void onSubscriptionCanceled(String? videoId) {
    widget.logger.info("Download video: ${videoId!} received 'cancled' signal");
    updateStatus(DownloadTaskStatus.canceled, videoId);
  }

  void loadCurrentStatusFromDatabase(String? videoId, AppState appState) async {
    if (videoProgressEntity == null) {
      appState.databaseManager.getVideoProgressEntity(videoId).then((entity) {
        if (entity != null) {
          videoProgressEntity = entity;
          if (mounted) {
            setState(() {});
          }
        }
      });
    }

    VideoEntity? entity =
        await appState.downloadManager.isAlreadyDownloaded(videoId);
    if (entity != null) {
      widget.logger.info(
          "Video with name  ${widget.video.title!} and id ${videoId!} is downloaded already");
      this.entity = entity;
      if (!isDownloadedAlready) {
        isDownloadedAlready = true;
        isCurrentlyDownloading = false;
        currentStatus = null;
        if (mounted) {
          setState(() {});
        }
      }
      return;
    }

    if (await appState.downloadManager.isCurrentlyDownloading(videoId) !=
        null) {
      widget.logger.fine(
          "Video with name  ${widget.video.title!} and id ${videoId!} is currently downloading");
      if (!isCurrentlyDownloading) {
        isDownloadedAlready = false;
        isCurrentlyDownloading = true;
        currentStatus = DownloadTaskStatus.running;

        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  void onDownloadRequested() async {
    AppState appWideState = context.read<AppState>();
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      SnackbarActions.showError(scaffoldMessenger, ERROR_MSG_NO_INTERNET);
      updateStatus(DownloadTaskStatus.failed, widget.video.id);
      return;
    }

    // also check if video url is accessible
    final response = await http.head(Uri.parse(widget.video.url_video!));

    if (response.statusCode >= 300) {
      widget.logger.info(
          "Url is not accessible: ${widget.video.url_video}. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase!}");

      SnackbarActions.showError(scaffoldMessenger, ERROR_MSG_NOT_AVAILABLE);
      updateStatus(DownloadTaskStatus.failed, widget.video.id);
      return;
    }

    subscribeToProgressChannel();
    // start download animation right away.
    onDownloadStateChanged(widget.video.id, DownloadTaskStatus.enqueued, -1);

    // check for filesystem permissions
    // if user grants permission, start downloading right away
    if (!appWideState.hasFilesystemPermission) {
      appWideState.downloadManager
          .checkAndRequestFilesystemPermissions(appWideState, widget.video);
      return;
    }

    appWideState.downloadManager
        .downloadFile(widget.video)
        .then((video) => widget.logger.info("Downloaded request successfull"),
            onError: (e) {
      widget.logger.severe(
          "Error starting download: ${widget.video.title!}. Error:  $e");
    });
  }

  void onDeleteRequested() {
    DownloadManager downloadManager = context.read<AppState>().downloadManager;
    downloadManager
        .deleteVideo(widget.video.id)
        .then((bool deletedSuccessfully) {
      if (!deletedSuccessfully) {
        widget.logger
            .severe("Failed to delete video with title ${widget.video.title!}");
      }
      isDownloadedAlready = false;
      isCurrentlyDownloading = false;
      currentStatus = null;
      progress = null;
      if (mounted) {
        setState(() {});
      }
    });
  }
}
