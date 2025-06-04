import 'package:flutter/material.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/util/timestamp_calculator.dart';

import 'channel_thumbnail.dart';

class MetaInfoListTile {
  static ListTile getVideoMetaInformationListTile(
      {required TextTheme textTheme,
      Duration? duration,
      required String title,
      String? topic,
      DateTime? timestamp,
      required String assetPath,
      bool isDownloaded = false,
      int? titleMaxLines}) {
    return ListTile(
      leading: assetPath.isNotEmpty
          ? ChannelThumbnail(assetPath, isDownloaded)
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (topic != null && topic.isNotEmpty)
            Text(
              topic,
              style: textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(color: Colors.white),
            maxLines: titleMaxLines,
            overflow: titleMaxLines != null
                ? TextOverflow.ellipsis
                : TextOverflow.visible,
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            timestamp != null ? Calculator.calculateTimestamp(timestamp) : "",
            style: textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          Text(
            duration != null ? Calculator.calculateDuration(duration) : "",
            style: videoMetadataTextStyle.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
