import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'floating_mini_player_state.dart';

class MiniPlayerOverlay extends StatelessWidget {
  /// widget that is underneath the mini player overlay
  final Widget child;

  const MiniPlayerOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer<FloatingMiniPlayerState>(
          child: child,
          builder: (context, miniPlayerState, child) {
            if (miniPlayerState.isHidden) {
              return child!;
            }
            return Stack(
              children: [
                child!,
                overlayWidget(
                  miniPlayerState,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget overlayWidget(
    FloatingMiniPlayerState state, {
    required double width,
    required double height,
  }) {
    Widget? miniPlayer = state.floatingMiniPlayer;
    Size? scaledSize = state.scaledWidgetSize;
    if (miniPlayer == null || scaledSize == null) {
      return SizedBox.shrink();
    }
    return Positioned(
      left: fromRelative(state.relativeOffset.dx, width) - scaledSize.width / 2,
      top:
          fromRelative(state.relativeOffset.dy, height) - scaledSize.height / 2,
      child: GestureDetector(
          child: ConstrainedBox(
              constraints: BoxConstraints.loose(scaledSize), child: miniPlayer),
          onScaleUpdate: (details) {
            Offset change = details.focalPointDelta;
            state.updatePositionByRelativeDelta(
              dx: toRelative(change.dx, width),
              dy: toRelative(change.dy, height),
            );
            if (details.pointerCount > 1) {
              state.updateScalingFactor(details.scale);
            }
          },
          onScaleEnd: (_) {
            if (state.scalingFactor < 1) {
              state.updateScalingFactor(1);
            }
            state.updateRelativePosition(
              x: state.relativeOffset.dx.clamp(0, 1),
              y: state.relativeOffset.dy.clamp(0, 1),
            );
          }),
    );
  }

  static double fromRelative(double relative, double size) {
    return relative * size;
  }

  static double toRelative(double absolute, double size) {
    return absolute / size;
  }
}
