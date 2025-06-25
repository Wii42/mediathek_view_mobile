import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ws/enum/tv_player_status.dart';
import 'package:flutter_ws/enum/tv_status.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/platform_channels/samsung_tv_cast_manager.dart';
import 'package:logging/logging.dart';

import '../global_state/video_progress_state.dart';
import 'tv_video_player_value.dart';

class TvPlayerController extends ValueNotifier<TvVideoPlayerValue> {
  final Logger logger = Logger('TVPlayerController');
  bool _isDisposed = false;

  SamsungTVCastManager samsungTVCastManager;
  VideoProgressState videoProgressState;

  /// The URI to the video file.
  final Uri? dataSource;
  final Video video;
  Duration startAt;
  static bool playRequestSend = false;

  // subscriptions
  static StreamSubscription<dynamic>? tvConnectionSubscription;
  static StreamSubscription<dynamic>? tvPlayerSubscription;
  static StreamSubscription<dynamic>? tvPlaybackPositionSubscription;

  static StreamSubscription<dynamic>? foundTVsSubscription;
  static StreamSubscription<dynamic>? lostTVsSubscription;

  TvPlayerController(
    List<String> availableTvs,
    this.samsungTVCastManager,
    this.videoProgressState,
    this.dataSource,
    this.video,
    this.startAt,
  ) : super(TvVideoPlayerValue(position: startAt, availableTvs: availableTvs));

  // start listening for TVs (active during the whole player lifetime
  // even though not connected to TV: this is to show available TVs right away).
  void startTvDiscovery() {
    logger.info("START TV DISCOVERY");
    listenToFoundTVStream();
    listenToLostTvStream();
    samsungTVCastManager.startTVDiscovery();
  }

  // stop listening for discovered Tvs
  void stopTvDiscovery() async {
    logger.info("STOP TV DISCOVERY");
    await foundTVsSubscription?.cancel();
    foundTVsSubscription = null;

    await lostTVsSubscription?.cancel();
    lostTVsSubscription = null;

    samsungTVCastManager.stopTVDiscovery();
  }

  // initialize sets up event channel listeners to listen to events from the TV player
  void initialize() {
    /*if (isListeningToPlatformChannels()) {
      return;
    } */
    logger.info("LISTENING TO STREAMS");
    listenToConnectionStream();
    listenToTVPlayerStream();
    listenToTVPlaybackPosition();
  }

  @override
  Future<void> dispose() async {
    logger.info("Disposing TV player controller");
    _isDisposed = true;
    stopListeningToStreams();
    stopTvDiscovery();
    super.dispose();
  }

  void stopListeningToStreams() async {
    logger.info("STOP LISTENING TO STREAMS");
    await tvConnectionSubscription?.cancel();
    tvConnectionSubscription = null;

    await tvPlayerSubscription?.cancel();
    tvPlayerSubscription = null;

    await tvPlaybackPositionSubscription?.cancel();
    tvPlaybackPositionSubscription = null;
  }

  void _updatePosition(Duration position) {
    value = value.copyWith(position: position);
  }

  /// Starts playing the video on the TV
  Future<void> resume() async {
    if (_isDisposed || !value.playbackOnTvStarted) {
      return;
    }
    value = value.copyWith(isPlaying: true);
    await samsungTVCastManager.resume();
  }

  /// Pauses the video.
  Future<void> pause() async {
    if (_isDisposed || !value.playbackOnTvStarted) {
      return;
    }

    value = value.copyWith(isPlaying: false);
    await samsungTVCastManager.pause();
  }

  /// Stops the playback.
  Future<void> disconnect() async {
    if (_isDisposed || !value.playbackOnTvStarted) {
      logger.info("Cannot send stop command to TV");
      return;
    }

    await samsungTVCastManager.disconnect();
  }

  // playOnTV is used to initially start the video on the TV (use resume after initial start)
  Future<void> startPlayingOnTV({Duration? startingPosition}) async {
    if (_isDisposed) {
      return;
    }

    if (playRequestSend == true) {
      logger.info("PLAY REQUEST ALREADY SEND");
      return;
    }

    playRequestSend = true;
    if (startingPosition != null) {
      startAt = startingPosition;
    }
    samsungTVCastManager.play(
      dataSource,
      video.title,
      startAt,
    );
  }

  /// Sets the video's current timestamp to be at [moment]. The next
  /// time the video is played it will resume from the given [moment].
  ///
  /// If [moment] is outside of the video's full range it will be automatically
  /// and silently clamped.
  Future<void> seekTo(Duration position) async {
    if (_isDisposed || !value.playbackOnTvStarted) {
      return;
    }
    await samsungTVCastManager.seekTo(position);
    _updatePosition(position);
  }

  /// Mutes the TV
  Future<void> mute() async {
    if (_isDisposed || !value.playbackOnTvStarted) {
      return;
    }
    value = value.copyWith(volume: 0);
    samsungTVCastManager.mute();
  }

  /// Unmutes the TV
  Future<void> unmute(double volume) async {
    if (_isDisposed || !value.playbackOnTvStarted) {
      return;
    }
    value = value.copyWith(volume: volume);
    samsungTVCastManager.unmute();
  }

  bool isListeningToPlatformChannels() {
    return tvConnectionSubscription != null ||
        tvPlayerSubscription != null ||
        tvPlaybackPositionSubscription != null;
  }

  // listenToConnectionStream listens to connection updates and changes the value
  // listeners should react according to the connection update
  void listenToConnectionStream() {
    try {
      var tvReadinessStream = samsungTVCastManager.getTvReadinessStream()!;
      tvConnectionSubscription = tvReadinessStream.listen((raw) {
        String connectionStatus = raw['status'];
        TvStatus? tvStatus = TvStatus.tryFromString(connectionStatus);
        String tvName = raw['name'];
        if (tvStatus == null) {
          logger.warning(
              "Samsung TV connection status event channel returned an unknown status: $connectionStatus for TV $tvName");
          return;
        }
        logger.info(
            "Samsung TV: received connection status $connectionStatus for TV $tvName");
        switch (tvStatus) {
          case TvStatus.isSupported:
            {
              value = value.copyWith(tvStatus: TvStatus.isSupported);
            }
            break;
          case TvStatus.currentlyChecking:
            {
              value = value.copyWith(tvStatus: TvStatus.currentlyChecking);
            }
            break;
          case TvStatus.unsupported:
            {
              value = value.copyWith(
                  tvStatus: TvStatus.unsupported,
                  errorDescription: "Fernseher ist nicht unterstützt");
            }
          case TvStatus.notYetChecked:
            break;
        }
      }, onError: (e) {
        logger.severe("Samsung TV connection status returned an error: $e");
      }, onDone: () {
        logger.info("Samsung TV connection status event channel is done.");
      }, cancelOnError: false);

      if (tvConnectionSubscription!.isPaused) {
        logger.info("Samsung TV connection status is paused.");
      }
    } catch (MissingPluginException) {
      logger.info("Samsung TV connection status: Missing Plugin Exception.");
      return;
    }
  }

  void listenToTVPlayerStream() {
    try {
      var stream = samsungTVCastManager.getTvPlayerStream()!;
      tvPlayerSubscription = stream.listen((raw) {
        String playerStatusString = raw['status'];
        TvPlayerStatus? playerStatus =
            TvPlayerStatus.tryFromString(playerStatusString);
        if (playerStatus == null) {
          logger.warning(
              "Samsung TV player event channel returned an unknown status: $playerStatusString");
          return;
        }
        logger.info("Samsung TV: status: $playerStatusString");
        // reset, to be able to send another play request
        playRequestSend = false;
        switch (playerStatus) {
          case TvPlayerStatus.playing:
            {
              value = value.copyWith(playbackOnTvStarted: true);
            }
            break;
          case TvPlayerStatus.paused:
            {
              value = value.copyWith(isPlaying: false);
            }
            break;
          case TvPlayerStatus.disconnected:
            {
              value = value.copyWith(
                  isPlaying: false,
                  playbackOnTvStarted: false,
                  isDisconnected: true,
                  isStopped: false);
              stopListeningToStreams();
            }
            break;
          case TvPlayerStatus.stopped:
            {
              value = value.copyWith(isPlaying: false, isStopped: true);
            }
          case TvPlayerStatus.muted:
            break;
          case TvPlayerStatus.unmuted:
            break;
        }
      }, onError: (e) {
        logger.severe("Samsung TV  player event channel returned an error: $e");
      }, onDone: () {
        logger.info("Samsung TV connection status event channel is done.");
      }, cancelOnError: false);

      if (tvPlayerSubscription!.isPaused) {
        logger.info("Samsung TV player event channel is paused.");
      }
    } catch (MissingPluginException) {
      logger.info("Samsung TV player event channel: Missing Plugin Exception.");
      return;
    }
  }

  void listenToTVPlaybackPosition() async {
    try {
      var stream = samsungTVCastManager.getTvPlaybackPositionStream()!;
      tvPlaybackPositionSubscription = stream.listen((raw) {
        int playbackPosition = raw['playbackPosition'];
        logger.info("Samsung TV video playback position $playbackPosition");

        // insert position
        videoProgressState.updatePlaybackPosition(video.toVideoProgressEntity(),
            Duration(milliseconds: playbackPosition));

        value = value.copyWith(
            playbackOnTvStarted: true,
            isPlaying: true,
            position: Duration(milliseconds: playbackPosition));
      }, onError: (e) {
        logger.severe(
            "Samsung TV video playback position event channel returned an error: $e");
      }, onDone: () {
        logger.info(
            "Samsung TV video playback position status event channel is done.");
      }, cancelOnError: false);

      if (tvPlaybackPositionSubscription!.isPaused) {
        logger.info(
            "Samsung TV video playback position event channel is paused.");
      }
    } catch (MissingPluginException) {
      logger.info(
          "Samsung TV video playback position event channel: Missing Plugin Exception.");
      return;
    }
  }

  void listenToFoundTVStream() {
    try {
      var stream = samsungTVCastManager.getFoundTVStream()!;
      foundTVsSubscription = stream.listen((raw) {
        String tvName = raw['name'];
        logger.info("discovered TV with name $tvName");
        if (!value.availableTvs.contains(tvName)) {
          List<String> avail = [];
          avail.addAll(value.availableTvs);
          avail.add(tvName);
          value = value.copyWith(availableTvs: avail);
        }
      }, onError: (e) {
        logger
            .severe("Samsung TV discovery - found TV's returned an error: $e");
      }, onDone: () {
        logger.info("Samsung TV discovery (found) event channel is done.");
      }, cancelOnError: false);

      if (foundTVsSubscription!.isPaused) {
        logger.info("Samsung TV discovery (found) is paused.");
      }
    } catch (MissingPluginException) {
      logger.info("Samsung TV discovery (found): Missing Plugin Exception.");
      return;
    }
  }

  void listenToLostTvStream() {
    try {
      var stream = samsungTVCastManager.getLostTVStream()!;
      lostTVsSubscription = stream.listen((raw) {
        String tvName = raw['name'];
        logger.info("lost TV with name $tvName");
        if (value.availableTvs.contains(tvName)) {
          List<String> avail = [];
          avail.addAll(value.availableTvs);
          avail.remove(tvName);
          value = value.copyWith(availableTvs: avail);
        }
      }, onError: (e) {
        logger.severe("Samsung TV discovery - lost TV's returned an error: $e");
      }, onDone: () {
        logger.info("Samsung TV discovery (lost) event channel is done.");
      }, cancelOnError: true);

      if (lostTVsSubscription!.isPaused) {
        logger.info("Samsung TV discovery (lost) is paused.");
      }
    } catch (MissingPluginException) {
      logger.info("Samsung TV discovery (lost): Missing Plugin Exception.");
      return;
    }
  }
}
