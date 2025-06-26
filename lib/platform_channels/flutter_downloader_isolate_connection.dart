import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logging/logging.dart';

import 'flutter_downloader_callback.dart';

class FlutterDownloaderIsolateConnection {
  final Logger logger = Logger('FlutterDownloaderIsolateConnection');

  // port for isolate needed for download progress handler
  final ReceivePort _port = ReceivePort();

  final void Function(String? id, DownloadTaskStatus? status, int? progress)
      onDownloadProgress;

  FlutterDownloaderIsolateConnection(this.onDownloadProgress);

  void startListening() {
    logger.fine("Start listening to downloads");
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen(_onData);
  }

  void _onData(dynamic data) {
    logger.finer("DATA RECEIVED IN UI: $data");
    final String taskId = (data as List<dynamic>)[0] as String;
    final DownloadTaskStatus status =
        DownloadTaskStatus.fromInt(data[1] as int);
    final int progress = data[2] as int;

    logger.finer(
        "Received download update with id: $taskId, status: $status, progress: $progress");
    onDownloadProgress(taskId, status, progress);
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void close() {
    _unbindBackgroundIsolate();
    _port.close();
  }
}
