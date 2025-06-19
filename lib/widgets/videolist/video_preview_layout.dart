import 'package:flutter/material.dart';

class VideoPreviewLayout extends StatelessWidget {
  final double? width;
  final Widget child;
  final List<Widget> overlayWidgets;

  const VideoPreviewLayout({
    super.key,
    this.width,
    required this.child,
    this.overlayWidgets = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Column is needed for correct padding of the widget
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Container(
            color: Colors.grey[100],
            width: width,
            child: Stack(
              children: [
                child,
                ...overlayWidgets,
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
