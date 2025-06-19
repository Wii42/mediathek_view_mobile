import 'package:flutter/material.dart';
import 'package:flutter_ws/widgets/videolist/channel_thumbnail.dart';
import 'package:flutter_ws/widgets/videolist/meta_info_list_tile.dart';
import 'package:flutter_ws/widgets/videolist/video_preview_layout.dart';
import 'package:flutter_ws/widgets/videolist/video_widget.dart';
import 'package:shimmer/shimmer.dart';

class LoadingListPage extends StatelessWidget {
  const LoadingListPage({super.key});

  int determineNumberOfNeededTilesToFillScreen(
      BuildContext context, double listRowHeight) {
    double height = MediaQuery.of(context).size.height;
    // not filling whole available space
    return (height / listRowHeight).floor() - 1;
  }

  @override
  Widget build(BuildContext context) {
    int num = determineNumberOfNeededTilesToFillScreen(context, 130);

    return VideoPreviewLayout.getVideoListViewLayout(
        context,
        SliverChildBuilderDelegate(loadingVideoPreviewSkeleton,
            childCount: 10));
  }

  Widget loadingVideoPreviewSkeleton(BuildContext context, int index) {
    Widget dummyChannelThumbnail = withShimmer(getDummyChannelThumbnail());
    return VideoPreviewLayout(
        width: MediaQuery.of(context).size.width,
        thumbnailImage: withShimmer(Container(
            color: Colors.grey, constraints: BoxConstraints.expand())),
        videoInfoBottomBar: Container(
          color: VideoWidget.bottomBarBackgroundColor.withAlpha(177),
          child: MetaInfoListTile.infoListTileLayout(
              channelThumbnail: dummyChannelThumbnail,
              topicWidget: shimmerDummyText(width: 70, height: 10),
              titleWidget: shimmerDummyText(width: 230, height: 16),
              timestampWidget: shimmerDummyText(width: 50, height: 10),
              durationWidget: shimmerDummyText(width: 30, height: 8)),
        ),
        aspectRatio: 16 / 9);
  }

  Widget shimmerDummyText({required double width, required double height}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      color: Colors.grey,
      constraints: BoxConstraints.expand(width: width, height: height),
    );
  }

  Shimmer withShimmer(Widget cardContent) {
    return Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: cardContent);
  }

  static Widget getDummyChannelThumbnail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: ChannelThumbnail.thumbnailSize,
      height: ChannelThumbnail.thumbnailSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
    );
  }
}
