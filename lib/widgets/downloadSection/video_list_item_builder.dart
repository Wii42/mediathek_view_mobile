import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ws/enum/channels.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/widgets/videolist/video_preview_adapter.dart';
import 'package:logging/logging.dart';

class VideoListItemBuilder {
  final Logger logger = Logger('VideoListView');

  // called when the user pressed on the remove button
  void Function(BuildContext, String?)? onRemoveVideo;

  List<Video>? videos = [];

  bool showDeleteButton;
  bool openDetailPage;

  void Function()? queryEntries;

  // for mean video list
  int? amountOfVideosFetched;
  int? totalResultSize;
  int? currentQuerySkip;
  final int pageThreshold = 25;

  VideoListItemBuilder(this.videos,
      {this.showDeleteButton = true,
      this.openDetailPage = true,
      this.queryEntries,
      this.amountOfVideosFetched,
      this.totalResultSize,
      this.currentQuerySkip,
      this.onRemoveVideo});

  Widget itemBuilder(BuildContext context, int index) {
    // only required for the main video list to request more entries when reaching end of list
    if (queryEntries != null) {
      if (index + pageThreshold > videos!.length) {
        queryEntries?.call();
      }

      if (currentQuerySkip! + pageThreshold >= totalResultSize! &&
          videos!.length == index + 1) {
        logger.info("ResultList - reached last position of result list.");
      } else if (videos!.length == index + 1) {
        logger.info("Reached last position in list for query");
        return Container(
            alignment: Alignment.center,
            width: 20.0,
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3.0));
      }
    }

    Video video = videos!.elementAt(index);

    String assetPath = Channels.channelMap.entries.firstWhere((entry) {
      return video.channel != null &&
              video.channel!.toUpperCase().contains(entry.key.toUpperCase()) ||
          entry.key.toUpperCase().contains(video.channel!.toUpperCase());
    }, orElse: () {
      logger.warning(
          "No channel found for video: ${video.title} with channel: ${video.channel}");
      return MapEntry("", "");
    }).value;

    Widget deleteButton = Container();
    if (showDeleteButton) {
      deleteButton = Positioned(
        top: 12.0,
        left: 5.0,
        child: getRemoveButton(index, context, video.id,
            video.size != null ? filesize(video.size) : null),
      );
    }
    return VideoPreviewAdapter(
      video,
      isVisible: true,
      openDetailPage: openDetailPage,
      defaultImageAssetPath: assetPath,
      presetAspectRatio: 16 / 9,
      overlayWidgets: [deleteButton],
    );
  }

  ActionChip getRemoveButton(
      int index, BuildContext context, String? id, String? filesize) {
    return ActionChip(
      avatar: Icon(Icons.delete_forever, color: Colors.white),
      label: Text(
        filesize != null && filesize.isNotEmpty
            ? "Löschen ($filesize)"
            : "Löschen",
        style: TextStyle(fontSize: 20.0),
      ),
      labelStyle: TextStyle(color: Colors.white),
      onPressed: () {
        if (showDeleteButton) {
          onRemoveVideo?.call(context, id);
        }
      },
      backgroundColor: Colors.green,
      elevation: 20,
      padding: EdgeInsets.all(10),
    );
  }
}
