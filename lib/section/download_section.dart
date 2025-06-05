import 'package:countly_flutter/countly_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
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

import '../drift_database/app_database.dart'
    show VideoEntity, VideoProgressEntity;
import '../util/device_information.dart';

const ERROR_MSG = "Deletion of video failed.";
const TRY_AGAIN_MSG = "Try again.";
const recentlyWatchedVideosLimit = 5;

class DownloadSection extends StatefulWidget {
  final Logger logger = Logger('DownloadSection');
  final AppState appWideState;

  DownloadSection(this.appWideState, {super.key});

  @override
  State<StatefulWidget> createState() => DownloadSectionState();
}

class DownloadSectionState extends State<DownloadSection> {
  final Logger logger = Logger('DownloadSectionState');
  List<Video> currentDownloads = [];
  List<Video> downloadedVideos = [];
  Set<String> userDeletedAppId; //used for fade out animation
  int milliseconds = 1500;
  Map<String, double> progress = {};
  Map<String?, VideoProgressEntity> videosWithPlaybackProgress = {};

  DownloadSectionState({this.userDeletedAppId = const {}});

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.appWideState.downloadManager.syncCompletedDownloads();
    loadAlreadyDownloadedVideosFromDb();
    loadVideosWithPlaybackProgress();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget loadingIndicator = getCurrentDownloadsTopBar();

    return _buildLayout(
        videosWithPlaybackProgress, size, context, loadingIndicator);
  }

  Widget getCurrentDownloadsTopBar() {
    if (currentDownloads.length == 1) {
      return CircularProgressWithText(
          Text(
            "Downloading: '${currentDownloads.elementAt(0).title!}'",
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
    widget.logger.info("Deleting video with title id: $id");
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    if (id == null) {
      logger.warning("Tried to delete video with null id");
      return;
    }
    widget.appWideState.downloadManager
        .deleteVideo(id)
        .then((bool deletedSuccessfully) {
      loadAlreadyDownloadedVideosFromDb();
      if (deletedSuccessfully) {
        SnackbarActions.showSuccess(scaffoldMessenger, "Löschen erfolgreich");
        return;
      }
      SnackbarActions.showErrorWithTryAgain(scaffoldMessenger, ERROR_MSG,
          TRY_AGAIN_MSG, widget.appWideState.downloadManager.deleteVideo, id);
    });
  }

  void loadAlreadyDownloadedVideosFromDb() async {
    List<VideoEntity> downloads =
        await widget.appWideState.databaseManager.getAllDownloadedVideos();

    if (downloadedVideos.length != downloads.length) {
      widget.logger.info("Downloads changed");
      downloadedVideos =
          downloads.map((entity) => Video.fromVideoEntity(entity)).toList();
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future loadVideosWithPlaybackProgress() async {
    //check for playback progress
    if (videosWithPlaybackProgress.isEmpty) {
      return widget.appWideState.databaseManager
          .getLastViewedVideos(recentlyWatchedVideosLimit)
          .then((all) {
        if (all.isNotEmpty) {
          bool stateReloadNeeded = false;
          for (var i = 0; i < all.length; ++i) {
            var entity = all.elementAt(i);
            if (!videosWithPlaybackProgress.containsKey(entity.id)) {
              videosWithPlaybackProgress.putIfAbsent(entity.id, () => entity);
              stateReloadNeeded = true;
            }
          }
          if (stateReloadNeeded && mounted) {
            setState(() {});
          }
          // generatePreview(all.take(amount_of_swiper_items))
        }
        return;
      });
    }
  }

  SliverPadding getWatchHistoryButton() {
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

  Widget _buildLayout(
      Map<String?, VideoProgressEntity> videosWithPlaybackProgress,
      Size size,
      BuildContext context,
      Widget currentDownloadsTopBar) {
    Widget recentlyViewedHeading = SliverToBoxAdapter(child: Container());
    Widget recentlyViewedSlider = SliverToBoxAdapter(child: Container());
    Widget watchHistoryNavigation = SliverToBoxAdapter(child: Container());

    int crossAxisCount = CrossAxisCount.getCrossAxisCount(context);
    widget.logger.info("Cross axis count: $crossAxisCount");
    if (videosWithPlaybackProgress.isNotEmpty) {
      recentlyViewedHeading = Heading("Kürzlich angesehen",
          fontSize: 25.0,
          padding: EdgeInsets.only(left: 20, top: 5, bottom: 16));

      List<Widget> watchHistoryItems = Util.getWatchHistoryItems(
          videosWithPlaybackProgress, size.width / crossAxisCount);

      double containerHeight = size.width / crossAxisCount / 16 * 9;

      Widget recentlyViewedSwiper = ListView(
        scrollDirection: Axis.horizontal,
        children: watchHistoryItems,
      );

      // special case for mobile & portrait -> use swiper instead of horizontally scrolling list
      if (!DeviceInformation.isTablet(context) &&
          MediaQuery.of(context).orientation == Orientation.portrait) {
        recentlyViewedSwiper =
            getMobileRecentlyWatchedSwiper(watchHistoryItems);
      }

      recentlyViewedSlider = SliverToBoxAdapter(
          child:
              SizedBox(height: containerHeight, child: recentlyViewedSwiper));

      // build navigation to complete history
      watchHistoryNavigation = getWatchHistoryButton();
    }

    Widget downloadHeading =
        SliverToBoxAdapter(child: getEmptyDownloadWidget());
    Widget downloadList = SliverToBoxAdapter(
      child: Container(),
    );

    if (downloadedVideos.isNotEmpty) {
      downloadHeading = Heading("Meine Downloads",
          fontSize: 25.0,
          padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 0.0));

      var videoListItemBuilder = VideoListItemBuilder.name(
          downloadedVideos.toList(), true, true, false,
          onRemoveVideo: deleteDownload);

      downloadList = SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 16 / 9,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 5.0,
        ),
        delegate: SliverChildBuilderDelegate(videoListItemBuilder.itemBuilder,
            childCount: downloadedVideos.length),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: currentDownloadsTopBar,
            ),
            recentlyViewedHeading,
            recentlyViewedSlider,
            watchHistoryNavigation,
            downloadHeading,
            CurrentDownloads(widget.appWideState, downloadedVideosChanged),
            downloadList
          ],
        ),
      ),
    );
  }

  Widget getMobileRecentlyWatchedSwiper(List<Widget> watchHistoryItems) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return watchHistoryItems[index];
      },
      itemCount: watchHistoryItems.length,
      pagination: SwiperPagination(),
      control: SwiperControl(),
    );
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

  // triggered when the download section should setState
  // 1) Download finished -> reload downloads from Database
  // 2) Current downloads retrieved -> to show green top bar
  void downloadedVideosChanged(List<Video> currentDownloads) {
    widget.logger.info("Downloads changed: setState()");

    if (this.currentDownloads.length != currentDownloads.length) {
      this.currentDownloads = currentDownloads;

      loadAlreadyDownloadedVideosFromDb();
      loadVideosWithPlaybackProgress();

      if (mounted) {
        setState(() {});
      }
    }
  }
}
