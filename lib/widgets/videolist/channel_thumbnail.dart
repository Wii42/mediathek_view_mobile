import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChannelThumbnail extends StatelessWidget {
  final String imgPath;
  final bool isDownloadedAlready;

  const ChannelThumbnail(this.imgPath, this.isDownloadedAlready, {super.key});

  @override
  Widget build(BuildContext context) {
    Uuid uuid = Uuid();

    return Container(
      key: Key(uuid.v1()),
      margin: EdgeInsets.only(left: 2.0),
      alignment: FractionalOffset.topLeft,
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDownloadedAlready ? Colors.green[200] : Colors.grey[300],
        image: DecorationImage(
          image: AssetImage('assets/img/$imgPath'),
        ),
      ),
    );
  }
}
