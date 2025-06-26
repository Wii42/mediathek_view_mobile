import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ws/global_state/app_state.dart';
import 'package:flutter_ws/global_state/video_progress_state.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/util/device_information.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/widgets/bars/playback_progress_bar.dart';
import 'package:flutter_ws/widgets/videolist/download_progress_bar.dart';
import 'package:flutter_ws/widgets/videolist/util/util.dart';
import 'package:flutter_ws/widgets/videolist/video_widget.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../drift_database/app_database.dart';
import 'download_switch.dart';
import 'meta_info_list_tile.dart';

class VideoDetailScreen extends StatelessWidget {
  final Logger logger = Logger('VideoDetailScreen');

  final Image image;
  final Video video;
  final VideoEntity? entity;
  final bool isDownloaded;
  final String heroUuid;
  final String? defaultImageAssetPath;

  VideoDetailScreen(this.image, this.video, this.entity, this.heroUuid,
      this.defaultImageAssetPath,
      {this.isDownloaded = false, super.key});

  @override
  Widget build(BuildContext context) {
    AppState appState = context.watch<AppState>();
    bool isTablet = DeviceInformation.isTablet(context);
    double totalImageWidth = MediaQuery.of(context).size.width;

    var orientation = MediaQuery.of(context).orientation;

    if (isTablet && orientation == Orientation.landscape) {
      totalImageWidth = totalImageWidth * 0.7;
      logger.info("Reduced with to: $totalImageWidth");
    }

    double height =
        VideoWidgetState.calculateImageHeight(image, totalImageWidth, 16 / 9);
    logger.info("Reduced height to: $height");

    Duration? progress = context.select<VideoProgressState, Duration?>(
        (progressState) =>
            progressState.getVideoProgressEntity(video.id!)?.progress);

    GestureDetector thumbnail =
        getImageSurface(totalImageWidth, height, appState, progress, context);

    Widget downloadProgressBar = DownloadProgressBar(
      videoId: video.id,
      videoTitle: video.title,
      isOnDetailScreen: true,
    );

    Widget layout;
    if (isTablet && orientation == Orientation.landscape) {
      layout = buildTabletLandscapeLayout(
          totalImageWidth, height, thumbnail, downloadProgressBar, context);
    } else if (!isTablet && orientation == Orientation.landscape) {
      // mobile landscape -> only provide ability to play video. no title nothing
      layout = Container(color: Colors.grey[900], child: thumbnail);
      // layout = buildMobileLandscapeLayout();
    } else {
      // all portrait:  like youtube:
      // first the title underneath
      // then rating
      // then description
      layout = buildVerticalLayout(thumbnail, downloadProgressBar, context);
    }

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: getAppBar(context),
            ),
            SliverToBoxAdapter(
              child: layout,
            ),
          ],
        ),
      ),
    );
  }

  Column buildTabletLandscapeLayout(double totalImageWidth, double height,
      GestureDetector image, Widget downloadProgressBar, BuildContext context) {
    Widget description = getDescription();

    double rowPaddingLeft = 10;
    double rowPaddingRight = 5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.grey[900],
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: totalImageWidth, maxHeight: height),
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    image,
                    Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: downloadProgressBar)
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: rowPaddingLeft, right: rowPaddingRight),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Container(
                  width: MediaQuery.of(context).size.width -
                      totalImageWidth -
                      rowPaddingLeft -
                      rowPaddingRight,
                  height: height,
                  color: Colors.grey[700],
                  child: description,
                ),
              ),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
          child: Column(
            children: [
              DownloadSwitch(
                video,
                video.size != null ? filesize(video.size) : "",
              ),
              MetaInfoListTile(
                  textTheme: Theme.of(context).textTheme,
                  duration: video.duration,
                  title: video.title ?? "",
                  topic: video.topic,
                  timestamp: video.timestamp,
                  assetPath: defaultImageAssetPath!,
                  isDownloaded: isDownloaded)
            ],
          ),
        ),
      ],
    );
  }

  Column buildVerticalLayout(
      GestureDetector image, Widget downloadProgressBar, BuildContext context) {
    Widget sideBar = Container();
    if (video.description != null && video.description!.isNotEmpty) {
      sideBar = SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 35, top: 10, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Description",
                  style: headerTextStyle.copyWith(fontSize: 30)),
              Container(height: 10),
              Text(video.description!,
                  style: subHeaderTextStyle.copyWith(fontSize: 20)),
            ],
          ),
        ),
      );
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
              alignment: Alignment.center,
              fit: StackFit.passthrough,
              children: <Widget>[
                Container(color: Colors.grey[900], child: image),
                Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: downloadProgressBar)
              ]),
          MetaInfoListTile(
              textTheme: Theme.of(context).textTheme,
              duration: video.duration,
              title: video.title ?? "",
              topic: video.topic,
              timestamp: video.timestamp,
              assetPath: defaultImageAssetPath!,
              isDownloaded: isDownloaded),
          Divider(),
          DownloadSwitch(
            video,
            video.size != null ? filesize(video.size) : "",
          ),
          sideBar,
        ]);
  }

  SingleChildScrollView getDescription() {
    var container = Container();

    if (video.description != null && video.description!.isNotEmpty) {
      container = Container(
        margin: EdgeInsets.only(left: 5),
        child: Column(
          children: <Widget>[
            Text("Beschreibung", style: headerTextStyle.copyWith(fontSize: 30)),
            Text(video.description!,
                style: subHeaderTextStyle.copyWith(fontSize: 20)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: container,
    );
  }

  GestureDetector getImageSurface(double totalImageWidth, double height,
      AppState appState, Duration? progress, BuildContext context) {
    Widget videoProgressBar =
        PlaybackProgressBar(progress ?? Duration.zero, video.duration, true);

    return GestureDetector(
      child: AspectRatio(
        aspectRatio: totalImageWidth > height
            ? totalImageWidth / height
            : height / totalImageWidth,
        child: Container(
          constraints: BoxConstraints(maxWidth: totalImageWidth),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: <Widget>[
              Hero(tag: heroUuid, child: image),
              Positioned(
                bottom: 0,
                left: 0.0,
                right: 0.0,
                child: Opacity(opacity: 1, child: videoProgressBar),
              ),
              Center(
                  child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 150.0,
              )),
            ],
          ),
        ),
      ),
      onTap: () async {
        // play video
        Util.playVideoHandler(context, entity, video);
      },
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Color(0xffffbf00),
        titleSpacing: 0.0,
        centerTitle: false,
        title: Text(
          "Zurück",
          style: sectionHeadingTextStyle,
        ),
        leading: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          IconButton(
            icon: Icon(Icons.arrow_back, size: 30.0, color: Colors.white),
            onPressed: () {
              //return channels when user pressed back
              return Navigator.pop(context);
            },
          ),
        ]));
  }
}
