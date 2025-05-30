import 'package:flutter/material.dart';
import 'package:flutter_ws/enum/channels.dart';
import 'package:flutter_ws/model/channel.dart';
import 'package:flutter_ws/util/text_styles.dart';
import 'package:flutter_ws/widgets/filterMenu/channel_list_tile.dart';
import 'package:flutter_ws/widgets/filterMenu/search_filter.dart';
import 'package:logging/logging.dart';

class ChannelPickerDialog extends StatefulWidget {
  final Logger logger = Logger('ChannelPickerDialog');
  final SearchFilter<Set<String>>? filterPreSelection;
  ChannelPickerDialog(this.filterPreSelection, {super.key});

  @override
  ChannelPickerDialogState createState() => ChannelPickerDialogState();

  Set<String> extractChannelNamesFromCurrentFilter() {
    Set<String> selectedChannels = filterPreSelection?.filterValue ?? {};
    logger.fine("${selectedChannels.length} filters pre-selected");
    return selectedChannels;
  }

  Set<Channel> getSelectedChannels() {
    Set<String> selectedChannels = extractChannelNamesFromCurrentFilter();
    Set<Channel> channels = {};

    Channels.channelMap.forEach((channelName, assetName) => channels.add(
        Channel(
            channelName, assetName, selectedChannels.contains(channelName))));

    return channels;
  }
}

class ChannelPickerDialogState extends State<ChannelPickerDialog> {
  late Set<Channel> channels;
  ChannelPickerDialogState();

  @override
  void initState() {
    super.initState();
    // Initialize channels with the pre-selected filter values
    channels = widget.getSelectedChannels();
  }

  Widget itemBuilder(BuildContext context, int index) {
    return ChannelListTile(channels.elementAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Column(
        children: <Widget>[
          AppBar(
            title: Text('Wähle Sender', style: sectionHeadingTextStyle),
            backgroundColor: Color(0xffffbf00),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, size: 30.0, color: Colors.white),
              onPressed: () {
                //return channels when user pressed back
                return Navigator.pop(
                    context,
                    channels
                        .where((channel) => channel.isCheck == true)
                        .map((channel) => channel.name)
                        .toSet());
              },
            ),
          ),
          Flexible(
            child: ListView.builder(
                itemBuilder: itemBuilder, itemCount: channels.length),
          ),
        ],
      ),
    );
  }
}
