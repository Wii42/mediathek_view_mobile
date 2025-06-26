import 'package:flutter/material.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/util/channel_util.dart';
import 'package:flutter_ws/widgets/downloadSection/video_list_item_builder.dart';
import 'package:flutter_ws/widgets/videolist/loading_list_view.dart';
import 'package:flutter_ws/widgets/videolist/video_preview_layout.dart';
import 'package:logging/logging.dart';

class VideoListView extends StatelessWidget {
  final Logger logger = Logger('VideoListView');

  final List<Video>? videos;
  final void Function() queryEntries;
  final List refreshList;
  final int? amountOfVideosFetched;
  final int? totalResultSize;
  final int currentQuerySkip;
  final TickerProviderStateMixin mixin;

  VideoListView({
    super.key,
    required this.queryEntries,
    required this.amountOfVideosFetched,
    required this.videos,
    required this.refreshList,
    required this.totalResultSize,
    required this.currentQuerySkip,
    required this.mixin,
  });

  @override
  Widget build(BuildContext context) {
    logger.info("Rendering Main Video List with list length ${videos!.length}");

    if (videos!.isEmpty && amountOfVideosFetched == 0) {
      logger.info("No Videos found");
      return SliverToBoxAdapter(child: buildNoVideosFound());
    } else if (videos!.isEmpty) {
      logger.info(
          "Searching: video list length : 0 & amountFetched: $amountOfVideosFetched");
      return LoadingListPage();
    }

    // do not request previews in the main download section if it is a tablet
    // do not overload CPU
    //bool previewNotDownloadedVideos = !DeviceInformation.isTablet(context);

    var videoListItemBuilder = VideoListItemBuilder(videos,
        showDeleteButton: false,
        openDetailPage: true,
        queryEntries: queryEntries,
        amountOfVideosFetched: amountOfVideosFetched,
        totalResultSize: totalResultSize,
        currentQuerySkip: currentQuerySkip);

    return VideoPreviewLayout.getVideoListViewLayout(
        context,
        SliverChildBuilderDelegate(videoListItemBuilder.itemBuilder,
            childCount: videos!.length));
  }

  Center buildNoVideosFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Keine Videos gefunden",
              style: TextStyle(fontSize: 25),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ChannelUtil.getAllChannelImages(),
            ),
          ),
        ],
      ),
    );
  }
}
