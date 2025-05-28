import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ws/model/video.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/util/timestamp_calculator.dart';
import 'package:flutter_ws/widgets/videolist/channel_thumbnail.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoDescription extends StatelessWidget {
  final Video video;
  final String channelPictureImagePath;
  final double verticalOffset;

  const VideoDescription(
      this.video, this.channelPictureImagePath, this.verticalOffset, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: verticalOffset - 15.0),
      child: Stack(
        children: <Widget>[
          GestureDetector(child: getBody(context)),
          Padding(
            padding: const EdgeInsets.only(left: 9.0),
            child: channelPictureImagePath.isNotEmpty
                ? ChannelThumbnail(channelPictureImagePath, false)
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget getBody(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 10.0, top: 10),
          child: Container(
            //height: 400.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  bottomLeft: const Radius.circular(40.0),
                  bottomRight: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0)),
              color: Color(0xffffbf00).withOpacity(0.4),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 10.0, bottom: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    getVerticalDividerLine(bottom: 15.0),
                    getCaption("Titel", textTheme),
                    Text(
                      video.title!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge?.
                          copyWith(color: Colors.black, fontSize: 15.0),
                    ),
                    //getSpacedContentRow(video.title),
                    getDivider(),
                    getCaption("Thema", textTheme),
                    Text(
                      video.topic!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge?.
                          copyWith(color: Colors.black, fontSize: 15.0),
                    ),
                    getDivider(),
                    getCaption("Länge", textTheme),
                    Text(
                      Calculator.calculateDuration(video.duration),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge?.
                          copyWith(color: Colors.black, fontSize: 15.0),
                    ),
                    getDivider(),
                    getCaption("Ausgestrahlt", textTheme),
                    Text(
                      Calculator.calculateTimestamp(video.timestamp!),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge?.
                          copyWith(color: Colors.black, fontSize: 15.0),
                    ),
                    video.description != null && video.description!.isNotEmpty
                        ? getDivider()
                        : Container(),
                    video.description != null && video.description!.isNotEmpty
                        ? getCaption("Beschreibung", textTheme)
                        : Container(),
                    video.description != null && video.description!.isNotEmpty
                        ? Text('"${video.description}"',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontStyle: FontStyle.italic))
                        : Container(),
                    getDivider(),
                    video.url_website != null
                        ? TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.grey[800]),
                            child: Text('Website', style: body2TextStyle),
                            onPressed: () => _launchURL(Uri.parse(video.url_website!)),
                          )
                        : Container(),
                    getVerticalDividerLine(top: 15.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container getDivider() {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
    );
  }

  Text getCaption(String caption, TextTheme textTheme) {
    return Text(
      caption,
      style: textTheme.titleLarge?.copyWith(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
    );
  }

  Container getVerticalDividerLine({double? bottom, double? top}) {
    return Container(
      height: 2.0,
      color: Colors.grey,
      margin: bottom != null
          ? EdgeInsets.only(left: 20, right: 20.0, bottom: bottom)
          : EdgeInsets.only(left: 20, right: 20.0, top: top!),
    );
  }

  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
