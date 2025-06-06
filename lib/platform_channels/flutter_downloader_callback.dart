import 'dart:isolate';
import 'dart:ui';

// static callback in background thread using an isolate to send the progress to the UI thread
// is in separate file to avoid issues with the DartVM
@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort send =
      IsolateNameServer.lookupPortByName('downloader_send_port')!;
  send.send([id, status, progress]);
}
