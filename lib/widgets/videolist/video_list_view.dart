import 'package:flutter/material.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/util/channel_util.dart';
import 'package:flutter_ws/util/cross_axis_count.dart';
import 'package:flutter_ws/widgets/downloadSection/video_list_item_builder.dart';
import 'package:flutter_ws/widgets/videolist/loading_list_view.dart';
import 'package:logging/logging.dart';

class VideoListView extends StatefulWidget {
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
  State<VideoListView> createState() => _VideoListViewState();
}

class _VideoListViewState extends State<VideoListView> {
  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.logger.info("Rendering Main Video List with list length ${widget.videos!.length}");

    if (widget.videos!.isEmpty && widget.amountOfVideosFetched == 0) {
      widget.logger.info("No Videos found");
      return SliverToBoxAdapter(child: buildNoVideosFound());
    } else if (widget.videos!.isEmpty) {
      widget.logger.info("Searching: video list length : 0 & amountFetched: ${widget.amountOfVideosFetched}");
      return SliverToBoxAdapter(child: LoadingListPage());
    }

    // do not request previews in the main download section if it is a tablet
    // do not overload CPU
    //bool previewNotDownloadedVideos = !DeviceInformation.isTablet(context);

    var videoListItemBuilder = VideoListItemBuilder.name(
        widget.videos, true, false, true,
        queryEntries: widget.queryEntries,
        amountOfVideosFetched: widget.amountOfVideosFetched,
        totalResultSize: widget.totalResultSize,
        currentQuerySkip: widget.currentQuerySkip);

    int crossAxisCount = CrossAxisCount.getCrossAxisCount(context);

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 16 / 9,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 5.0,
      ),
      delegate: SliverChildBuilderDelegate(videoListItemBuilder.itemBuilder,
          childCount: widget.videos!.length),
    );
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
          Container(
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
