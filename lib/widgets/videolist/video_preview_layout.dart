import 'package:flutter/material.dart';

import '../../util/cross_axis_count.dart';

class VideoPreviewLayout extends StatelessWidget {
  static const Radius cornerClipping = Radius.circular(10.0);
  final double width;
  final Widget thumbnailImage;
  final Widget videoInfoBottomBar;
  final List<Widget> overlayWidgets;

  /// Optional gesture detector to wrap the the preview widget.
  final Widget Function(Widget)? gestureDetector;
  final double aspectRatio;

  const VideoPreviewLayout({
    super.key,
    required this.width,
    required this.thumbnailImage,
    required this.videoInfoBottomBar,
    this.overlayWidgets = const [],
    this.gestureDetector,
    required this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Column is needed for correct padding of the widget
        ClipRRect(
          borderRadius: BorderRadius.all(cornerClipping),
          child: Container(
            color: Colors.grey[100],
            width: width,
            child: gestureDetector != null
                ? gestureDetector!(videoWidget())
                : videoWidget(),
          ),
        ),
      ]),
    );
  }

  Widget videoWidget() {
    //Always fill full width & calc height accordingly
    double totalWidth = width - 36.0; //Intendation: 28 left, 8 right

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: SizedBox(
        width: totalWidth,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.passthrough,
          children: [
            thumbnailImage,
            Positioned(
                bottom: 0, left: 0.0, right: 0.0, child: videoInfoBottomBar),
            ...overlayWidgets,
          ],
        ),
      ),
    );
  }

  static Widget getVideoListViewLayout(
      BuildContext context, SliverChildDelegate videoListItemBuilder) {
    int crossAxisCount = CrossAxisCount.getCrossAxisCount(context);

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 16 / 9,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
      ),
      delegate: videoListItemBuilder,
    );
  }
}
