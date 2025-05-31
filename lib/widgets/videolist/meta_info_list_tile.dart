import 'package:flutter/material.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/util/timestamp_calculator.dart';

import 'channel_thumbnail.dart';

class MetaInfoListTile {
  static ListTile getVideoMetaInformationListTile(
      BuildContext context,
      String? duration,
      String title,
      DateTime? timestamp,
      String assetPath,
      bool isDownloaded) {
    return ListTile(
      trailing: Text(
        duration != null ? Calculator.calculateDuration(duration) : "",
        style: videoMetadataTextStyle.copyWith(color: Colors.white),
      ),
      leading: assetPath.isNotEmpty
          ? ChannelThumbnail(assetPath, isDownloaded)
          : Container(),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Colors.white),
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
