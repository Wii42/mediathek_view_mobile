import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ws/global_state/app_state.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/util/show_snackbar.dart';
import 'package:flutter_ws/video_player/flutter_video_player.dart';
import 'package:http/http.dart' as http;

import '../../../drift_database/app_database.dart' show VideoEntity;

const ERROR_MSG_NOT_AVAILABLE = "Video nicht verfügbar";
const ERROR_MSG_NO_INTERNET = "Keine Internet Verbindung";
const ERROR_MSG_FAILED_PLAYING = "Abspielen fehlgeschlagen.";
const ERROR_MSG_DOWNLOAD_FAILED = "Download fehlgeschlagen";

class Util {
  static Future<bool> playVideoPreChecks(
      BuildContext context, VideoEntity? entity, Video? video) async {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    if (entity == null) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        SnackbarActions.showError(scaffoldMessenger, ERROR_MSG_NO_INTERNET);
        return false;
      }
    }

    //  video has been removed from the Mediathek already
    if (entity == null && video != null && video.url_video != null) {
      final response = await http.head(video.url_video!);

      if (response.statusCode >= 300) {
        String? detailedError = switch (response.statusCode) {
          404 => "Video nicht gefunden",
          403 => "Zugriff verweigert",
          429 => "Zu viele Anfragen, bitte später erneut versuchen",
          _ => null
        };
        String fullErrorMessage = detailedError != null
            ? "$ERROR_MSG_NOT_AVAILABLE: $detailedError"
            : ERROR_MSG_NOT_AVAILABLE;
        SnackbarActions.showError(scaffoldMessenger, fullErrorMessage);
        return false;
      }
    }

    if (video == null && entity == null) {
      SnackbarActions.showError(scaffoldMessenger, ERROR_MSG_FAILED_PLAYING);
      return false;
    }
    return true;
  }

  static Future<Object?> playVideoHandler(BuildContext context,
      AppState appState, VideoEntity? entity, Video video) async {
    NavigatorState navigator = Navigator.of(context);
    // only check for internet connection when video is not downloaded
    bool preChecksSuccessful =
        await Util.playVideoPreChecks(context, entity, video);
    if (!preChecksSuccessful) {
      return null;
    }

    return navigator.push(MaterialPageRoute(
        builder: (BuildContext context) {
          return FlutterVideoPlayer(appState, video, entity);
        },
        settings: RouteSettings(name: "VideoPlayer"),
        fullscreenDialog: false));
  }
}
