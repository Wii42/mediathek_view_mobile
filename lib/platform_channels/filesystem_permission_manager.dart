import 'dart:async';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class FilesystemPermissionManager {
  final Logger logger = Logger('FilesystemPermissionManager');
  late EventChannel _eventChannel;
  late MethodChannel _methodChannel;
  Stream<dynamic>? _updateStream;
  StreamSubscription<dynamic>? streamSubscription;

  FilesystemPermissionManager() {
    _eventChannel =
        const EventChannel('com.mediathekview.mobile/permissionEvent');
    _methodChannel = const MethodChannel('com.mediathekview.mobile/permission');
  }

  Stream<dynamic>? getBroadcastStream() {
    _updateStream ??= _eventChannel.receiveBroadcastStream();
    return _updateStream;
  }

  // request permission. Returns true = already Granted, do not grant again, false = asked for permission
  Future<bool> askUserForPermission() async {
    try {
      var result = await _methodChannel.invokeMethod('askUserForPermission');
      String res = result['AlreadyGranted'];
      bool alreadyGranted = res.toLowerCase() == 'true';
      return alreadyGranted;
    } on PlatformException catch (e) {
      logger.severe("Asking for Android FileSystemPermissions failed. Reason $e");

      return false;
    }
  }

  Future<bool> hasFilesystemPermission() async {
    try {
      var result = await _methodChannel.invokeMethod('hasFilesystemPermission');
      String perm = result['hasPermission'];
      bool hasPermission = perm.toLowerCase() == 'true';
      return hasPermission;
    } on PlatformException catch (e) {
      logger.severe(
          "Checking for Asking for Android FileSystemPermissions failed. Reason $e");

      return false;
    }
  }
}
