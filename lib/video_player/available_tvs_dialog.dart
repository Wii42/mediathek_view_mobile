import 'package:flutter/material.dart';
import 'package:flutter_ws/global_state/app_state.dart';
import 'package:flutter_ws/widgets/videolist/circular_progress_with_text.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'tv_player_controller.dart';

class AvailableTVsDialog extends StatefulWidget {
  final TvPlayerController? tvPlayerController;

  const AvailableTVsDialog(this.tvPlayerController, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _AvailableTVsDialogState();
  }
}

class _AvailableTVsDialogState extends State<AvailableTVsDialog> {
  final Logger logger = Logger('_AvailableTVsDialog');
  late VoidCallback listener;

  _AvailableTVsDialogState() {
    listener = () {
      setState(() {});
    };
  }

  @override
  void initState() {
    super.initState();
    // react on value changes (e.g position) on both the flutter as well as the Tv player
    tvPlayerController!.addListener(listener);
  }

  @override
  void deactivate() {
    tvPlayerController!.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var availableTVs = tvPlayerController!.value.availableTvs
        .map((tv) => SimpleDialogOption(
              child: Text(tv,
                  style: TextStyle(color: Colors.white, fontSize: 18.0)),
              onPressed: () {
                logger.info("Connecting to Samsung TV $tv");

                // initialize tvPlayer controller
                if (!widget.tvPlayerController!
                    .isListeningToPlatformChannels()) {
                  widget.tvPlayerController!.initialize();
                }

                context
                    .watch<AppState>()
                    .samsungTVCastManager
                    .checkIfTvIsSupported(tv);
                Navigator.pop(context, true);
              },
            ))
        .toList();
    if (tvPlayerController!.value.playbackOnTvStarted) {
      availableTVs.add(SimpleDialogOption(
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(Color(0xffffbf00))),
          onPressed: () {
            tvPlayerController!.disconnect();
            Navigator.pop(context, true);
          },
          child: Text("Verbindung trennen",
              style: TextStyle(color: Colors.white, fontSize: 20.0)),
        ),
      ));
    }

    return AlertDialog(
      backgroundColor: Colors.grey[800],
      title: CircularProgressWithText(
        Text(
          "Verfügbare Fernseher",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
          softWrap: true,
          maxLines: 2,
        ),
        Colors.grey[800],
        Color(0xffffbf00),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: availableTVs,
        ),
      ),
    );
  }

  TvPlayerController? get tvPlayerController => widget.tvPlayerController;
}
