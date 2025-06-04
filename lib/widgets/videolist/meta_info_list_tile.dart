import 'package:flutter/material.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/util/timestamp_calculator.dart';

import 'channel_thumbnail.dart';

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
    return ListTile(
      leading: assetPath.isNotEmpty
          ? ChannelThumbnail(assetPath, isDownloaded)
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (topic != null && topic!.isNotEmpty)
            Text(
              topic!,
              style: textTheme.titleLarge?.copyWith(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
            timestamp != null ? Calculator.calculateTimestamp(timestamp!) : "",
            style: textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          Text(
            duration != null ? Calculator.calculateDuration(duration!) : "",
            style: videoMetadataTextStyle.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
