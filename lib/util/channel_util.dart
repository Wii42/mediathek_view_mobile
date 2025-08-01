import 'package:flutter/material.dart';
import 'package:flutter_ws/enum/channels.dart';

class ChannelUtil {
  static List<Widget> getAllChannelImages() {
    return [
      for (String assetPath in Channels.channelMap.values)
        Container(
          margin: EdgeInsets.only(left: 2.0, top: 5.0),
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
            image: DecorationImage(
              image: AssetImage('assets/img/$assetPath'),
            ),
          ),
        )
    ];
  }
}
