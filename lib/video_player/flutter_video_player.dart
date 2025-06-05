import 'dart:io';

import 'package:countly_flutter/countly_flutter.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ws/database/database_manager.dart';
import 'package:flutter_ws/database/video_entity.dart';
import 'package:flutter_ws/database/video_progress_entity.dart';
import 'package:flutter_ws/global_state/list_state_container.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/video_player/custom_chewie_player.dart';
import 'package:flutter_ws/video_player/custom_video_controls.dart';
import 'package:logging/logging.dart';
import 'package:video_player/video_player.dart';

import 'tv_player_controller.dart';

class FlutterVideoPlayer extends StatefulWidget {
  final Video initialVideo;
  final VideoEntity? initialVideoEntity;
  final VideoProgressEntity? initialProgressEntity;
  final AppState appSharedState;

  final Logger logger = Logger('FlutterVideoPlayer');

  FlutterVideoPlayer(BuildContext context, this.appSharedState,
      this.initialVideo, this.initialVideoEntity, this.initialProgressEntity,
      {super.key});

  DatabaseManager get databaseManager => appSharedState.databaseManager;

  String? get videoId => initialVideo.id ?? initialVideoEntity?.id;

  bool get isInitiallyPlayingDifferentVideoOnTV =>
      (appSharedState.isCurrentlyPlayingOnTV &&
          videoId != appSharedState.tvCurrentlyPlayingVideo!.id);

  @override
  State<FlutterVideoPlayer> createState() => _FlutterVideoPlayerState();
}

class _FlutterVideoPlayerState extends State<FlutterVideoPlayer> {
  String? videoUrl;

  // castNewVideoToTV indicates that the currently playing video on the TV
  // should be replaced
  bool castNewVideoToTV = false;
  static VideoPlayerController? videoController;
  static TvPlayerController? tvVideoController;
  late CustomChewieController chewieController;
  late Video video;
  late VideoEntity? videoEntity;
  late VideoProgressEntity? progressEntity;
  late bool isAlreadyPlayingDifferentVideoOnTV;

  @override
  void initState() {
    video = widget.initialVideo;
    videoEntity = widget.initialVideoEntity;
    progressEntity = widget.initialProgressEntity;
    isAlreadyPlayingDifferentVideoOnTV =
        widget.isInitiallyPlayingDifferentVideoOnTV;
    videoUrl = getVideoUrl(widget.initialVideo, widget.initialVideoEntity);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isAlreadyPlayingDifferentVideoOnTV) {
      return _showDialog(context);
    }
    initVideoPlayerController();
    initTvVideoController();
    initChewieController();
    return PiPSwitcher(
        childWhenEnabled: CustomChewie(
          controller: chewieController,
          showControls: false,
        ),
        childWhenDisabled: Scaffold(
            backgroundColor: Colors.black,
            body: CustomChewie(
              controller: chewieController,
              showControls: true,
            )));
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? getVideoUrl(Video? video, VideoEntity? entity) {
    if (video != null) {
      if (video.url_video_hd != null &&
          video.url_video_hd!.toString().isNotEmpty) {
        return video.url_video_hd.toString();
      } else {
        return video.url_video.toString();
      }
    } else {
      if (entity!.url_video_hd != null && entity.url_video_hd!.isNotEmpty) {
        return entity.url_video_hd;
      } else {
        return entity.url_video;
      }
    }
  }

  void initTvVideoController() {
    tvVideoController = TvPlayerController(
      widget.appSharedState.availableTvs,
      widget.appSharedState.samsungTVCastManager,
      widget.appSharedState.databaseManager,
      videoUrl,
      widget.initialVideo ?? Video.fromJson(widget.initialVideoEntity!.toMap()),
      widget.initialProgressEntity != null
          ? Duration(milliseconds: widget.initialProgressEntity!.progress!)
          : Duration(milliseconds: 0),
    );

    if (widget.appSharedState.targetPlatform == TargetPlatform.android) {
      tvVideoController!.startTvDiscovery();
    }

    // replace the currently playing video on TV
    if (widget.appSharedState.isCurrentlyPlayingOnTV && castNewVideoToTV) {
      widget.appSharedState.samsungTVCastManager.stop();
      tvVideoController!.initialize();
      tvVideoController!.startPlayingOnTV();
      return;
    }

    // case: do not replace the currently playing video on TV
    if (widget.appSharedState.isCurrentlyPlayingOnTV) {
      tvVideoController!.initialize();
    }
  }

  void initVideoPlayerController() {
    if (videoController != null) {
      videoController!.dispose();
    }
    // always use network datasource if should be casted to TV
    // TV needs accessible video URL
    if (widget.initialVideoEntity == null ||
        widget.appSharedState.isCurrentlyPlayingOnTV) {
      videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl!),
      );

      Countly.instance.events.recordEvent("PLAY_VIDEO_NETWORK", null, 1);

      return;
    }

    String path;
    if (widget.appSharedState.targetPlatform == TargetPlatform.android) {
      path =
          "${widget.initialVideoEntity!.filePath!}/${widget.initialVideoEntity!.fileName!}";
    } else {
      path =
          "${widget.appSharedState.localDirectory!.path}/MediathekView/${widget.initialVideoEntity!.fileName!}";
    }

    Uri videoUri = Uri.file(path);

    File file = File.fromUri(videoUri);
    file.exists().then(
      (exists) {
        if (!exists) {
          widget.logger.severe(
              "Cannot play video from file. File does not exist: ${file.uri}");
          videoController = VideoPlayerController.networkUrl(
            Uri.parse(videoUrl!),
          );
        }
      },
    );

    Countly.instance.events.recordEvent("PLAY_VIDEO_DOWNLOADED", null, 1);

    videoController = VideoPlayerController.file(file);
  }

  void initChewieController() {
    chewieController = CustomChewieController(
      context: context,
      videoPlayerController: videoController!,
      tvPlayerController: tvVideoController,
      looping: false,
      startAt: tvVideoController!.startAt,
      customControls: CustomVideoControls(
          backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
          iconColor: Color(0xffffbf00)),
      fullScreenByDefault: true,
      allowedScreenSleep: false,
      allowPictureInPicture: false,
      isCurrentlyPlayingOnTV: widget.appSharedState.isCurrentlyPlayingOnTV,
      video: widget.initialVideo,
      aspectRatio: Rational(16, 9),
      //systemOverlaysAfterFullScreen: []
    ); // != null
    //? widget.video
    //: Video.fromMap(widget.videoEntity!.toMap()));
  }

  AlertDialog _showDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[800],
      title: Text('Fernseher Verbunden',
          style: TextStyle(color: Colors.white, fontSize: 18.0)),
      content: Text('Soll die aktuelle TV Wiedergabe unterbrochen werden?',
          style: TextStyle(color: Colors.white, fontSize: 16.0)),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Nein'),
          onPressed: () async {
            isAlreadyPlayingDifferentVideoOnTV = false;
            // replace widget.video with the currently playing video
            // to not interrupt the video playback
            video = widget.appSharedState.tvCurrentlyPlayingVideo!;

            // get the video entity
            videoEntity = await widget.appSharedState.databaseManager
                .getDownloadedVideo(widget.videoId);

            // get the video progress
            progressEntity = await widget.appSharedState.databaseManager
                .getVideoProgressEntity(widget.initialVideo.id);

            // start initializing players with the video playing on the TV
            setState(() {});
          },
        ),
        ElevatedButton(
          child: const Text('Ja'),
          onPressed: () {
            widget.appSharedState.samsungTVCastManager.stop();

            setState(() {
              isAlreadyPlayingDifferentVideoOnTV = false;
              castNewVideoToTV = true;
            });
          },
        )
      ],
    );
  }
}
