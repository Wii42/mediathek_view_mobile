import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

const ERROR_MSG_CAST_FAILED = "Cast zu Samsung TV fehlgeschlagen.";
const ERROR_GENERAL_CAST = "Es ist ein Fehler aufgetreten.";
const ERROR_MSG_CONNECTION_FAILED = "Verbindung zu Samsung TV fehlgeschlagen.";
const ERROR_MSG_TV_DISCOVERY_FAILED = "Suche nach Samsung TV's fehlgeschlagen.";
const ERROR_MSG_PLAY_FAILED = "Abspielen fehlgeschlagen.";

// SamsungTVCastManager has the platform channels to talk to the native iOS implementation for casting videos to supported Samsung TVs
class SamsungTVCastManager {
  final Logger logger = Logger('SamsungTvCastManager');
  late EventChannel _tvFoundEventChannel;
  late EventChannel _tvLostEventChannel;
  late EventChannel _tvReadinessEventChannel;
  late EventChannel _tvPlayerEventChannel;
  late EventChannel _tvPlaybackPositionEventChannel;

  late MethodChannel _methodChannel;
  Stream<dynamic>? _foundTvsStream;
  Stream<dynamic>? _lostTvsStream;
  Stream<dynamic>? _tvReadinessStream;
  Stream<dynamic>? _tvPlayerStream;
  Stream<dynamic>? _tvPlaybackPositionStream;

  SamsungTVCastManager() {
    _methodChannel =
        const MethodChannel('com.mediathekview.mobile/samsungTVCast');
    _tvFoundEventChannel =
        const EventChannel('com.mediathekview.mobile/samsungTVFound');
    _tvLostEventChannel =
        const EventChannel('com.mediathekview.mobile/samsungTVLost');
    _tvReadinessEventChannel =
        const EventChannel('com.mediathekview.mobile/samsungTVReadiness');
    _tvPlayerEventChannel =
        const EventChannel('com.mediathekview.mobile/samsungTVPlayer');
    _tvPlaybackPositionEventChannel = const EventChannel(
        'com.mediathekview.mobile/samsungTVPlaybackPosition');
  }

  Future startTVDiscovery() async {
    try {
      Map<String, String> requestArguments = {};
      await _methodChannel.invokeMethod('startDiscovery', requestArguments);
    } on PlatformException catch (e) {
      logger.severe(
          "Starting samsung tv discovery failed. Reason $e");
    } on MissingPluginException catch (e) {
      logger.severe("Starting samsung tv discovery failed. Missing Plugin: $e");
    }
  }

  Future stopTVDiscovery() async {
    try {
      Map<String, String> requestArguments = {};
      await _methodChannel.invokeMethod('stopDiscovery', requestArguments);
    } on PlatformException catch (e) {
      logger.severe(
          "Stopping samsung tv discovery failed. Reason $e");
    } on MissingPluginException catch (e) {
      logger.severe("Stopping samsung tv discovery failed. Missing Plugin: $e");
    }
  }

  void checkIfTvIsSupported(String tvName) async {
    Map<String, String> requestArguments = {};
    requestArguments.putIfAbsent("tvName", () => tvName);

    try {
      await _methodChannel.invokeMethod('check', requestArguments);
    } on PlatformException catch (e) {
      logger.severe(
          "Starting samsung tv readiness check failed. Reason $e");
    } on MissingPluginException catch (e) {
      logger.severe(
          "Starting samsung tv readiness check failed. Missing Plugin: $e");
    }
  }

  Future play(String? videoUrl, String? title, Duration startingPosition) async {
    Map<String, String?> requestArguments = {};
    // has to be url accessible from internet (do not support downloaded videos)
    requestArguments.putIfAbsent("url", () => videoUrl);
    requestArguments.putIfAbsent("title", () => title);
    requestArguments.putIfAbsent(
        "startingPosition", () => startingPosition.inMilliseconds.toString());

    try {
      _methodChannel.invokeMethod('play', requestArguments);
    } on PlatformException catch (e) {
      logger
          .severe("Playing video on Samsung TV failed. Reason $e");
    } on MissingPluginException catch (e) {
      logger.severe("Playing video on Samsung TV failed. Missing Plugin: $e");
    }
  }

  Future seekTo(Duration seek) async {
    Map<String, String> requestArguments = {};
    requestArguments.putIfAbsent(
        "seekTo", () => seek.inMilliseconds.toString());

    try {
      await _methodChannel.invokeMethod('seekTo', requestArguments);
    } on PlatformException catch (e) {
      logger.severe(
          "Seeking to video position on Samsung TV failed $e");
    } on MissingPluginException catch (e) {
      logger.severe(
          "Seeking to video position on Samsung TV failed. Missing Plugin: $e");
    }
  }

  Future pause() async {
    Map<String, String> requestArguments = {};
    try {
      await _methodChannel.invokeMethod('pause', requestArguments);
    } on PlatformException catch (e) {
      logger.severe("Pausing video on Samsung TV failed $e");
    } on MissingPluginException catch (e) {
      logger.severe("Pausing video on Samsung TV failed. Missing Plugin: $e");
    }
  }

  Future disconnect() async {
    Map<String, String> requestArguments = {};
    try {
      await _methodChannel.invokeMethod('disconnect', requestArguments);
    } on PlatformException catch (e) {
      logger.severe("Disconnecting from Samsung TV failed $e");
    } on MissingPluginException catch (e) {
      logger.severe("Disconnecting from Samsung TV failed. Missing Plugin: $e");
    }
  }

  Future stop() async {
    Map<String, String> requestArguments = {};
    try {
      await _methodChannel.invokeMethod('stop', requestArguments);
    } on PlatformException catch (e) {
      logger.severe("Stopping video on Samsung TV failed $e");
    } on MissingPluginException catch (e) {
      logger.severe("Stopping video on Samsung TV failed. Missing Plugin: $e");
    }
  }

  Future resume() async {
    Map<String, String> requestArguments = {};
    try {
      _methodChannel.invokeMethod('resume', requestArguments);
    } on PlatformException catch (e) {
      logger.severe("Resuming video on Samsung TV failed $e");
    } on MissingPluginException catch (e) {
      logger.severe("Resuming video on Samsung TV failed. Missing Plugin: $e");
    }
  }

  Future mute() async {
    Map<String, String> requestArguments = {};
    try {
      _methodChannel.invokeMethod('mute', requestArguments);
    } on PlatformException catch (e) {
      logger.severe("Muting video on Samsung TV failed $e");
    } on MissingPluginException catch (e) {
      logger.severe(
          "Muting video on Samsung TV failed. Missing Plugin: $e");
    }
  }

  Future unmute() async {
    Map<String, String> requestArguments = {};
    try {
      _methodChannel.invokeMethod('unmute', requestArguments);
    } on PlatformException catch (e) {
//      SnackbarActions.showError(ctx, ERROR_GENERAL_CAST);
      logger.severe("Unmuting video on Samsung TV failed $e");
    } on MissingPluginException catch (e) {
//      SnackbarActions.showError(ctx, ERROR_GENERAL_CAST);
      logger.severe("Unmuting video on Samsung TV failed. Missing Plugin: $e");
    }
  }

  Stream<dynamic>? getFoundTVStream() {
    _foundTvsStream ??= _tvFoundEventChannel.receiveBroadcastStream();
    return _foundTvsStream;
  }

  Stream<dynamic>? getLostTVStream() {
    _lostTvsStream ??= _tvLostEventChannel.receiveBroadcastStream();
    return _lostTvsStream;
  }

  Stream<dynamic>? getTvReadinessStream() {
    _tvReadinessStream ??= _tvReadinessEventChannel.receiveBroadcastStream();
    return _tvReadinessStream;
  }

  Stream<dynamic>? getTvPlayerStream() {
    _tvPlayerStream ??= _tvPlayerEventChannel.receiveBroadcastStream();
    return _tvPlayerStream;
  }

  Stream<dynamic>? getTvPlaybackPositionStream() {
    _tvPlaybackPositionStream ??= _tvPlaybackPositionEventChannel.receiveBroadcastStream();
    return _tvPlaybackPositionStream;
  }
}
