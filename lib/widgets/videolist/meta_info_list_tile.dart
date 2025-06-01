import 'package:flutter/material.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/util/timestamp_calculator.dart';

import 'channel_thumbnail.dart';

class MetaInfoListTile {
  static ListTile getVideoMetaInformationListTile(
      BuildContext context,
      Duration? duration,
      String title,
      DateTime? timestamp,
      String assetPath,
      bool isDownloaded,
      {int? titleMaxLines}) {
    return ListTile(
      trailing: Text(
        duration != null ? Calculator.calculateDuration(duration) : "",
        style: videoMetadataTextStyle.copyWith(color: Colors.white),
      ),
      leading: assetPath.isNotEmpty
          ? ChannelThumbnail(assetPath, isDownloaded)
          : null,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Colors.white),
        maxLines: titleMaxLines,
        overflow: titleMaxLines != null
            ? TextOverflow.ellipsis
            : TextOverflow.visible,
      ),
      subtitle: Text(
        timestamp != null ? Calculator.calculateTimestamp(timestamp) : "",
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
