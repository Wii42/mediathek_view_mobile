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
  final void Function(SearchFilterType) onSingleFilterTapped;
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
          getFilterMenuRow(
              "Thema", SearchFilterType.topic, _themaFieldController,
              theme: theme),
          getFilterMenuRow(
              "Titel", SearchFilterType.title, _titleFieldController,
              theme: theme),
          getChannelRow(context),
          getIncludeFutureVideosSwitch(),
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

  void handleTapOnFilter(SearchFilterType type) {
    logger.fine("Filter with type $type was tapped");
    widget.onSingleFilterTapped(type);
  }

  Widget getFilterMenuRow(String displayText, SearchFilterType filterType,
      TextEditingController? controller,
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
                  filterValue: value,
                  displayText: displayText,
                  handleTabCallback: handleTapOnFilter,
                  filterType: filterType,
                ),
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
            displayText: displayText,
            filterValue: currentValueOfFilter,
            handleTabCallback: handleTapOnFilter,
            filterType: filterType,
          ),
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
        filterValue: channelSelection,
        displayText: displayText,
        handleTabCallback: handleTapOnFilter,
        filterType: SearchFilterType.channels);

    widget.onFilterUpdated(channelFilter);
  }

  Row getRangeSliderRow() {
    SearchFilter<(double, double)> lengthFilter;
    (double, double) filterValue;
    if (widget.searchFilters.videoLength != null) {
      filterValue = widget.searchFilters.videoLength!.filterValue;
    } else {
      filterValue = (-1.0, -1.0);
    }
    lengthFilter = SearchFilter<(double, double)>(
      displayText: "Länge",
      filterValue: filterValue,
      handleTabCallback: handleTapOnFilter,
      filterType: SearchFilterType.videoLength,
    );

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

  Widget getIncludeFutureVideosSwitch() {
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
              "Zukünftige Videos",
              style: TextStyle(
                  color: widget.fontColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Switch(
          value: widget.searchFilters.includeFutureVideos?.filterValue ?? false,
          onChanged: (bool isEnabled) {
            widget.onFilterUpdated(SearchFilter<bool>(
              filterValue: isEnabled,
              displayText: "Zukünftige Videos",
              handleTabCallback: handleTapOnFilter,
              filterType: SearchFilterType.includeFutureVideos,
            ));
          },
        ),
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
