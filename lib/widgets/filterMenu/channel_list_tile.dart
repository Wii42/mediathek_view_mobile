import 'package:flutter/material.dart';
import 'package:flutter_ws/model/channel.dart';
import 'package:flutter_ws/util/text_styles.dart';

class ChannelListTile extends StatefulWidget {
  final Channel channel;

  ChannelListTile(Channel product)
      : channel = product,
        super(key: ObjectKey(product));

  @override
  ChannelListTileState createState() {
    return ChannelListTileState();
  }
}

class ChannelListTileState extends State<ChannelListTile> {
  Channel get channel => widget.channel;

  ChannelListTileState();

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          setState(() {
            channel.isCheck = !channel.isCheck!;
          });
        },
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Image(image: AssetImage("assets/img/${channel.avatarImage}")),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Text(channel.name, style: body2TextStyle)),
            Checkbox(
                value: channel.isCheck,
                activeColor: Colors.grey[800],
                onChanged: (bool? value) {
                  setState(() {
                    channel.isCheck = value;
                  });
                })
          ],
        ));
  }
}
