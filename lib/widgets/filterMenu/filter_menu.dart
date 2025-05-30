import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ws/widgets/filterMenu/channel_picker.dart';
import 'package:flutter_ws/widgets/filterMenu/filtermenu_channel_edit_button.dart';
import 'package:flutter_ws/widgets/filterMenu/search_filter.dart';
import 'package:flutter_ws/widgets/filterMenu/video_length_slider.dart';
import 'package:logging/logging.dart';

import '../../global_state/filter_menu_state.dart';

class FilterMenu extends StatefulWidget {
  final void Function(SearchFilter) onFilterUpdated;
  final void Function(String) onSingleFilterTapped;
  final void Function() onChannelsSelected;
  final SearchFilters searchFilters;
  final Color fontColor;

  const FilterMenu(
      {super.key,
      required this.onFilterUpdated,
      required this.searchFilters,
      required this.onSingleFilterTapped,
      required this.onChannelsSelected,
      this.fontColor = Colors.white});

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  final Logger logger = Logger('FilterMenu');

  late TextEditingController _titleFieldController;

  late TextEditingController _themaFieldController;

  @override
  void initState() {
    _titleFieldController = widget.searchFilters.title != null
        ? TextEditingController(text: widget.searchFilters.title!.filterValue)
        : TextEditingController();

    _themaFieldController = widget.searchFilters.topic != null
        ? TextEditingController(text: widget.searchFilters.topic!.filterValue)
        : TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    logger.fine("Rendering filter Menu");

    return Container(
      decoration: BoxDecoration(
        color: Color(0xffffbf00),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          getFilterMenuRow("Thema", "Thema", _themaFieldController,
              theme: theme),
          getFilterMenuRow("Titel", "Titel", _titleFieldController,
              theme: theme),
          getChannelRow(context),
          getRangeSliderRow(),
        ],
      ),
    );
  }

  Row getChannelRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
//            crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            width: 80.0,
            child: Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "Sender",
                  style: TextStyle(
                      color: widget.fontColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.start,
                ))),
        widget.searchFilters.channels == null ||
                widget.searchFilters.channels!.filterValue.isEmpty
            ? Switch(
                value: false,
                onChanged: (bool isEnabled) {
                  if (isEnabled) {
                    logger.fine("User enabled channel switch");
                    _openAddEntryDialog(context);
                  }
                })
            : FilterMenuChannelEditButton(
                handleTabCallback: _openAddEntryDialog,
                icon: Icon(Icons.edit, size: 50.0),
                displayText: "Sender"),
      ],
    );
  }

  void handleTapOnFilter(String id) {
    logger.fine("Filter with id $id was tapped");
    widget.onSingleFilterTapped(id);
  }

  Widget getFilterMenuRow(
      String filterId, String displayText, TextEditingController? controller,
      {required ThemeData theme}) {
    var filterTextFocus = FocusNode();

    Row row = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 80.0,
          child: Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Text(
              displayText,
              style: TextStyle(
                  color: widget.fontColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            focusNode: filterTextFocus,
            onSubmitted: (String value) {
              widget.onFilterUpdated(
                SearchFilter<String>(
                    filterId: filterId,
                    filterValue: value,
                    handleTabCallback: handleTapOnFilter),
              );
            },
            style: TextStyle(
                color: widget.fontColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w700),
            controller: controller,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              contentPadding: EdgeInsets.only(bottom: 0.0),
//              counterStyle: buttonTextStyle,
              hintStyle: theme.textTheme.headlineMedium,
            ),
          ),
        ),
      ],
    );

    filterTextFocus.addListener(() {
      if (!filterTextFocus.hasFocus) {
        String currentValueOfFilter = controller!.text;
        widget.onFilterUpdated(
          SearchFilter<String>(
              filterId: filterId,
              filterValue: currentValueOfFilter,
              handleTabCallback: handleTapOnFilter),
        );
      }
    });

    return Padding(padding: EdgeInsets.only(bottom: 10.0), child: row);
  }

  Future _openAddEntryDialog(BuildContext context) async {
    Set<String> channelSelection =
        (await Navigator.of(context).push(MaterialPageRoute<Set<String>>(
            builder: (BuildContext context) {
              return ChannelPickerDialog(widget.searchFilters.channels);
            },
            fullscreenDialog: true,
            settings: RouteSettings(name: "ChannelPicker"))))!;

    logger.fine("Channel selection received");

    String displayText = "Sender: ${channelSelection.length}";

    logger.fine(
        "Sender filter: value: $channelSelection DisplayText: $displayText");

    SearchFilter<Set<String>> channelFilter = SearchFilter<Set<String>>(
        filterId: "Sender",
        filterValue: channelSelection,
        displayText: displayText,
        handleTabCallback: handleTapOnFilter);

    widget.onFilterUpdated(channelFilter);
  }

  Row getRangeSliderRow() {
    SearchFilter<(double, double)> lengthFilter;
    if (widget.searchFilters.videoLength != null) {
      lengthFilter = SearchFilter<(double, double)>(
          filterId: "Länge",
          filterValue: widget.searchFilters.videoLength!.filterValue,
          handleTabCallback: handleTapOnFilter);
    } else {
      lengthFilter = SearchFilter<(double, double)>(
        filterId: "Länge",
        handleTabCallback: handleTapOnFilter,
        filterValue: (-1.0, -1.0),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 80.0,
          child: Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: Text(
              "Länge",
              style: TextStyle(
                  color: widget.fontColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Flexible(
            child: VideoLengthSlider(widget.onFilterUpdated, lengthFilter)),
      ],
    );
  }

  @override
  void dispose() {
    _titleFieldController.dispose();
    _themaFieldController.dispose();
    super.dispose();
  }
}
