import 'package:flutter/material.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/util/timestamp_calculator.dart';

import 'channel_thumbnail.dart';
import 'loading_list_view.dart';

class MetaInfoListTile extends StatelessWidget {
  final TextTheme textTheme;
  final Duration? duration;
  final String title;
  final String? topic;
  final DateTime? timestamp;
  final String assetPath;
  final bool isDownloaded;
  final int? titleMaxLines;

  const MetaInfoListTile(
      {super.key,
      required this.textTheme,
      this.duration,
      required this.title,
      this.topic,
      this.timestamp,
      required this.assetPath,
      this.isDownloaded = false,
      this.titleMaxLines});

  @override
  Widget build(BuildContext context) {
    return infoListTileLayout(
      channelThumbnail: assetPath.isNotEmpty
          ? ChannelThumbnail(assetPath, isDownloaded)
          : LoadingListPage.getDummyChannelThumbnail(),
      topicWidget: (topic != null && topic!.isNotEmpty)
          ? Text(
              topic!,
              style: textTheme.titleLarge?.copyWith(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      titleWidget: Text(
        title,
        style: textTheme.titleMedium?.copyWith(color: Colors.white),
        maxLines: titleMaxLines,
        overflow: titleMaxLines != null
            ? TextOverflow.ellipsis
            : TextOverflow.visible,
      ),
      timestampWidget: Text(
        timestamp != null ? Calculator.calculateTimestamp(timestamp!) : "",
        style: textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      durationWidget: Text(
        duration != null ? Calculator.calculateDuration(duration!) : "",
        style: videoMetadataTextStyle.copyWith(color: Colors.white),
      ),
    );
  }

  static Widget infoListTileLayout({
    required Widget channelThumbnail,
    Widget? topicWidget,
    required Widget titleWidget,
    required Widget timestampWidget,
    required Widget durationWidget,
  }) {
    return ListTile(
      leading: channelThumbnail,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (topicWidget != null) topicWidget,
          titleWidget,
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [timestampWidget, durationWidget],
      ),
    );
  }
}
