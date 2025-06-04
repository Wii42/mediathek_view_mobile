import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ws/video_player/custom_chewie_player.dart';
import 'package:video_player/video_player.dart';

class PlayerWithControls extends StatelessWidget {
  const PlayerWithControls({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomChewieController chewieController =
        CustomChewieController.of(context);

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: chewieController.aspectRatio?.aspectRatio ??
              _calculateAspectRatio(context),
          child: _buildPlayerWithControls(chewieController, context),
        ),
      ),
    );
  }

  Widget _buildPlayerWithControls(
      CustomChewieController chewieController, BuildContext context) {
    return Stack(
      children: <Widget>[
        chewieController.placeholder ?? Container(),
        Center(
          child: AspectRatio(
            aspectRatio: chewieController.aspectRatio?.aspectRatio ??
                _calculateAspectRatio(context),
            child: VideoPlayer(chewieController.videoPlayerController),
          ),
        ),
        chewieController.overlay ?? Container(),
        _buildControls(context, chewieController)!,
      ],
    );
  }

  Widget? _buildControls(
    BuildContext context,
    CustomChewieController chewieController,
  ) {
    return chewieController.showControls
        ? chewieController.customControls ??
            (Theme.of(context).platform == TargetPlatform.android
                ? MaterialControls()
                : CupertinoControls(
                    backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
                    iconColor: Color.fromARGB(255, 200, 200, 200),
                  ))
        : Container();
  }

  double _calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return width > height ? width / height : height / width;
  }
}
