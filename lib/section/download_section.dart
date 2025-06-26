import 'package:countly_flutter/countly_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter_ws/global_state/video_download_state.dart';
import 'package:flutter_ws/global_state/video_progress_state.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/util/channel_util.dart';
import 'package:flutter_ws/util/cross_axis_count.dart';
import 'package:flutter_ws/util/show_snackbar.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/widgets/downloadSection/current_downloads.dart';
import 'package:flutter_ws/widgets/downloadSection/heading.dart';
import 'package:flutter_ws/widgets/downloadSection/util.dart';
import 'package:flutter_ws/widgets/downloadSection/video_list_item_builder.dart';
import 'package:flutter_ws/widgets/downloadSection/watch_history.dart';
import 'package:flutter_ws/widgets/videolist/circular_progress_with_text.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../drift_database/app_database.dart'
    show VideoEntity, VideoProgressEntity;
import '../model/download_info.dart';
import '../util/device_information.dart';

const ERROR_MSG = "Deletion of video failed.";
const TRY_AGAIN_MSG = "Try again.";
const recentlyWatchedVideosLimit = 5;

class DownloadSection extends StatelessWidget {
  final Logger logger = Logger('DownloadSection');

  DownloadSection({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget loadingIndicator = getCurrentDownloadsTopBar(context);

    return Selector<VideoDownloadState?, List<VideoEntity>>(
      builder: (context, downloadedVideoEntities, _) {
        return Selector<VideoProgressState, List<VideoProgressEntity>>(
            selector: (_, videoProgressState) => videoProgressState
                .getLastViewedVideos(recentlyWatchedVideosLimit),
            builder: (context, videosWithPlaybackProgress, _) {
              Widget recentlyViewedHeading =
                  SliverToBoxAdapter(child: Container());
              Widget recentlyViewedSlider =
                  SliverToBoxAdapter(child: Container());
              Widget watchHistoryNavigation =
                  SliverToBoxAdapter(child: Container());

              List<Video> downloadedVideos = downloadedVideoEntities
                  .map((entity) => Video.fromVideoEntity(entity))
                  .toList();

              int crossAxisCount = CrossAxisCount.getCrossAxisCount(context);
              logger.info("Cross axis count: $crossAxisCount");
              if (videosWithPlaybackProgress.isNotEmpty) {
                recentlyViewedHeading = Heading("Kürzlich angesehen",
                    fontSize: 25.0,
                    padding: EdgeInsets.only(left: 20, top: 5, bottom: 16));

                List<Widget> watchHistoryItems = Util.getWatchHistoryItems(
                    videosWithPlaybackProgress, size.width / crossAxisCount);

                double containerHeight =
                    (size.width / crossAxisCount / 16 * 9) + 33;

                Widget recentlyViewedSwiper = ListView(
                  scrollDirection: Axis.horizontal,
                  children: watchHistoryItems,
                );

                // special case for mobile & portrait -> use swiper instead of horizontally scrolling list
                if (!DeviceInformation.isTablet(context) &&
                    MediaQuery.of(context).orientation ==
                        Orientation.portrait) {
                  recentlyViewedSwiper = getMobileRecentlyWatchedSwiper(
                      context, watchHistoryItems);
                }

                recentlyViewedSlider = SliverToBoxAdapter(
                    child: SizedBox(
                        height: containerHeight, child: recentlyViewedSwiper));

                // build navigation to complete history
                watchHistoryNavigation = getWatchHistoryButton(context);
              }

              Widget downloadHeading =
                  SliverToBoxAdapter(child: getEmptyDownloadWidget());
              Widget downloadList = SliverToBoxAdapter(
                child: Container(),
              );

              if (downloadedVideos.isNotEmpty) {
                downloadHeading = Heading("Meine Downloads",
                    fontSize: 25.0,
                    padding:
                        EdgeInsets.only(left: 20.0, top: 20.0, bottom: 0.0));

                var videoListItemBuilder = VideoListItemBuilder(
                    downloadedVideos.toList(),
                    showDeleteButton: true,
                    openDetailPage: false,
                    onRemoveVideo: deleteDownload);

                downloadList = SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 16 / 9,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 5.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                      videoListItemBuilder.itemBuilder,
                      childCount: downloadedVideos.length),
                );
              }

              return Scaffold(
                backgroundColor: Colors.grey[800],
                body: SafeArea(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: loadingIndicator,
                      ),
                      recentlyViewedHeading,
                      recentlyViewedSlider,
                      watchHistoryNavigation,
                      downloadHeading,
                      CurrentDownloads(),
                      downloadList
                    ],
                  ),
                ),
              );
            });
      },
      selector: (_, downloadState) {
        return downloadState
                ?.getAllDownloads()
                .map((info) => info.videoEntity)
                .toList() ??
            [];
      },
    );
  }

  Widget getCurrentDownloadsTopBar(BuildContext context) {
    List<DownloadInfo> currentDownloads =
        context.select<VideoDownloadState?, List<DownloadInfo>>(
            (state) => state?.getCurrentDownloads() ?? []);
    if (currentDownloads.length == 1) {
      return CircularProgressWithText(
          Text(
            "Downloading: '${currentDownloads.first.videoEntity.title}'",
            style: connectionLostTextStyle,
            softWrap: true,
            maxLines: 3,
          ),
          Colors.green,
          Colors.green);
    } else if (currentDownloads.length > 1) {
      return CircularProgressWithText(
        Text("Downloading ${currentDownloads.length} videos",
            style: connectionLostTextStyle),
        Colors.green,
        Colors.green,
        height: 50.0,
      );
    } else {
      return Container();
    }
  }

  //Cancels active download (remove from task schema), removes the file from local storage & deletes the entry in VideoEntity schema
  void deleteDownload(BuildContext context, String? id) {
    logger.info("Deleting video with title id: $id");
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    if (id == null) {
      logger.warning("Tried to delete video with null id");
      return;
    }

    VideoDownloadState? downloadState = context.read<VideoDownloadState?>();
    if (downloadState != null) {
      downloadState.deleteVideo(id).then((bool deletedSuccessfully) {
        if (deletedSuccessfully) {
          SnackbarActions.showSuccess(scaffoldMessenger, "Löschen erfolgreich");
          return;
        }
        SnackbarActions.showErrorWithTryAgain(scaffoldMessenger, ERROR_MSG,
            TRY_AGAIN_MSG, downloadState.deleteVideo, id);
      });
    }
  }

  SliverPadding getWatchHistoryButton(BuildContext context) {
    ListTile tile = ListTile(
      leading: Icon(
        Icons.history,
        color: Color(0xffffbf00),
        size: 30.0,
      ),
      title: Text(
        "Alle angesehenen Videos",
        style: TextStyle(
            fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w600),
      ),
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              // TODO: save previews of recently watched videos to disk
              // 1) get previews from file 2) previews even when video is already deleted
              return WatchHistory();
            },
            settings: RouteSettings(name: "WatchHistory"),
            fullscreenDialog: true));

        Countly.instance.views.startView("WatchHistory");
      },
    );

    return SliverPadding(
      padding: EdgeInsets.only(top: 10.0, bottom: 8.0),
      sliver: SliverToBoxAdapter(child: tile),
    );
  }

  Widget getMobileRecentlyWatchedSwiper(
      BuildContext context, List<Widget> watchHistoryItems) {
    ThemeData theme = Theme.of(context);
    return Swiper(
        itemBuilder: (BuildContext context, int index) {
          return watchHistoryItems[index];
        },
        itemCount: watchHistoryItems.length,
        pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                activeColor: theme.bottomNavigationBarTheme.selectedItemColor)),
        control: SwiperControl(
            color: theme.bottomNavigationBarTheme.selectedItemColor),
        outer: true);
  }

  Center getEmptyDownloadWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Keine Downloads",
              style: TextStyle(fontSize: 25),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: ChannelUtil.getAllChannelImages(),
            ),
          ),
        ],
      ),
    );
  }
}
